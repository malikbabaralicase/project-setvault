import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/mock_data_repository.dart';

class SettingsProvider extends ChangeNotifier {
  final MockDataRepository _repository = MockDataRepository();

  bool _glowEffectsEnabled = true;
  bool _notificationsEnabled = true;
  String _unit = 'kg';

  UserModel get user => _repository.currentUser;
  bool get glowEffectsEnabled => _glowEffectsEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  String get unit => _unit;

  void toggleGlowEffects(bool value) {
    _glowEffectsEnabled = value;
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void setUnit(String unit) {
    _unit = unit;
    notifyListeners();
  }
}
