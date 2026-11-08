import 'package:flutter/material.dart';
import '../../../core/services/firestore_service.dart';
import '../../../data/models/workout_routine_model.dart';
import '../../../data/repositories/mock_data_repository.dart';

class RoutineProvider extends ChangeNotifier {
  final MockDataRepository _repository = MockDataRepository();
  final FirestoreService _firestoreService = FirestoreService();

  List<WorkoutRoutineModel> get routines => _repository.routines;

  Future<void> addRoutine(String uid, WorkoutRoutineModel routine) async {
    _repository.routines.add(routine);
    await _firestoreService.saveRoutine(uid, routine);
    notifyListeners();
  }

  Future<void> updateRoutine(String uid, WorkoutRoutineModel routine) async {
    final index = _repository.routines.indexWhere((r) => r.id == routine.id);
    if (index != -1) {
      _repository.routines[index] = routine;
      await _firestoreService.saveRoutine(uid, routine);
      notifyListeners();
    }
  }

  Future<void> deleteRoutine(String uid, String routineId) async {
    _repository.routines.removeWhere((r) => r.id == routineId);
    await _firestoreService.deleteRoutine(uid, routineId);
    notifyListeners();
  }

  Future<void> reorderExercisesInRoutine(
    String uid,
    String routineId,
    int oldIndex,
    int newIndex,
  ) async {
    final rIdx = _repository.routines.indexWhere((r) => r.id == routineId);
    if (rIdx != -1) {
      final routine = _repository.routines[rIdx];
      final exercises = List<RoutineExerciseTemplate>.from(routine.exercises);
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = exercises.removeAt(oldIndex);
      exercises.insert(newIndex, item);

      final updated = routine.copyWith(exercises: exercises);
      _repository.routines[rIdx] = updated;
      await _firestoreService.saveRoutine(uid, updated);
      notifyListeners();
    }
  }
}
