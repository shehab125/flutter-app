import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:smart_medical_box_app/core/services/firebase_service.dart';
import 'package:smart_medical_box_app/core/services/auth_service.dart';
import 'package:smart_medical_box_app/core/services/notification_service.dart';
import 'package:smart_medical_box_app/features/shared/screens/login_screen.dart';
import 'package:smart_medical_box_app/features/shared/screens/splash_screen.dart';
import 'package:smart_medical_box_app/features/patient_interface/screens/dashboard_screen.dart';
import 'package:smart_medical_box_app/features/doctor_interface/screens/doctor_dashboard_screen.dart';
import 'package:smart_medical_box_app/shared/theme/app_theme.dart';
import 'package:smart_medical_box_app/core/providers/auth_provider.dart';
import 'package:smart_medical_box_app/core/providers/medication_provider.dart';
import 'package:smart_medical_box_app/core/models/user.dart';

Future<void> initializeFirebase() async {
  try {
    // Initialize Firebase first
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAz_HT31p9DASCgCWkmugA_KYxJ4SOI3xU',
        appId: '1:89563659646:android:8b631c7ecb3a64f55b472f',
        messagingSenderId: '89563659646',
        projectId: 'alpha-ba8b9',
        storageBucket: 'alpha-ba8b9.firebasestorage.app',
      ),
    );

    print('Firebase core initialized');

    // Configure Firestore settings with more lenient timeout
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      sslEnabled: true,
      host: 'firestore.googleapis.com',
    );

    print('Firestore settings configured');

    // Try to enable network with retry
    int retryCount = 0;
    while (retryCount < 3) {
      try {
        await FirebaseFirestore.instance.enableNetwork();
        print('Network enabled successfully on attempt ${retryCount + 1}');
        
        // Test connection with a simple query
        await FirebaseFirestore.instance
            .collection('users')
            .limit(1)
            .get(const GetOptions(source: Source.server))
            .timeout(const Duration(seconds: 15));
            
        print('Firestore connection verified');
        break;
      } catch (e) {
        retryCount++;
        print('Connection attempt $retryCount failed: $e');
        if (retryCount < 3) {
          await Future.delayed(Duration(seconds: retryCount * 2));
        }
      }
    }

    print('Firebase initialization completed');
  } catch (e) {
    print('Firebase initialization error: $e');
    if (e is FirebaseException) {
      print('Firebase error code: ${e.code}');
      print('Firebase error message: ${e.message}');
    }
    // Don't rethrow - allow app to continue in offline mode
  }
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Firebase
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAz_HT31p9DASCgCWkmugA_KYxJ4SOI3xU',
        appId: '1:89563659646:android:8b631c7ecb3a64f55b472f',
        messagingSenderId: '89563659646',
        projectId: 'alpha-ba8b9',
        storageBucket: 'alpha-ba8b9.firebasestorage.app',
      ),
    );

    // Initialize Firebase services
    final firebaseService = FirebaseService();
    await firebaseService.initialize();
    
    // Initialize notification service
    final notificationService = NotificationService();
    await notificationService.initialize();
    
    runApp(const MyApp());
  } catch (e) {
    print('Fatal error during initialization: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'حدث خطأ أثناء الاتصال بالخدمة',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      // Try to enable network before retrying
                      await FirebaseFirestore.instance.enableNetwork();
                      print('Network re-enabled');
                    } catch (e) {
                      print('Warning: Could not enable network: $e');
                    }
                    main();
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Determine theme based on user type
          final isDoctor = authProvider.currentUser?.userType == UserType.doctor;
          
          return MaterialApp(
            title: 'Smart Medical Box',
            theme: AppTheme.getThemeByUserType(isDoctor, false),
            darkTheme: AppTheme.getThemeByUserType(isDoctor, true),
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            home: AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Show splash screen only on first load
        if (authProvider.isInitializing) {
          return const SplashScreen();
        }
        
        // Show login screen if not authenticated
        if (!authProvider.isAuthenticated) {
          return const LoginScreen();
        }
        
        // Debug print to check user type
        print('Current user type: ${authProvider.currentUser?.userType}');
        
        // Show appropriate dashboard based on user type
        if (authProvider.currentUser?.userType == UserType.doctor) {
          print('Navigating to doctor dashboard');
          return const DoctorDashboardScreen();
        } else {
          print('Navigating to patient dashboard');
          return const PatientDashboardScreen();
        }
      },
    );
  }
}
