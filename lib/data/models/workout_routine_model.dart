import 'exercise_model.dart';
import 'workout_set_model.dart';

class RoutineExerciseTemplate {
  final ExerciseModel exercise;
  final List<WorkoutSetModel> targetSets;

  const RoutineExerciseTemplate({
    required this.exercise,
    required this.targetSets,
  });

  Map<String, dynamic> toMap() {
    return {
      'exercise': exercise.toMap(),
      'targetSets': targetSets.map((s) => s.toMap()).toList(),
    };
  }

  factory RoutineExerciseTemplate.fromMap(Map<String, dynamic> map) {
    return RoutineExerciseTemplate(
      exercise: ExerciseModel.fromMap(
        map['exercise'] as Map<String, dynamic>? ?? {},
      ),
      targetSets: (map['targetSets'] as List<dynamic>?)
              ?.map((s) => WorkoutSetModel.fromMap(s as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class WorkoutRoutineModel {
  final String id;
  final String title;
  final int totalWorkouts;
  final double trainingVolumeKg;
  final List<RoutineExerciseTemplate> exercises;
  final String description;
  final String? userId;

  const WorkoutRoutineModel({
    required this.id,
    required this.title,
    required this.totalWorkouts,
    required this.trainingVolumeKg,
    required this.exercises,
    this.description = '',
    this.userId,
  });

  WorkoutRoutineModel copyWith({
    String? id,
    String? title,
    int? totalWorkouts,
    double? trainingVolumeKg,
    List<RoutineExerciseTemplate>? exercises,
    String? description,
    String? userId,
  }) {
    return WorkoutRoutineModel(
      id: id ?? this.id,
      title: title ?? this.title,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      trainingVolumeKg: trainingVolumeKg ?? this.trainingVolumeKg,
      exercises: exercises ?? this.exercises,
      description: description ?? this.description,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'totalWorkouts': totalWorkouts,
      'trainingVolumeKg': trainingVolumeKg,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'description': description,
      'userId': userId,
    };
  }

  factory WorkoutRoutineModel.fromMap(Map<String, dynamic> map) {
    return WorkoutRoutineModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      totalWorkouts: (map['totalWorkouts'] as num?)?.toInt() ?? 0,
      trainingVolumeKg: (map['trainingVolumeKg'] as num?)?.toDouble() ?? 0.0,
      exercises: (map['exercises'] as List<dynamic>?)
              ?.map((e) =>
                  RoutineExerciseTemplate.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      description: map['description'] as String? ?? '',
      userId: map['userId'] as String?,
    );
  }
}
