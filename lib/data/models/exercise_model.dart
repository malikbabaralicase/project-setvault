class ExerciseModel {
  final String id;
  final String name;
  final String muscleGroup;
  final String equipment;
  final String personalBest;
  final String lastPerformance;
  final String instructions;
  final List<double> performanceHistory;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.equipment,
    required this.personalBest,
    required this.lastPerformance,
    required this.instructions,
    required this.performanceHistory,
  });
}
