class ExerciseModel {
  final String id;
  final String name;
  final String muscleGroup;
  final String equipment;
  final String personalBest;
  final String lastPerformance;
  final String instructions;
  final List<double> performanceHistory;
  final bool isCustom;
  final String? userId;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.equipment,
    required this.personalBest,
    required this.lastPerformance,
    required this.instructions,
    required this.performanceHistory,
    this.isCustom = false,
    this.userId,
  });

  ExerciseModel copyWith({
    String? id,
    String? name,
    String? muscleGroup,
    String? equipment,
    String? personalBest,
    String? lastPerformance,
    String? instructions,
    List<double>? performanceHistory,
    bool? isCustom,
    String? userId,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      equipment: equipment ?? this.equipment,
      personalBest: personalBest ?? this.personalBest,
      lastPerformance: lastPerformance ?? this.lastPerformance,
      instructions: instructions ?? this.instructions,
      performanceHistory: performanceHistory ?? this.performanceHistory,
      isCustom: isCustom ?? this.isCustom,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'muscleGroup': muscleGroup,
      'equipment': equipment,
      'personalBest': personalBest,
      'lastPerformance': lastPerformance,
      'instructions': instructions,
      'performanceHistory': performanceHistory,
      'isCustom': isCustom,
      'userId': userId,
    };
  }

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      muscleGroup: map['muscleGroup'] as String? ?? 'Full Body',
      equipment: map['equipment'] as String? ?? 'None',
      personalBest: map['personalBest'] as String? ?? '',
      lastPerformance: map['lastPerformance'] as String? ?? '',
      instructions: map['instructions'] as String? ?? '',
      performanceHistory: (map['performanceHistory'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      isCustom: map['isCustom'] as bool? ?? false,
      userId: map['userId'] as String?,
    );
  }
}
