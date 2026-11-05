import 'package:flutter/material.dart';
import '../../../data/models/exercise_model.dart';
import '../../../data/repositories/mock_data_repository.dart';

class ExerciseProvider extends ChangeNotifier {
  final MockDataRepository _repository = MockDataRepository();

  String _searchQuery = '';
  String _selectedMuscleGroup = 'All';
  ExerciseModel? _selectedExercise;

  String get searchQuery => _searchQuery;
  String get selectedMuscleGroup => _selectedMuscleGroup;
  ExerciseModel get selectedExercise => _selectedExercise ?? _repository.exercises.first;

  final List<String> muscleGroups = [
    'All',
    'Chest',
    'Back',
    'Legs',
    'Shoulders',
    'Arms',
  ];

  List<ExerciseModel> get filteredExercises {
    return _repository.exercises.where((exercise) {
      final matchesSearch = exercise.name
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final matchesGroup = _selectedMuscleGroup == 'All' ||
          exercise.muscleGroup.toLowerCase() == _selectedMuscleGroup.toLowerCase();
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
}
