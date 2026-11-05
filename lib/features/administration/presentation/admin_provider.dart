import 'package:flutter/material.dart';
import '../../../data/repositories/mock_data_repository.dart';

class AdminProvider extends ChangeNotifier {
  final MockDataRepository _repository = MockDataRepository();

  Map<String, dynamic> get analytics => _repository.adminAnalytics;
  List<Map<String, dynamic>> get users => _repository.adminUsers;

  String _searchFilter = '';
  String get searchFilter => _searchFilter;

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
}
