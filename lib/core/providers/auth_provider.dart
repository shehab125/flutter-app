import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_medical_box_app/core/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  User? _firebaseUser;
  AppUser? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isInitializing = true;

  User? get firebaseUser => _firebaseUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _firebaseUser != null && _currentUser != null;
  bool get isInitializing => _isInitializing;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _firebaseUser = null;
      _currentUser = null;
      _isInitializing = false;
      notifyListeners();
      return;
    }

    try {
      _firebaseUser = firebaseUser;
      
      final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (userDoc.exists) {
        _currentUser = AppUser.fromMap(userDoc.data()!, firebaseUser.uid);
        _error = null;
      } else {
        _error = 'لم يتم العثور على بيانات المستخدم في قاعدة البيانات';
        _currentUser = null;
        await signOut();
      }
    } catch (e) {
      _error = 'حدث خطأ أثناء تحميل بيانات المستخدم: ${e.toString()}';
      _currentUser = null;
      await signOut();
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      if (email.isEmpty || password.isEmpty) {
        _error = 'الرجاء إدخال البريد الإلكتروني وكلمة المرور';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case 'user-not-found':
          _error = 'لم يتم العثور على حساب بهذا البريد الإلكتروني';
          break;
        case 'wrong-password':
          _error = 'كلمة المرور غير صحيحة';
          break;
        case 'invalid-email':
          _error = 'البريد الإلكتروني غير صالح';
          break;
        case 'user-disabled':
          _error = 'تم تعطيل هذا الحساب. الرجاء التواصل مع الدعم الفني';
          break;
        case 'too-many-requests':
          _error = 'تم تجاوز عدد المحاولات المسموح بها. الرجاء المحاولة لاحقاً';
          break;
        case 'operation-not-allowed':
          _error = 'تم تعطيل تسجيل الدخول بالبريد الإلكتروني وكلمة المرور';
          break;
        default:
          _error = 'حدث خطأ أثناء تسجيل الدخول: ${e.message}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = 'حدث خطأ غير متوقع: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(
    String email,
    String password,
    String name,
    String phone,
    String address,
    String userType,
    Map<String, dynamic>? additionalData,
  ) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // التحقق من صحة البيانات
      if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty || address.isEmpty) {
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
      
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      final user = userCredential.user;
      if (user != null) {
        UserType type = userType.toLowerCase() == 'doctor'
            ? UserType.doctor
            : UserType.patient;
        
        final appUser = AppUser(
          id: user.uid,
          email: email.trim(),
          name: name.trim(),
          phone: phone.trim(),
          address: address.trim(),
          userType: type,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          additionalData: additionalData,
        );
        
        await _firestore.collection('users').doc(user.uid).set(appUser.toMap());
        
        _currentUser = appUser;
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case 'weak-password':
          _error = 'كلمة المرور ضعيفة جداً. يجب أن تكون 6 أحرف على الأقل';
          break;
        case 'email-already-in-use':
          _error = 'البريد الإلكتروني مستخدم بالفعل. الرجاء استخدام بريد إلكتروني آخر';
          break;
        case 'invalid-email':
          _error = 'البريد الإلكتروني غير صالح';
          break;
        case 'operation-not-allowed':
          _error = 'تم تعطيل إنشاء الحسابات بالبريد الإلكتروني وكلمة المرور';
          break;
        case 'too-many-requests':
          _error = 'تم تجاوز عدد المحاولات المسموح بها. الرجاء المحاولة لاحقاً';
          break;
        default:
          _error = 'حدث خطأ أثناء إنشاء الحساب: ${e.message}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = 'حدث خطأ غير متوقع: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // تسجيل الخروج من Firebase Auth
      await _auth.signOut();
      
      // تسجيل الخروج من Google
      if (_googleSignIn.currentUser != null) {
        await _googleSignIn.signOut();
      }
      
      // إعادة تعيين حالة المستخدم
      _firebaseUser = null;
      _currentUser = null;
      _error = null;
      
    } catch (e) {
      _error = 'حدث خطأ أثناء تسجيل الخروج: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      await _auth.sendPasswordResetEmail(email: email);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case 'user-not-found':
          _error = 'لم يتم العثور على مستخدم بهذا البريد الإلكتروني';
          break;
        case 'invalid-email':
          _error = 'البريد الإلكتروني غير صالح';
          break;
        default:
          _error = 'حدث خطأ أثناء إرسال رابط إعادة تعيين كلمة المرور: ${e.message}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = 'حدث خطأ غير متوقع';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      if (_firebaseUser != null && _currentUser != null) {
        await _firestore.collection('users').doc(_firebaseUser!.uid).update(data);
        
        // Update current user
        final userDoc = await _firestore.collection('users').doc(_firebaseUser!.uid).get();
        if (userDoc.exists) {
          _currentUser = AppUser.fromMap(userDoc.data()!, _firebaseUser!.uid);
        }
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
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
    _firebaseUser = null;
    _currentUser = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
