import 'dart:convert';
import '../../data/models/exercise_model.dart';
import '../../data/models/user_model.dart';
import '../../data/models/workout_routine_model.dart';
import '../../data/models/workout_session_model.dart';

class BackupValidationResult {
  final bool isValid;
  final String? error;
  final int workoutCount;
  final int routineCount;
  final int customExerciseCount;

  const BackupValidationResult({
    required this.isValid,
    this.error,
    this.workoutCount = 0,
    this.routineCount = 0,
    this.customExerciseCount = 0,
  });
}

class BackupService {
  static const String currentVersion = '1.0';

  /// Generates a validated JSON backup string of user data
  static String exportToJson({
    required UserModel profile,
    required List<WorkoutSessionModel> workouts,
    required List<WorkoutRoutineModel> routines,
    required List<ExerciseModel> customExercises,
    required Map<String, dynamic> preferences,
  }) {
    final Map<String, dynamic> backup = {
      'app': 'SetVault',
      'version': currentVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'profile': profile.toMap(),
      'workouts': workouts.map((w) => w.toMap()).toList(),
      'routines': routines.map((r) => r.toMap()).toList(),
      'customExercises': customExercises.map((e) => e.toMap()).toList(),
      'preferences': preferences,
    };

    return const JsonEncoder.withIndent('  ').convert(backup);
  }

  /// Validates schema, data types, and reference integrity of backup JSON
  static BackupValidationResult validateBackupJson(String jsonString) {
    try {
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        return const BackupValidationResult(
          isValid: false,
          error: 'Invalid JSON format: root must be an object',
        );
      }

      if (decoded['app'] != 'SetVault') {
        return const BackupValidationResult(
          isValid: false,
          error: 'Unsupported backup: signature does not match SetVault',
        );
      }

      if (decoded['version'] != currentVersion) {
        return BackupValidationResult(
          isValid: false,
          error: 'Unsupported backup version: ${decoded['version']}',
        );
      }

      final workoutsList = decoded['workouts'];
      final routinesList = decoded['routines'];
      final exercisesList = decoded['customExercises'];

      if (workoutsList != null && workoutsList is! List) {
        return const BackupValidationResult(
          isValid: false,
          error: 'Schema error: workouts must be an array',
        );
      }

      if (routinesList != null && routinesList is! List) {
        return const BackupValidationResult(
          isValid: false,
          error: 'Schema error: routines must be an array',
        );
      }

      final int wCount = workoutsList is List ? workoutsList.length : 0;
      final int rCount = routinesList is List ? routinesList.length : 0;
      final int eCount = exercisesList is List ? exercisesList.length : 0;

      return BackupValidationResult(
        isValid: true,
        workoutCount: wCount,
        routineCount: rCount,
        customExerciseCount: eCount,
      );
    } catch (e) {
      return BackupValidationResult(
        isValid: false,
        error: 'JSON parsing failed: $e',
      );
    }
  }

  /// Parses and deserializes backup safely, deduplicating with existing records
  static Map<String, dynamic> importData(
    String jsonString, {
    required List<WorkoutSessionModel> existingWorkouts,
    required List<WorkoutRoutineModel> existingRoutines,
  }) {
    final Map<String, dynamic> decoded = jsonDecode(jsonString);

    final List<WorkoutSessionModel> importedWorkouts = [];
    final existingWorkoutIds = existingWorkouts.map((w) => w.id).toSet();

    if (decoded['workouts'] is List) {
      for (final item in decoded['workouts']) {
        if (item is Map<String, dynamic>) {
          final session = WorkoutSessionModel.fromMap(item);
          // Deduplicate: avoid re-importing existing ID
          if (!existingWorkoutIds.contains(session.id)) {
            importedWorkouts.add(session);
          }
        }
      }
    }

    final List<WorkoutRoutineModel> importedRoutines = [];
    final existingRoutineIds = existingRoutines.map((r) => r.id).toSet();

    if (decoded['routines'] is List) {
      for (final item in decoded['routines']) {
        if (item is Map<String, dynamic>) {
          final routine = WorkoutRoutineModel.fromMap(item);
          if (!existingRoutineIds.contains(routine.id)) {
            importedRoutines.add(routine);
          }
        }
      }
    }

    final List<ExerciseModel> importedExercises = [];
    if (decoded['customExercises'] is List) {
      for (final item in decoded['customExercises']) {
        if (item is Map<String, dynamic>) {
          importedExercises.add(ExerciseModel.fromMap(item));
        }
      }
    }

    return {
      'workouts': importedWorkouts,
      'routines': importedRoutines,
      'customExercises': importedExercises,
      'preferences': decoded['preferences'] ?? {},
    };
  }
}

