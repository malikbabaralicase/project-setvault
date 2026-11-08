import 'package:flutter/material.dart';
import '../../../data/models/progress_stat_model.dart';
import '../../../data/repositories/mock_data_repository.dart';

class ProgressProvider extends ChangeNotifier {
  final MockDataRepository _repository = MockDataRepository();

  ProgressStatModel get progressData => _repository.progressStats;

  List<double> get weeklyVolume => _repository.calculateWeeklyVolume();
  List<String> get weekDays => progressData.weekDays;
  List<double> get weightProgression => progressData.weightProgression;
  List<String> get weightDates => progressData.weightDates;
  List<PersonalRecordModel> get personalRecords =>
      _repository.calculatePersonalRecords();

  double get totalLifetimeVolumeKg {
    return _repository.workoutHistory.fold(0.0, (sum, w) => sum + w.totalVolumeKg);
  }

  int get totalCompletedWorkouts => _repository.workoutHistory.length;

  int get totalCompletedSets {
    return _repository.workoutHistory.fold(0, (sum, w) => sum + w.totalSets);
  }

  void refreshProgress() {
    notifyListeners();
  }
}
