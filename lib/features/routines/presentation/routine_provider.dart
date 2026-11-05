import 'package:flutter/material.dart';
import '../../../data/models/workout_routine_model.dart';
import '../../../data/repositories/mock_data_repository.dart';

class RoutineProvider extends ChangeNotifier {
  final MockDataRepository _repository = MockDataRepository();

  List<WorkoutRoutineModel> get routines => _repository.routines;

  void addRoutine(WorkoutRoutineModel routine) {
    _repository.routines.add(routine);
    notifyListeners();
  }

  void updateRoutine(WorkoutRoutineModel routine) {
    final index = _repository.routines.indexWhere((r) => r.id == routine.id);
    if (index != -1) {
      _repository.routines[index] = routine;
      notifyListeners();
    }
  }

  void deleteRoutine(String routineId) {
    _repository.routines.removeWhere((r) => r.id == routineId);
    notifyListeners();
  }
}
