import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/services/workout_autosave_service.dart';
import '../../../data/models/exercise_model.dart';
import '../../../data/models/workout_session_model.dart';
import '../../../data/models/workout_set_model.dart';
import '../../../data/repositories/mock_data_repository.dart';

class ActiveWorkoutProvider extends ChangeNotifier {
  final MockDataRepository _repository = MockDataRepository();
  final FirestoreService _firestoreService = FirestoreService();

  String _title = 'Push Day';
  int _secondsElapsed = 35 * 60 + 42;
  Timer? _timer;
  bool _isRunning = true;
  List<ExerciseInWorkout> _exercises = [];
  String _notes = '';
  SyncStatus _syncStatus = SyncStatus.savedLocally;
  bool _hasUnfinishedWorkout = false;

  String get title => _title;
  int get secondsElapsed => _secondsElapsed;
  bool get isRunning => _isRunning;
  List<ExerciseInWorkout> get exercises => _exercises;
  String get notes => _notes;
  SyncStatus get syncStatus => _syncStatus;
  bool get hasUnfinishedWorkout => _hasUnfinishedWorkout;

  String get syncStatusLabel {
    switch (_syncStatus) {
      case SyncStatus.savedLocally:
        return 'Saved Locally';
      case SyncStatus.waitingForSync:
        return 'Waiting for Sync';
      case SyncStatus.synced:
        return 'Synced';
      case SyncStatus.syncFailed:
        return 'Sync Failed';
    }
  }

