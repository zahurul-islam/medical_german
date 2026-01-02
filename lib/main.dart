/// Main entry point for MedDeutsch app
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'core/firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Print error and continue without Firebase for debugging
    debugPrint('Firebase initialization failed: $e');
  }
  
  runApp(
    const ProviderScope(
      child: MedDeutschApp(),
    ),
  );
}
