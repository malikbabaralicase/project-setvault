import 'exercise_model.dart';
import 'workout_set_model.dart';

enum WorkoutStatus { inProgress, completed, cancelled }

enum SyncStatus { savedLocally, waitingForSync, synced, syncFailed }

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exercise': exercise.toMap(),
      'sets': sets.map((s) => s.toMap()).toList(),
      'note': note,
    };
  }

  factory ExerciseInWorkout.fromMap(Map<String, dynamic> map) {
    return ExerciseInWorkout(
      id: map['id'] as String? ?? '',
      exercise: ExerciseModel.fromMap(
        map['exercise'] as Map<String, dynamic>? ?? {},
      ),
      sets: (map['sets'] as List<dynamic>?)
              ?.map((s) => WorkoutSetModel.fromMap(s as Map<String, dynamic>))
              .toList() ??
          [],
      note: map['note'] as String?,
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
  final WorkoutStatus status;
  final SyncStatus syncStatus;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final DateTime? updatedAt;

  const WorkoutSessionModel({
    required this.id,
    required this.title,
    required this.date,
    required this.durationSeconds,
    required this.exercises,
    this.notes,
    this.isCompleted = true,
    this.status = WorkoutStatus.completed,
    this.syncStatus = SyncStatus.synced,
    this.startedAt,
    this.endedAt,
    this.updatedAt,
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

  WorkoutSessionModel copyWith({
    String? id,
    String? title,
    DateTime? date,
    int? durationSeconds,
    List<ExerciseInWorkout>? exercises,
    String? notes,
    bool? isCompleted,
    WorkoutStatus? status,
    SyncStatus? syncStatus,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? updatedAt,
  }) {
    return WorkoutSessionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      exercises: exercises ?? this.exercises,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'durationSeconds': durationSeconds,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'notes': notes,
      'isCompleted': isCompleted,
      'status': status.name,
      'syncStatus': syncStatus.name,
      'startedAt': startedAt?.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'updatedAt': (updatedAt ?? DateTime.now()).toIso8601String(),
    };
  }

  factory WorkoutSessionModel.fromMap(Map<String, dynamic> map) {
    return WorkoutSessionModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Workout',
      date: map['date'] != null
          ? DateTime.tryParse(map['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      durationSeconds: (map['durationSeconds'] as num?)?.toInt() ?? 0,
      exercises: (map['exercises'] as List<dynamic>?)
              ?.map((e) => ExerciseInWorkout.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      notes: map['notes'] as String?,
      isCompleted: map['isCompleted'] as bool? ?? true,
      status: WorkoutStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => WorkoutStatus.completed,
      ),
      syncStatus: SyncStatus.values.firstWhere(
        (s) => s.name == map['syncStatus'],
        orElse: () => SyncStatus.synced,
      ),
      startedAt: map['startedAt'] != null
          ? DateTime.tryParse(map['startedAt'] as String)
          : null,
      endedAt: map['endedAt'] != null
          ? DateTime.tryParse(map['endedAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'] as String)
          : null,
    );
  }
}