  String get formattedDuration {
    final int hours = _secondsElapsed ~/ 3600;
    final int minutes = (_secondsElapsed % 3600) ~/ 60;
    final int seconds = _secondsElapsed % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  ActiveWorkoutProvider() {
    _initWorkout();
    _checkForUnfinishedWorkout();
    _startTimer();
  }

  Future<void> _checkForUnfinishedWorkout() async {
    final unfinished = await WorkoutAutosaveService.loadUnfinishedWorkout();
    if (unfinished != null && unfinished.exercises.isNotEmpty) {
      _hasUnfinishedWorkout = true;
      _title = unfinished.title;
      _secondsElapsed = unfinished.durationSeconds;
      _exercises = unfinished.exercises;
      _notes = unfinished.notes ?? '';
      notifyListeners();
    }
  }

  void _initWorkout() {
    final benchPress = _repository.exercises.first;
    // Retrieve dynamic carry-over if available
    final prevSets = _repository.getPreviousPerformance(benchPress.id);

    _exercises = [
      ExerciseInWorkout(
        id: 'active_ex_1',
        exercise: benchPress,
        sets: [
          WorkoutSetModel(
            id: 'as_1',
            setNumber: 1,
            previousWeight: prevSets != null && prevSets.isNotEmpty
                ? prevSets[0].weight
                : 40.0,
            previousReps: prevSets != null && prevSets.isNotEmpty
                ? prevSets[0].reps
                : 10,
            weight: 40,
            reps: 10,
            isCompleted: true,
            type: SetType.normal,
            rir: 2,
          ),
          WorkoutSetModel(
            id: 'as_2',
            setNumber: 2,
            previousWeight: prevSets != null && prevSets.length > 1
                ? prevSets[1].weight
                : 40.0,
            previousReps: prevSets != null && prevSets.length > 1
                ? prevSets[1].reps
                : 9,
            weight: 40,
            reps: 9,
            isCompleted: true,
            type: SetType.normal,
            rir: 1,
          ),
          WorkoutSetModel(
            id: 'as_3',
            setNumber: 3,
            previousWeight: prevSets != null && prevSets.length > 2
                ? prevSets[2].weight
                : 35.0,
            previousReps: prevSets != null && prevSets.length > 2
                ? prevSets[2].reps
                : 12,
            weight: 35,
            reps: 12,
            isCompleted: false,
            type: SetType.normal,
            rir: 0,
          ),
        ],
      ),
    ];
    _triggerAutosave();
  }

  void _triggerAutosave() {
    final session = WorkoutSessionModel(
      id: 'active_current_session',
      title: _title,
      date: DateTime.now(),
      durationSeconds: _secondsElapsed,
      exercises: _exercises,
      notes: _notes,
      isCompleted: false,
      status: WorkoutStatus.inProgress,
      syncStatus: SyncStatus.savedLocally,
    );
    WorkoutAutosaveService.saveWorkout(session);
    _syncStatus = SyncStatus.savedLocally;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isRunning) {
        _secondsElapsed++;
        if (_secondsElapsed % 15 == 0) {
          _triggerAutosave();
        }
        notifyListeners();
      }
    });
  }

  void toggleTimer() {
    _isRunning = !_isRunning;
    notifyListeners();
  }

  void setTitle(String newTitle) {
    _title = newTitle;
    _triggerAutosave();
    notifyListeners();
  }

  /// Adds an unlimited number of sets with dynamic carry-over
  void addSet(String exerciseId) {
    final exIndex = _exercises.indexWhere((e) => e.id == exerciseId);
    if (exIndex != -1) {
      final currentSets = _exercises[exIndex].sets;
      final int nextNum = currentSets.length + 1;
      final double lastWeight =
          currentSets.isNotEmpty ? currentSets.last.weight : 40.0;
      final int lastReps =
          currentSets.isNotEmpty ? currentSets.last.reps : 10;

      currentSets.add(
        WorkoutSetModel(
          id: 'as_${DateTime.now().millisecondsSinceEpoch}',
          setNumber: nextNum,
          previousWeight: lastWeight,
          previousReps: lastReps,
          weight: lastWeight,
          reps: lastReps,
          isCompleted: false,
          type: SetType.normal,
        ),
      );
      _triggerAutosave();
      notifyListeners();
    }
  }

  void removeSet(String exerciseId, int setIndex) {
    final exIndex = _exercises.indexWhere((e) => e.id == exerciseId);
    if (exIndex != -1 && _exercises[exIndex].sets.length > 1) {
      _exercises[exIndex].sets.removeAt(setIndex);
      for (int i = 0; i < _exercises[exIndex].sets.length; i++) {
        _exercises[exIndex].sets[i].setNumber = i + 1;
      }
      _triggerAutosave();
      notifyListeners();
    }
  }

  void toggleSetCompleted(String exerciseId, int setIndex) {
    final exIndex = _exercises.indexWhere((e) => e.id == exerciseId);
    if (exIndex != -1) {
      final set = _exercises[exIndex].sets[setIndex];
      set.isCompleted = !set.isCompleted;
      _triggerAutosave();
      notifyListeners();
    }
  }

  void updateSetWeight(String exerciseId, int setIndex, double newWeight) {
    final exIndex = _exercises.indexWhere((e) => e.id == exerciseId);
    if (exIndex != -1) {
      _exercises[exIndex].sets[setIndex].weight = newWeight;
      _triggerAutosave();
      notifyListeners();
    }
  }

  void updateSetReps(String exerciseId, int setIndex, int newReps) {
    final exIndex = _exercises.indexWhere((e) => e.id == exerciseId);
    if (exIndex != -1) {
      _exercises[exIndex].sets[setIndex].reps = newReps;
      _triggerAutosave();
      notifyListeners();
    }
  }

  void updateSetType(String exerciseId, int setIndex, SetType newType) {
    final exIndex = _exercises.indexWhere((e) => e.id == exerciseId);
    if (exIndex != -1) {
      _exercises[exIndex].sets[setIndex].type = newType;
      _triggerAutosave();
      notifyListeners();
    }
  }

  void updateSetRir(String exerciseId, int setIndex, double? newRir) {
    final exIndex = _exercises.indexWhere((e) => e.id == exerciseId);
    if (exIndex != -1) {
      _exercises[exIndex].sets[setIndex].rir = newRir;
      _triggerAutosave();
      notifyListeners();
    }
  }

  void updateSetWeightType(
    String exerciseId,
    int setIndex,
    ExerciseWeightType weightType,
  ) {
    final exIndex = _exercises.indexWhere((e) => e.id == exerciseId);
    if (exIndex != -1) {
      _exercises[exIndex].sets[setIndex].weightType = weightType;
      _triggerAutosave();
      notifyListeners();
    }
  }

  /// Adds a new exercise with dynamic previous workout carry-over!
  void addExercise(ExerciseModel exercise) {
    final prevSets = _repository.getPreviousPerformance(exercise.id);
    final double initialWeight =
        prevSets != null && prevSets.isNotEmpty ? prevSets[0].weight : 30.0;
    final int initialReps =
        prevSets != null && prevSets.isNotEmpty ? prevSets[0].reps : 10;

    _exercises.add(
      ExerciseInWorkout(
        id: 'active_ex_${DateTime.now().millisecondsSinceEpoch}',
        exercise: exercise,
        sets: [
          WorkoutSetModel(
            id: 'as_init_${DateTime.now().millisecondsSinceEpoch}',
            setNumber: 1,
            previousWeight: initialWeight,
            previousReps: initialReps,
            weight: initialWeight,
            reps: initialReps,
            isCompleted: false,
            type: SetType.normal,
          ),
        ],
      ),
    );
    _triggerAutosave();
    notifyListeners();
  }

  void removeExercise(int index) {
    if (index >= 0 && index < _exercises.length) {
      _exercises.removeAt(index);
      _triggerAutosave();
      notifyListeners();
    }
  }

  void setNote(String note) {
    _notes = note;
    _triggerAutosave();
    notifyListeners();
  }

  /// Completes workout, persists to Firestore and local history, and clears autosave
  Future<void> finishWorkout(String uid) async {
    final completedSession = WorkoutSessionModel(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      title: _title,
      date: DateTime.now(),
      durationSeconds: _secondsElapsed,
      exercises: _exercises,
      notes: _notes,
      isCompleted: true,
      status: WorkoutStatus.completed,
      syncStatus: SyncStatus.synced,
      startedAt: DateTime.now().subtract(Duration(seconds: _secondsElapsed)),
      endedAt: DateTime.now(),
    );

    // Save to Firestore and Repository
    await _firestoreService.saveWorkoutSession(uid, completedSession);
    _repository.workoutHistory.insert(0, completedSession);

    // Clear autosave
    await WorkoutAutosaveService.clearAutosave();
    _hasUnfinishedWorkout = false;

    // Reset state
    _secondsElapsed = 0;
    _initWorkout();
    notifyListeners();
  }

  /// Cancels workout and clears autosave
  Future<void> cancelWorkout() async {
    await WorkoutAutosaveService.clearAutosave();
    _hasUnfinishedWorkout = false;
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
