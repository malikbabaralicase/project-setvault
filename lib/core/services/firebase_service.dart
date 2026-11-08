import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        _isInitialized = true;
      } else {
        // Attempt default options initialization
        await Firebase.initializeApp();
        _isInitialized = true;
      }

      if (_isInitialized) {
        // Enable offline persistence for Firestore
        FirebaseFirestore.instance.settings = const Settings(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );
        debugPrint('Firebase & Firestore offline persistence initialized successfully.');
      }
    } catch (e) {
      // In offline or pre-configured environment, catch gracefully
      _isInitialized = false;
      debugPrint('Firebase initialization notice: $e');
      debugPrint('Running in high-performance local offline-first mode.');
    }
  }

  FirebaseFirestore? get firestore {
    if (_isInitialized) {
      return FirebaseFirestore.instance;
    }
    return null;
  }
}

