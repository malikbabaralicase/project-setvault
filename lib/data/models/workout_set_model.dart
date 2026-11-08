enum SetType { normal, warmup, drop, failure }

enum ExerciseWeightType { weighted, bodyweight, weightedBodyweight }

class WorkoutSetModel {
  final String id;
  int setNumber;
  double previousWeight;
  int previousReps;
  double weight;
  int reps;
  bool isCompleted;
  SetType type;
  double? rir; // Reps In Reserve
  ExerciseWeightType weightType;
  String? notes;

  WorkoutSetModel({
    required this.id,
    required this.setNumber,
    this.previousWeight = 0.0,
    this.previousReps = 0,
    required this.weight,
    required this.reps,
    this.isCompleted = false,
    this.type = SetType.normal,
    this.rir,
    this.weightType = ExerciseWeightType.weighted,
    this.notes,
  });

  bool get isBodyweight => weightType == ExerciseWeightType.bodyweight;

  WorkoutSetModel copyWith({
    String? id,
    int? setNumber,
    double? previousWeight,
    int? previousReps,
    double? weight,
    int? reps,
    bool? isCompleted,
    SetType? type,
    double? rir,
    ExerciseWeightType? weightType,
    String? notes,
  }) {
    return WorkoutSetModel(
      id: id ?? this.id,
      setNumber: setNumber ?? this.setNumber,
      previousWeight: previousWeight ?? this.previousWeight,
      previousReps: previousReps ?? this.previousReps,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      isCompleted: isCompleted ?? this.isCompleted,
      type: type ?? this.type,
      rir: rir ?? this.rir,
      weightType: weightType ?? this.weightType,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'setNumber': setNumber,
      'previousWeight': previousWeight,
      'previousReps': previousReps,
      'weight': weight,
      'reps': reps,
      'isCompleted': isCompleted,
      'type': type.name,
      'rir': rir,
      'weightType': weightType.name,
      'notes': notes,
    };
  }

  factory WorkoutSetModel.fromMap(Map<String, dynamic> map) {
    return WorkoutSetModel(
      id: map['id'] as String? ?? '',
      setNumber: (map['setNumber'] as num?)?.toInt() ?? 1,
      previousWeight: (map['previousWeight'] as num?)?.toDouble() ?? 0.0,
      previousReps: (map['previousReps'] as num?)?.toInt() ?? 0,
      weight: (map['weight'] as num?)?.toDouble() ?? 0.0,
      reps: (map['reps'] as num?)?.toInt() ?? 0,
      isCompleted: map['isCompleted'] as bool? ?? false,
      type: SetType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => SetType.normal,
      ),
      rir: (map['rir'] as num?)?.toDouble(),
      weightType: ExerciseWeightType.values.firstWhere(
        (t) => t.name == map['weightType'],
        orElse: () => ExerciseWeightType.weighted,
      ),
      notes: map['notes'] as String?,
    );
  }
}
