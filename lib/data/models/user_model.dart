class UserModel {
  final String id;
  final String name;
  final String email;
  final String username;
  final String? avatarUrl;
  final int totalWorkouts;
  final double trainingVolumeKg;
  final int totalSets;
  final int streakDays;
  final bool isAdmin;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    this.avatarUrl,
    required this.totalWorkouts,
    required this.trainingVolumeKg,
    required this.totalSets,
    required this.streakDays,
    this.isAdmin = false,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? username,
    String? avatarUrl,
    int? totalWorkouts,
    double? trainingVolumeKg,
    int? totalSets,
    int? streakDays,
    bool? isAdmin,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      trainingVolumeKg: trainingVolumeKg ?? this.trainingVolumeKg,
      totalSets: totalSets ?? this.totalSets,
      streakDays: streakDays ?? this.streakDays,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
