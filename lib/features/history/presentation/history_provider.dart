import 'package:flutter/material.dart';
import '../../../data/models/workout_session_model.dart';
import '../../../data/repositories/mock_data_repository.dart';

class HistoryProvider extends ChangeNotifier {
  final MockDataRepository _repository = MockDataRepository();

  DateTime _selectedDate = DateTime(2026, 11, 4);
  DateTime _currentMonth = DateTime(2026, 11, 1);
  WorkoutSessionModel? _selectedSession;

  DateTime get selectedDate => _selectedDate;
  DateTime get currentMonth => _currentMonth;
  List<WorkoutSessionModel> get sessions => _repository.workoutHistory;
  WorkoutSessionModel get selectedSession =>
      _selectedSession ?? _repository.workoutHistory.first;

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void previousMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    notifyListeners();
  }

  void nextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    notifyListeners();
  }

  void selectSession(WorkoutSessionModel session) {
    _selectedSession = session;
    notifyListeners();
  }
}
