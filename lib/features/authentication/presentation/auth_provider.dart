import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/mock_data_repository.dart';

class AuthProvider extends ChangeNotifier {
  final MockDataRepository _repository = MockDataRepository();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser ?? _repository.currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    // Default to logged-in user for smooth UX in Part 1
    _currentUser = _repository.currentUser;
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    if (username.trim().isEmpty || password.trim().isEmpty) {
      _errorMessage = 'Please enter both username and password';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _currentUser = _repository.currentUser;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String name,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    if (name.isEmpty || username.isEmpty || password.isEmpty) {
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

    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: '$username@example.com',
      username: username,
      totalWorkouts: 0,
      trainingVolumeKg: 0,
      totalSets: 0,
      streakDays: 1,
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
