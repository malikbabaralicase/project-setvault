import 'package:flutter/material.dart';
import '../../../core/services/firestore_service.dart';
import '../../../data/models/exercise_model.dart';
import '../../../data/repositories/mock_data_repository.dart';

class ExerciseProvider extends ChangeNotifier {
  final MockDataRepository _repository = MockDataRepository();
  final FirestoreService _firestoreService = FirestoreService();

  String _searchQuery = '';
  String _selectedMuscleGroup = 'All';
  ExerciseModel? _selectedExercise;

  String get searchQuery => _searchQuery;
  String get selectedMuscleGroup => _selectedMuscleGroup;
  ExerciseModel get selectedExercise =>
      _selectedExercise ?? _repository.allExercises.first;

  final List<String> muscleGroups = [
    'All',
    'Chest',
    'Back',
    'Shoulders',
    'Biceps',
    'Triceps',
    'Legs',
    'Core',
    'Full Body',
  ];

  List<ExerciseModel> get filteredExercises {
    return _repository.allExercises.where((exercise) {
      final matchesSearch = exercise.name
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final matchesGroup = _selectedMuscleGroup == 'All' ||
          exercise.muscleGroup.toLowerCase() ==
              _selectedMuscleGroup.toLowerCase();
      return matchesSearch && matchesGroup;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectMuscleGroup(String group) {
    _selectedMuscleGroup = group;
    notifyListeners();
  }

  void selectExercise(ExerciseModel exercise) {
    _selectedExercise = exercise;
    notifyListeners();
  }

  Future<void> addCustomExercise(String uid, ExerciseModel exercise) async {
    _repository.customExercises.add(exercise);
    await _firestoreService.saveCustomExercise(uid, exercise);
    notifyListeners();
  }

  Future<void> updateCustomExercise(String uid, ExerciseModel exercise) async {
    final idx =
        _repository.customExercises.indexWhere((e) => e.id == exercise.id);
    if (idx != -1) {
      _repository.customExercises[idx] = exercise;
      await _firestoreService.saveCustomExercise(uid, exercise);
      notifyListeners();
    }
  }

  Future<void> deleteCustomExercise(String uid, String exerciseId) async {
    _repository.customExercises.removeWhere((e) => e.id == exerciseId);
    await _firestoreService.deleteCustomExercise(uid, exerciseId);
    notifyListeners();
  }
}
