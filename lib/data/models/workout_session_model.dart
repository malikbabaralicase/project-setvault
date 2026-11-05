import 'workout_set_model.dart';
import 'exercise_model.dart';

class ExerciseInWorkout {
  final String id;
  final ExerciseModel exercise;
  List<WorkoutSetModel> sets;
  String? note;

  ExerciseInWorkout({
    required this.id,
    required this.exercise,
    required this.sets,
    this.note,
  });

  ExerciseInWorkout copyWith({
    String? id,
    ExerciseModel? exercise,
    List<WorkoutSetModel>? sets,
    String? note,
  }) {
    return ExerciseInWorkout(
      id: id ?? this.id,
      exercise: exercise ?? this.exercise,
      sets: sets ?? this.sets.map((s) => s.copyWith()).toList(),
      note: note ?? this.note,
    );
  }
}

class WorkoutSessionModel {
  final String id;
  final String title;
  final DateTime date;
  final int durationSeconds;
  final List<ExerciseInWorkout> exercises;
  final String? notes;
  final bool isCompleted;

  const WorkoutSessionModel({
    required this.id,
    required this.title,
    required this.date,
    required this.durationSeconds,
    required this.exercises,
    this.notes,
    this.isCompleted = true,
  });

  int get totalSets =>
      exercises.fold(0, (sum, exercise) => sum + exercise.sets.length);

  double get totalVolumeKg {
    double vol = 0;
    for (var ex in exercises) {
      for (var s in ex.sets) {
        if (s.isCompleted) {
          vol += (s.weight * s.reps);
        }
      }
    }
    return vol;
  }
}
