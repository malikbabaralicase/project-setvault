import 'dart:async';
import 'package:flutter/material.dart';
import '../../../data/models/exercise_model.dart';
import '../../../data/models/workout_session_model.dart';
import '../../../data/models/workout_set_model.dart';
import '../../../data/repositories/mock_data_repository.dart';

class ActiveWorkoutProvider extends ChangeNotifier {
  final MockDataRepository _repository = MockDataRepository();

  final String _title = 'Push Day';
  int _secondsElapsed = 35 * 60 + 42; // Starts around 00:35:42 as in collage
  Timer? _timer;
  bool _isRunning = true;
  List<ExerciseInWorkout> _exercises = [];
  String _notes = '';

  String get title => _title;
  int get secondsElapsed => _secondsElapsed;
  bool get isRunning => _isRunning;
  List<ExerciseInWorkout> get exercises => _exercises;
  String get notes => _notes;

  String get formattedDuration {
    final int hours = _secondsElapsed ~/ 3600;
    final int minutes = (_secondsElapsed % 3600) ~/ 60;
    final int seconds = _secondsElapsed % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  ActiveWorkoutProvider() {
    _initWorkout();
    _startTimer();
  }

  void _initWorkout() {
    final benchPress = _repository.exercises.first;
    _exercises = [
      ExerciseInWorkout(
        id: 'active_ex_1',
        exercise: benchPress,
        sets: [
          WorkoutSetModel(
            id: 'as_1',
            setNumber: 1,
            previousWeight: 40,
            previousReps: 10,
            weight: 40,
            reps: 10,
            isCompleted: true,
          ),
          WorkoutSetModel(
            id: 'as_2',
            setNumber: 2,
            previousWeight: 40,
            previousReps: 9,
            weight: 40,
            reps: 9,
            isCompleted: true,
          ),
          WorkoutSetModel(
            id: 'as_3',
            setNumber: 3,
            previousWeight: 35,
            previousReps: 12,
            weight: 35,
            reps: 12,
            isCompleted: false,
          ),
        ],
      ),
    ];
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isRunning) {
        _secondsElapsed++;
        notifyListeners();
      }
    });
  }

  void toggleTimer() {
    _isRunning = !_isRunning;
    notifyListeners();
  }

  void addSet(String exerciseId) {
    final exIndex = _exercises.indexWhere((e) => e.id == exerciseId);
    if (exIndex != -1) {
      final currentSets = _exercises[exIndex].sets;
      final int nextNum = currentSets.length + 1;
      final double lastWeight = currentSets.isNotEmpty ? currentSets.last.weight : 40.0;
      final int lastReps = currentSets.isNotEmpty ? currentSets.last.reps : 10;

      currentSets.add(
        WorkoutSetModel(
          id: 'as_${DateTime.now().millisecondsSinceEpoch}',
          setNumber: nextNum,
          previousWeight: lastWeight,
          previousReps: lastReps,
          weight: lastWeight,
          reps: lastReps,
          isCompleted: false,
        ),
      );
      notifyListeners();
    }
  }

  void removeSet(String exerciseId, int setIndex) {
    final exIndex = _exercises.indexWhere((e) => e.id == exerciseId);
    if (exIndex != -1 && _exercises[exIndex].sets.length > 1) {
      _exercises[exIndex].sets.removeAt(setIndex);
      // Re-number remaining sets
      for (int i = 0; i < _exercises[exIndex].sets.length; i++) {
        _exercises[exIndex].sets[i].setNumber = i + 1;
      }
      notifyListeners();
    }
  }

  void toggleSetCompleted(String exerciseId, int setIndex) {
    final exIndex = _exercises.indexWhere((e) => e.id == exerciseId);
    if (exIndex != -1) {
      final set = _exercises[exIndex].sets[setIndex];
      set.isCompleted = !set.isCompleted;
      notifyListeners();
    }
  }

  void updateSetWeight(String exerciseId, int setIndex, double newWeight) {
    final exIndex = _exercises.indexWhere((e) => e.id == exerciseId);
    if (exIndex != -1) {
      _exercises[exIndex].sets[setIndex].weight = newWeight;
      notifyListeners();
    }
  }

  void updateSetReps(String exerciseId, int setIndex, int newReps) {
    final exIndex = _exercises.indexWhere((e) => e.id == exerciseId);
    if (exIndex != -1) {
      _exercises[exIndex].sets[setIndex].reps = newReps;
      notifyListeners();
    }
  }

  void addExercise(ExerciseModel exercise) {
    _exercises.add(
      ExerciseInWorkout(
        id: 'active_ex_${DateTime.now().millisecondsSinceEpoch}',
        exercise: exercise,
        sets: [
          WorkoutSetModel(
            id: 'as_init_${DateTime.now().millisecondsSinceEpoch}',
            setNumber: 1,
            previousWeight: 30,
            previousReps: 10,
            weight: 30,
            reps: 10,
            isCompleted: false,
          ),
        ],
      ),
    );
    notifyListeners();
  }

  void setNote(String note) {
    _notes = note;
    notifyListeners();
  }

  void resetWorkout() {
    _secondsElapsed = 0;
    _initWorkout();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
