import 'exercise_model.dart';
import 'workout_set_model.dart';

class RoutineExerciseTemplate {
  final ExerciseModel exercise;
  final List<WorkoutSetModel> targetSets;

  const RoutineExerciseTemplate({
    required this.exercise,
    required this.targetSets,
  });
}

class WorkoutRoutineModel {
  final String id;
  final String title;
  final int totalWorkouts;
  final double trainingVolumeKg;
  final List<RoutineExerciseTemplate> exercises;
  final String description;

  const WorkoutRoutineModel({
    required this.id,
    required this.title,
    required this.totalWorkouts,
    required this.trainingVolumeKg,
    required this.exercises,
    this.description = '',
  });

  WorkoutRoutineModel copyWith({
    String? id,
    String? title,
    int? totalWorkouts,
    double? trainingVolumeKg,
    List<RoutineExerciseTemplate>? exercises,
    String? description,
  }) {
    return WorkoutRoutineModel(
      id: id ?? this.id,
      title: title ?? this.title,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      trainingVolumeKg: trainingVolumeKg ?? this.trainingVolumeKg,
      exercises: exercises ?? this.exercises,
      description: description ?? this.description,
    );
  }
}
