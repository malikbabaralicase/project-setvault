import 'package:flutter/material.dart';
import '../../../core/services/firestore_service.dart';
import '../../../data/models/workout_session_model.dart';
import '../../../data/repositories/mock_data_repository.dart';

class HistoryProvider extends ChangeNotifier {
  final MockDataRepository _repository = MockDataRepository();
  final FirestoreService _firestoreService = FirestoreService();

  DateTime _selectedDate = DateTime(2026, 11, 4);
  DateTime _currentMonth = DateTime(2026, 11, 1);
  WorkoutSessionModel? _selectedSession;

  DateTime get selectedDate => _selectedDate;
  DateTime get currentMonth => _currentMonth;
  List<WorkoutSessionModel> get sessions => _repository.workoutHistory;
  WorkoutSessionModel get selectedSession =>
      _selectedSession ?? _repository.workoutHistory.first;

  /// Workouts matching selected date (supports multiple workouts per day!)
  List<WorkoutSessionModel> get workoutsOnSelectedDate {
    return sessions.where((s) {
      return s.date.year == _selectedDate.year &&
          s.date.month == _selectedDate.month &&
          s.date.day == _selectedDate.day;
    }).toList();
  }

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

  Future<void> updateWorkoutSession(
    String uid,
    WorkoutSessionModel session,
  ) async {
    final idx = _repository.workoutHistory.indexWhere((s) => s.id == session.id);
    if (idx != -1) {
      _repository.workoutHistory[idx] = session;
      await _firestoreService.saveWorkoutSession(uid, session);
      notifyListeners();
    }
  }

  Future<void> deleteWorkoutSession(String uid, String sessionId) async {
    _repository.workoutHistory.removeWhere((s) => s.id == sessionId);
    notifyListeners();
  }
}
