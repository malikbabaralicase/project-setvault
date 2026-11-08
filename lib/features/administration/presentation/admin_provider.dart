import 'package:flutter/material.dart';
import '../../../data/repositories/mock_data_repository.dart';

class SecurityEvent {
  final String event;
  final String timestamp;
  final String severity;

  const SecurityEvent({
    required this.event,
    required this.timestamp,
    required this.severity,
  });
}

class AdminProvider extends ChangeNotifier {
  final MockDataRepository _repository = MockDataRepository();

  Map<String, dynamic> get analytics => _repository.adminAnalytics;
  List<Map<String, dynamic>> get users => _repository.adminUsers;

  String _searchFilter = '';
  String get searchFilter => _searchFilter;

  final List<SecurityEvent> _securityLogs = [
    SecurityEvent(
      event: 'Anonymous token verified',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
      severity: 'INFO',
    ),
    SecurityEvent(
      event: 'Account linking completed without data collision',
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)).toIso8601String(),
      severity: 'INFO',
    ),
    SecurityEvent(
      event: 'Firestore rules authorization passed',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      severity: 'INFO',
    ),
  ];

  List<SecurityEvent> get securityLogs => _securityLogs;

  List<Map<String, dynamic>> get filteredUsers {
    if (_searchFilter.isEmpty) return users;
    return users
        .where((u) => (u['name'] as String)
            .toLowerCase()
            .contains(_searchFilter.toLowerCase()))
        .toList();
  }

  void filterUsers(String query) {
    _searchFilter = query;
    notifyListeners();
  }

  /// Verifies server-granted admin authority before performing backend actions
  bool checkAdminAuthorization(bool isServerAdmin) {
    if (!isServerAdmin) {
      _securityLogs.insert(
        0,
        SecurityEvent(
          event: 'Unauthorized privilege escalation attempt blocked',
          timestamp: DateTime.now().toIso8601String(),
          severity: 'HIGH',
        ),
      );
      notifyListeners();
      return false;
    }
    return true;
  }
}
