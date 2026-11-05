import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/workout_session_model.dart';
import '../../../data/repositories/mock_data_repository.dart';

class DashboardProvider extends ChangeNotifier {
  final MockDataRepository _repository = MockDataRepository();

  int _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;

  UserModel get user => _repository.currentUser;

  WorkoutSessionModel get recentWorkout => _repository.workoutHistory.first;

  int get totalWorkouts => user.totalWorkouts;
  double get trainingVolumeKg => user.trainingVolumeKg;
  int get streakDays => user.streakDays;

  void setNavIndex(int index) {
    if (_currentNavIndex != index) {
      _currentNavIndex = index;
      notifyListeners();
    }
  }
}
