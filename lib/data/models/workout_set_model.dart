class WorkoutSetModel {
  final String id;
  int setNumber;
  final double previousWeight;
  final int previousReps;
  double weight;
  int reps;
  bool isCompleted;
  final bool isBodyweight;

  WorkoutSetModel({
    required this.id,
    required this.setNumber,
    required this.previousWeight,
    required this.previousReps,
    required this.weight,
    required this.reps,
    this.isCompleted = false,
    this.isBodyweight = false,
  });

  WorkoutSetModel copyWith({
    String? id,
    int? setNumber,
    double? previousWeight,
    int? previousReps,
    double? weight,
    int? reps,
    bool? isCompleted,
    bool? isBodyweight,
  }) {
    return WorkoutSetModel(
      id: id ?? this.id,
      setNumber: setNumber ?? this.setNumber,
      previousWeight: previousWeight ?? this.previousWeight,
      previousReps: previousReps ?? this.previousReps,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      isCompleted: isCompleted ?? this.isCompleted,
      isBodyweight: isBodyweight ?? this.isBodyweight,
    );
  }
}
