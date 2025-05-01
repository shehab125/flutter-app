import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  Future<void> initialize() async {
    try {
      // Configure Firestore for offline support
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      // Try to enable network with timeout
      try {
        await FirebaseFirestore.instance
            .enableNetwork()
            .timeout(const Duration(seconds: 5));
        print('Firestore network enabled in FirebaseService');
      } catch (e) {
        print('Warning: Could not enable Firestore network in service: $e');
        // Try to use offline persistence
        try {
          await FirebaseFirestore.instance.disableNetwork();
          print('Switched to offline mode');
        } catch (offlineError) {
          print('Error switching to offline mode: $offlineError');
        }
      }

      print('Firebase service initialized');
    } catch (e) {
      print('Warning: Firebase service initialization error: $e');
      // Don't throw the error, just log it
    }
  }

  Future<void> retryConnection() async {
    try {
      await FirebaseFirestore.instance.enableNetwork();
      print('Network connection restored');
    } catch (e) {
      print('Failed to restore network connection: $e');
    }
  }

  Future<void> _testConnectionWithRetry({int maxAttempts = 3}) async {
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        // Try to get a small document to test connection
        await FirebaseFirestore.instance.collection('test').limit(1).get();
        return;
      } catch (e) {
        if (attempt == maxAttempts - 1) {
          rethrow;
        }
        // Wait with exponential backoff before retrying
        await Future.delayed(Duration(seconds: (attempt + 1) * 2));
      }
    }
  }
}