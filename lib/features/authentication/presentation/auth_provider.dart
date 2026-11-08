import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser ?? _authService.currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isAnonymous => _currentUser?.isAnonymous ?? false;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _initUser();
  }

  void _initUser() {
    // Start with default authenticated state for smooth experience
    _currentUser = _authService.currentUser ??
        const UserModel(
          id: 'user_alex_01',
          name: 'Alex Morgan',
          email: 'alex.morgan@example.com',
          username: 'alexm',
          totalWorkouts: 24,
          trainingVolumeKg: 128450.0,
          totalSets: 186,
          streakDays: 4,
          isAdmin: true,
          isAnonymous: false,
        );
  }

  /// Anonymous guest authentication so athletes can log immediately
  Future<bool> signInAnonymously() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.signInAnonymously();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (email.trim().isEmpty || password.trim().isEmpty) {
      _errorMessage = 'Please enter both email and password';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      _currentUser = await _authService.signInWithEmail(
        email: email.trim(),
        password: password.trim(),
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _errorMessage = 'All fields are required';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      _errorMessage = 'Passwords do not match';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      // If currently anonymous, perform account linking to preserve workout data!
      if (_currentUser != null && _currentUser!.isAnonymous) {
        _currentUser = await _authService.linkAnonymousAccount(
          email: email.trim(),
          password: password.trim(),
          name: name.trim(),
        );
      } else {
        _currentUser = await _authService.registerWithEmail(
          name: name.trim(),
          email: email.trim(),
          password: password.trim(),
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Upgrades an anonymous user account to Email/Password
  Future<bool> linkAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.linkAnonymousAccount(
        email: email.trim(),
        password: password.trim(),
        name: name.trim(),
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    if (email.trim().isEmpty) {
      _errorMessage = 'Please provide an email address';
      notifyListeners();
      return false;
    }
    try {
      await _authService.sendPasswordReset(email.trim());
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    await _authService.deleteAccount();
    _currentUser = null;
    notifyListeners();
  }
}
