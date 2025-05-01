import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_medical_box_app/core/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AppUser? _currentUser;
  bool _isInitializing = true;
  String? _error;
  bool _isOffline = false;
  bool _isLoading = false;

  AuthProvider() {
    _initializeAuth();
  }

  // Getters
  AppUser? get currentUser => _currentUser;
  bool get isInitializing => _isInitializing;
  bool get isAuthenticated => _currentUser != null;
  String? get error => _error;
  bool get isOffline => _isOffline;
  bool get isLoading => _isLoading;

  Future<void> _initializeAuth() async {
    try {
      _auth.authStateChanges().listen((User? firebaseUser) async {
        if (firebaseUser == null) {
          _currentUser = null;
          _isInitializing = false;
          notifyListeners();
        } else {
          // Don't set a default user immediately, wait for Firestore data
          _isInitializing = true;
          notifyListeners();

          // Load user data from Firestore to get the correct user type
          await _loadUserDataFromFirestore(firebaseUser);
        }
      });
    } catch (e) {
      _error = e.toString();
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<void> _loadUserDataFromFirestore(User firebaseUser) async {
    try {
      // Try to get user document
      final doc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get(const GetOptions(source: Source.serverAndCache));

      if (doc.exists) {
        final userData = doc.data() as Map<String, dynamic>;
        print('Loaded user data: $userData'); // Debug log

        // Convert userType string to enum
        String userTypeStr = userData['userType'] ?? 'patient';
        UserType userType = userTypeStr.toLowerCase() == 'doctor'
            ? UserType.doctor
            : UserType.patient;

        print('Determined user type: $userType'); // Debug log

        _currentUser = AppUser(
          id: firebaseUser.uid,
          email: userData['email'] ?? '',
          name: userData['name'] ?? '',
          phoneNumber: userData['phoneNumber'] ?? '',
          address: userData['address'] ?? '',
          userType: userType,
          createdAt: (userData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          updatedAt: (userData['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          additionalData: userData['additionalData'] as Map<String, dynamic>?,
        );

        print('Current user updated: ${_currentUser?.userType}'); // Debug log
      } else {
        print('User document not found, creating default'); // Debug log
        // Create new user document if it doesn't exist
        final defaultUser = AppUser(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName ?? 'مستخدم جديد',
          userType: UserType.patient, // Default for new users
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(firebaseUser.uid).set(
          defaultUser.toMap(),
          SetOptions(merge: true),
        );

        _currentUser = defaultUser;
      }
    } catch (e) {
      print('Error loading user data: $e');
      // Create a basic user as fallback
      _currentUser = AppUser(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: firebaseUser.displayName ?? 'مستخدم جديد',
        userType: UserType.patient, // Fallback type
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _isOffline = true;
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  // This method is replaced by _loadUserDataFromFirestore
  // Keeping it for backward compatibility but it's no longer used
  Future<void> _loadUserDataInBackground(User firebaseUser) async {
    // Delegate to the new method
    await _loadUserDataFromFirestore(firebaseUser);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Sign in with Firebase Auth
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Get user data from Firestore
        final doc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (doc.exists) {
          final userData = doc.data() as Map<String, dynamic>;
          print('Login - Found user data: $userData'); // Debug log

          // Explicitly handle user type conversion
          String userTypeStr = userData['userType'] ?? 'patient';
          UserType userType = userTypeStr.toLowerCase() == 'doctor'
              ? UserType.doctor
              : UserType.patient;

          print('Login - User type from Firestore: $userTypeStr, converted to: $userType');

          _currentUser = AppUser(
            id: userCredential.user!.uid,
            email: userData['email'] ?? '',
            name: userData['name'] ?? '',
            phoneNumber: userData['phoneNumber'] ?? '',
            address: userData['address'] ?? '',
            userType: userType,
            createdAt: (userData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            updatedAt: (userData['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            additionalData: userData['additionalData'] as Map<String, dynamic>?,
          );

          print('Login - Current user set with type: ${_currentUser?.userType}');
          _error = null;
        } else {
          _error = 'لم يتم العثور على بيانات المستخدم';
          await _auth.signOut();
          _currentUser = null;
        }
      }
    } on FirebaseAuthException catch (e) {
      _error = _getMessageFromErrorCode(e.code);
      _currentUser = null;
    } catch (e) {
      _error = 'حدث خطأ أثناء تسجيل الدخول';
      print('Login error: $e');
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'user-disabled':
        return 'تم تعطيل هذا الحساب';
      case 'user-not-found':
        return 'لم يتم العثور على مستخدم بهذا البريد الإلكتروني';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'network-request-failed':
        return 'فشل الاتصال بالشبكة';
      case 'too-many-requests':
        return 'تم تجاوز عدد محاولات تسجيل الدخول المسموح بها. الرجاء المحاولة لاحقاً';
      case 'unavailable':
        return 'الخدمة غير متوفرة حالياً. الرجاء المحاولة لاحقاً';
      default:
        return 'حدث خطأ غير متوقع: $errorCode';
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'حدث خطأ أثناء تسجيل الخروج: ${e.toString()}';
      notifyListeners();
      throw _error!;
    }
  }

  Future<bool> signUp(
      String email,
      String password,
      String name,
      String phoneNumber,
      String address,
      String userType,
      Map<String, dynamic>? additionalData,
      ) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('Starting signup process for userType: $userType'); // Debug log

      if (email.isEmpty || password.isEmpty || name.isEmpty || phoneNumber.isEmpty || address.isEmpty) {
        _error = 'الرجاء إدخال جميع البيانات المطلوبة';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.length < 6) {
        _error = 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        // Convert userType string to enum
        final type = userType.toLowerCase() == 'doctor' ? UserType.doctor : UserType.patient;
        print('User type determined as: $type'); // Debug log

        // Create user data map
        final userData = {
          'id': user.uid,
          'email': email.trim(),
          'name': name.trim(),
          'phoneNumber': phoneNumber.trim(),
          'address': address.trim(),
          'userType': userType.toLowerCase(), // Store as lowercase string
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          if (additionalData != null) ...additionalData,
        };

        print('Saving user data: $userData'); // Debug log

        // Save user data to Firestore
        await _firestore.collection('users').doc(user.uid).set(userData);

        // Create AppUser instance
        _currentUser = AppUser(
          id: user.uid,
          email: email.trim(),
          name: name.trim(),
          phoneNumber: phoneNumber.trim(),
          address: address.trim(),
          userType: type,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          additionalData: additionalData,
        );

        print('Current user set as: ${_currentUser?.userType}'); // Debug log

        // Verify the user type was saved correctly
        final savedDoc = await _firestore.collection('users').doc(user.uid).get();
        if (savedDoc.exists) {
          final savedData = savedDoc.data() as Map<String, dynamic>;
          print('Verified saved user type: ${savedData['userType']}'); // Debug log
        }

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('Error during signup: $e'); // Debug log
      _isLoading = false;
      _error = e is FirebaseAuthException
          ? _getMessageFromErrorCode(e.code)
          : 'حدث خطأ أثناء إنشاء الحساب';
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      notifyListeners();
      return true;
    } catch (e) {
      _error = _getMessageFromErrorCode((e as FirebaseAuthException).code);
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    try {
      if (_currentUser != null) {
        await _firestore.collection('users').doc(_currentUser!.id).update(data);
        await _loadUserDataInBackground(await _auth.currentUser!);
      }
      return true;
    } catch (e) {
      _error = 'حدث خطأ أثناء تحديث الملف الشخصي';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void reset() {
    _currentUser = null;
    _error = null;
    _isInitializing = false;
    notifyListeners();
  }
}
