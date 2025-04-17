import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Firebase services
  final firebaseService = FirebaseService();
  await firebaseService.initialize();
  
  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()),
      ],
      child: MaterialApp(
        title: 'Smart Medical Box',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Show splash screen while checking authentication state
        if (authProvider.isInitializing) {
          return const SplashScreen();
        }
        
        // Show error screen if there's an error
        if (authProvider.error != null) {
          return Scaffold(
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
                  Text(
                    authProvider.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      authProvider.signOut();
                    },
                    child: const Text('العودة لتسجيل الدخول'),
                  ),
                ],
              ),
            ),
          );
        }
        
        // Show login screen if not authenticated or no user data
        if (!authProvider.isAuthenticated || authProvider.currentUser == null) {
          return const LoginScreen();
        }
        
        // Show appropriate dashboard based on user type
        if (authProvider.currentUser?.userType == UserType.doctor) {
          return const DoctorDashboardScreen();
        } else {
          return const PatientDashboardScreen();
        }
      },
    );
  }
}
