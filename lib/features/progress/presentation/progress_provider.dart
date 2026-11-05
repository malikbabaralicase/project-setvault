import 'package:flutter/material.dart';
import '../../../data/models/progress_stat_model.dart';
import '../../../data/repositories/mock_data_repository.dart';

class ProgressProvider extends ChangeNotifier {
  final MockDataRepository _repository = MockDataRepository();

  ProgressStatModel get progressData => _repository.progressStats;
  List<double> get weeklyVolume => progressData.weeklyVolume;
  List<String> get weekDays => progressData.weekDays;
  List<double> get weightProgression => progressData.weightProgression;
  List<String> get weightDates => progressData.weightDates;
  List<PersonalRecordModel> get personalRecords => progressData.personalRecords;
}
