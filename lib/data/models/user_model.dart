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
  final bool isAnonymous;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

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
    this.isAnonymous = false,
    this.createdAt,
    this.lastLoginAt,
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
    bool? isAnonymous,
    DateTime? createdAt,
    DateTime? lastLoginAt,
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
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'avatarUrl': avatarUrl,
      'totalWorkouts': totalWorkouts,
      'trainingVolumeKg': trainingVolumeKg,
      'totalSets': totalSets,
      'streakDays': streakDays,
      'isAdmin': isAdmin,
      'isAnonymous': isAnonymous,
      'createdAt': createdAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? 'Athlete',
      email: map['email'] as String? ?? '',
      username: map['username'] as String? ?? '',
      avatarUrl: map['avatarUrl'] as String?,
      totalWorkouts: (map['totalWorkouts'] as num?)?.toInt() ?? 0,
      trainingVolumeKg: (map['trainingVolumeKg'] as num?)?.toDouble() ?? 0.0,
      totalSets: (map['totalSets'] as num?)?.toInt() ?? 0,
      streakDays: (map['streakDays'] as num?)?.toInt() ?? 0,
      isAdmin: map['isAdmin'] as bool? ?? false,
      isAnonymous: map['isAnonymous'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
      lastLoginAt: map['lastLoginAt'] != null
          ? DateTime.tryParse(map['lastLoginAt'] as String)
          : null,
    );
  }
}
