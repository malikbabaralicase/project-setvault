import '../models/exercise_model.dart';
import '../models/progress_stat_model.dart';
import '../models/user_model.dart';
import '../models/workout_routine_model.dart';
import '../models/workout_session_model.dart';
import '../models/workout_set_model.dart';

class MockDataRepository {
  static final MockDataRepository _instance = MockDataRepository._internal();
  factory MockDataRepository() => _instance;
  MockDataRepository._internal() {
    _initData();
  }

  late UserModel currentUser;
  late List<ExerciseModel> exercises;
  late List<ExerciseModel> customExercises;
  late List<WorkoutRoutineModel> routines;
  late List<WorkoutSessionModel> workoutHistory;

  void _initData() {
    currentUser = const UserModel(
      id: 'user_alex_01',
      name: 'Alex Morgan',
      email: 'alex.morgan@example.com',
      username: 'alexm',
      totalWorkouts: 24,
      trainingVolumeKg: 128450.0,
      totalSets: 186,
      streakDays: 4,
      isAdmin: true,
      isAnonymous: false,
    );

    customExercises = [];

    // Complete 8-category catalogue
    exercises = [
      // 1. CHEST
      const ExerciseModel(
        id: 'ex_bench_press',
        name: 'Bench Press',
        muscleGroup: 'Chest',
        equipment: 'Barbell',
        personalBest: 'PB: 60 kg × 5 reps',
        lastPerformance: 'Last Performance: 40 kg × 9 reps',
        instructions:
            'Lie flat on the bench. Grip the barbell with hands slightly wider than shoulder-width. Lower to mid-chest, then press upwards to lockout.',
        performanceHistory: [40, 45, 42, 50, 48, 55, 60],
      ),
      const ExerciseModel(
        id: 'ex_incline_db_press',
        name: 'Incline Dumbbell Press',
        muscleGroup: 'Chest',
        equipment: 'Dumbbells',
        personalBest: 'PB: 28 kg × 8 reps',
        lastPerformance: 'Last Performance: 24 kg × 10 reps',
        instructions:
            'Set bench to 30-45 degrees. Press dumbbells upwards in an arc, focusing on upper chest contraction.',
        performanceHistory: [20, 22, 22, 24, 26, 28],
      ),
      const ExerciseModel(
        id: 'ex_cable_fly',
        name: 'Cable Chest Fly',
        muscleGroup: 'Chest',
        equipment: 'Cable',
        personalBest: 'PB: 18 kg × 12 reps',
        lastPerformance: 'Last Performance: 15 kg × 12 reps',
        instructions:
            'Stand in the center of the cable crossover. Bring handles together in a hugging motion with elbows slightly bent.',
        performanceHistory: [10, 12, 14, 15, 18],
      ),

      // 2. BACK
      const ExerciseModel(
        id: 'ex_deadlift',
        name: 'Conventional Deadlift',
        muscleGroup: 'Back',
        equipment: 'Barbell',
        personalBest: 'PB: 140 kg × 3 reps',
        lastPerformance: 'Last Performance: 120 kg × 5 reps',
        instructions:
            'Hinge at hips, grip the barbell outside knees, keep chest proud and pull through heels to stand upright.',
        performanceHistory: [100, 110, 115, 120, 130, 140],
      ),
      const ExerciseModel(
        id: 'ex_pullup',
        name: 'Pull-up',
        muscleGroup: 'Back',
        equipment: 'Bodyweight',
        personalBest: 'PB: Bodyweight + 15 kg × 5 reps',
        lastPerformance: 'Last Performance: Bodyweight × 12 reps',
        instructions:
            'Overhand grip on bar. Pull yourself upwards until chin clears the bar, squeezing lats at the top.',
        performanceHistory: [8, 9, 10, 11, 12, 15],
      ),
      const ExerciseModel(
        id: 'ex_barbell_row',
        name: 'Barbell Bent-over Row',
        muscleGroup: 'Back',
        equipment: 'Barbell',
        personalBest: 'PB: 75 kg × 6 reps',
        lastPerformance: 'Last Performance: 65 kg × 8 reps',
        instructions:
            'Hinge forward 45 degrees with flat spine. Pull barbell towards lower abdomen, driving elbows back.',
        performanceHistory: [50, 55, 60, 65, 75],
      ),

      // 3. SHOULDERS
      const ExerciseModel(
        id: 'ex_overhead_press',
        name: 'Barbell Overhead Press',
        muscleGroup: 'Shoulders',
        equipment: 'Barbell',
        personalBest: 'PB: 45 kg × 6 reps',
        lastPerformance: 'Last Performance: 38 kg × 8 reps',
        instructions:
            'Stand with core braced. Press barbell vertically from collarbone to overhead lockout.',
        performanceHistory: [30, 32, 35, 38, 40, 45],
      ),
      const ExerciseModel(
        id: 'ex_lateral_raise',
        name: 'Dumbbell Lateral Raise',
        muscleGroup: 'Shoulders',
        equipment: 'Dumbbells',
        personalBest: 'PB: 14 kg × 12 reps',
        lastPerformance: 'Last Performance: 12 kg × 15 reps',
        instructions:
            'Raise dumbbells to the sides until parallel with shoulders. Lower under control.',
        performanceHistory: [8, 10, 10, 12, 12, 14],
      ),

      // 4. BICEPS
      const ExerciseModel(
        id: 'ex_barbell_curl',
        name: 'Barbell Bicep Curl',
        muscleGroup: 'Biceps',
        equipment: 'Barbell',
        personalBest: 'PB: 35 kg × 8 reps',
        lastPerformance: 'Last Performance: 30 kg × 10 reps',
        instructions:
            'Keep elbows tucked. Curl barbell up towards shoulders while keeping shoulders still.',
        performanceHistory: [20, 25, 28, 30, 35],
      ),
      const ExerciseModel(
        id: 'ex_hammer_curl',
        name: 'Dumbbell Hammer Curl',
        muscleGroup: 'Biceps',
        equipment: 'Dumbbells',
        personalBest: 'PB: 18 kg × 10 reps',
        lastPerformance: 'Last Performance: 16 kg × 10 reps',
        instructions:
            'Palms facing each other. Curl dumbbells to shoulder height, targeting brachialis.',
        performanceHistory: [12, 14, 16, 16, 18],
      ),

      // 5. TRICEPS
      const ExerciseModel(
        id: 'ex_tricep_pushdown',
        name: 'Cable Tricep Pushdown',
        muscleGroup: 'Triceps',
        equipment: 'Cable',
        personalBest: 'PB: 32 kg × 12 reps',
        lastPerformance: 'Last Performance: 27 kg × 12 reps',
        instructions:
            'Pin elbows to sides and push cable attachment downward until arms are fully extended.',
        performanceHistory: [20, 22, 25, 27, 30, 32],
      ),
      const ExerciseModel(
        id: 'ex_skull_crushers',
        name: 'Lying Triceps Extension',
        muscleGroup: 'Triceps',
        equipment: 'Barbell',
        personalBest: 'PB: 30 kg × 10 reps',
        lastPerformance: 'Last Performance: 25 kg × 10 reps',
        instructions:
            'Lie on flat bench. Lower bar towards forehead by bending elbows, then press back up.',
        performanceHistory: [18, 20, 22, 25, 30],
      ),

      // 6. LEGS
      const ExerciseModel(
        id: 'ex_barbell_squat',
        name: 'Barbell Squat',
        muscleGroup: 'Legs',
        equipment: 'Barbell',
        personalBest: 'PB: 100 kg × 5 reps',
        lastPerformance: 'Last Performance: 85 kg × 8 reps',
        instructions:
            'Barbell on upper traps. Squat down until thighs are parallel with ground, then stand strong.',
        performanceHistory: [70, 75, 80, 85, 90, 100],
      ),
      const ExerciseModel(
        id: 'ex_leg_press',
        name: 'Leg Press',
        muscleGroup: 'Legs',
        equipment: 'Machine',
        personalBest: 'PB: 220 kg × 8 reps',
        lastPerformance: 'Last Performance: 180 kg × 10 reps',
        instructions:
            'Feet shoulder-width on platform. Release safety handles and lower carriage to 90 degrees.',
        performanceHistory: [140, 160, 180, 200, 220],
      ),

      // 7. CORE
      const ExerciseModel(
        id: 'ex_plank',
        name: 'Weighted Forearm Plank',
        muscleGroup: 'Core',
        equipment: 'Bodyweight',
        personalBest: 'PB: +20 kg × 90 sec',
        lastPerformance: 'Last Performance: Bodyweight × 120 sec',
        instructions:
            'Hold strict pushup-plank position on forearms, bracing glutes and abdominal wall.',
        performanceHistory: [60, 75, 90, 100, 120],
      ),
      const ExerciseModel(
        id: 'ex_hanging_leg_raise',
        name: 'Hanging Leg Raise',
        muscleGroup: 'Core',
        equipment: 'Bodyweight',
        personalBest: 'PB: 15 Reps',
        lastPerformance: 'Last Performance: 12 Reps',
        instructions:
            'Hang from pull-up bar. Raise legs straight until parallel with floor without swinging.',
        performanceHistory: [8, 10, 12, 14, 15],
      ),

      // 8. FULL BODY
      const ExerciseModel(
        id: 'ex_clean_and_press',
        name: 'Barbell Clean and Press',
        muscleGroup: 'Full Body',
        equipment: 'Barbell',
        personalBest: 'PB: 65 kg × 3 reps',
        lastPerformance: 'Last Performance: 55 kg × 5 reps',
        instructions:
            'Pull barbell from floor into front rack position, then explosively press overhead.',
        performanceHistory: [40, 45, 50, 55, 65],
      ),
    ];

    // Routines
    routines = [
      WorkoutRoutineModel(
        id: 'routine_push',
        title: 'PUSH DAY',
        totalWorkouts: 28,
        trainingVolumeKg: 136470.0,
        description: 'Chest, Shoulders & Triceps hypertrophy split',
        exercises: [
          RoutineExerciseTemplate(
            exercise: exercises[0], // Bench Press
            targetSets: [
              WorkoutSetModel(
                id: 'rt_s1',
                setNumber: 1,
                previousWeight: 40,
                previousReps: 10,
                weight: 40,
                reps: 10,
                isCompleted: true,
                type: SetType.normal,
              ),
              WorkoutSetModel(
                id: 'rt_s2',
                setNumber: 2,
                previousWeight: 40,
                previousReps: 9,
                weight: 40,
                reps: 9,
                isCompleted: true,
                type: SetType.normal,
              ),
              WorkoutSetModel(
                id: 'rt_s3',
                setNumber: 3,
                previousWeight: 35,
                previousReps: 12,
                weight: 35,
                reps: 12,
                isCompleted: false,
                type: SetType.normal,
              ),
            ],
          ),
          RoutineExerciseTemplate(
            exercise: exercises[1], // Incline DB Press
            targetSets: [
              WorkoutSetModel(
                id: 'rt_s4',
                setNumber: 1,
                previousWeight: 24,
                previousReps: 10,
                weight: 24,
                reps: 10,
                type: SetType.normal,
              ),
            ],
          ),
        ],
      ),
      WorkoutRoutineModel(
        id: 'routine_pull',
        title: 'PULL DAY',
        totalWorkouts: 20,
        trainingVolumeKg: 126690.0,
        description: 'Back & Biceps focus session',
        exercises: [
          RoutineExerciseTemplate(
            exercise: exercises[3], // Deadlift
            targetSets: [
              WorkoutSetModel(
                id: 'rt_s5',
                setNumber: 1,
                previousWeight: 120,
                previousReps: 5,
                weight: 120,
                reps: 5,
                type: SetType.normal,
              ),
            ],
          ),
        ],
      ),
      WorkoutRoutineModel(
        id: 'routine_leg',
        title: 'LEG DAY',
        totalWorkouts: 10,
        trainingVolumeKg: 125490.0,
        description: 'Quads, Hamstrings & Calves power routine',
        exercises: [
          RoutineExerciseTemplate(
            exercise: exercises[12], // Squat
            targetSets: [
              WorkoutSetModel(
                id: 'rt_s6',
                setNumber: 1,
                previousWeight: 85,
                previousReps: 8,
                weight: 85,
                reps: 8,
                type: SetType.normal,
              ),
            ],
          ),
        ],
      ),
    ];

    // Historical Workouts
    workoutHistory = [
      WorkoutSessionModel(
        id: 'hist_01',
        title: 'Push Day',
        date: DateTime(2026, 11, 4, 18, 30),
        durationSeconds: 58 * 60,
        notes: 'Great chest pump and smooth lockout on top set.',
        exercises: [
          ExerciseInWorkout(
            id: 'ew_01',
            exercise: exercises[0], // Bench Press
            sets: [
              WorkoutSetModel(
                id: 'ws_1',
                setNumber: 1,
                previousWeight: 40,
                previousReps: 10,
                weight: 40,
                reps: 10,
                isCompleted: true,
                type: SetType.normal,
              ),
              WorkoutSetModel(
                id: 'ws_2',
                setNumber: 2,
                previousWeight: 40,
                previousReps: 9,
                weight: 40,
                reps: 9,
                isCompleted: true,
                type: SetType.normal,
              ),
              WorkoutSetModel(
                id: 'ws_3',
                setNumber: 3,
                previousWeight: 35,
                previousReps: 12,
                weight: 35,
                reps: 12,
                isCompleted: true,
                type: SetType.normal,
              ),
            ],
          ),
        ],
      ),
      WorkoutSessionModel(
        id: 'hist_02',
        title: 'Pull Day',
        date: DateTime(2026, 11, 2, 19, 0),
        durationSeconds: 52 * 60,
        notes: 'Back felt strong on heavy rows.',
        exercises: [
          ExerciseInWorkout(
            id: 'ew_02',
            exercise: exercises[3], // Deadlift
            sets: [
              WorkoutSetModel(
                id: 'ws_4',
                setNumber: 1,
                previousWeight: 120,
                previousReps: 5,
                weight: 120,
                reps: 5,
                isCompleted: true,
                type: SetType.normal,
              ),
            ],
          ),
        ],
      ),
      WorkoutSessionModel(
        id: 'hist_03',
        title: 'Leg Day',
        date: DateTime(2026, 10, 30, 18, 15),
        durationSeconds: 60 * 60,
        notes: 'Deep squats, focused on knee tracking.',
        exercises: [
          ExerciseInWorkout(
            id: 'ew_03',
            exercise: exercises[12], // Squat
            sets: [
              WorkoutSetModel(
                id: 'ws_5',
                setNumber: 1,
                previousWeight: 85,
                previousReps: 8,
                weight: 85,
                reps: 8,
                isCompleted: true,
                type: SetType.normal,
              ),
            ],
          ),
        ],
      ),
      WorkoutSessionModel(
        id: 'hist_04',
        title: 'Push Day',
        date: DateTime(2026, 10, 28, 17, 45),
        durationSeconds: 55 * 60,
        notes: 'Upper chest focus.',
        exercises: [
          ExerciseInWorkout(
            id: 'ew_04',
            exercise: exercises[0],
            sets: [
              WorkoutSetModel(
                id: 'ws_6',
                setNumber: 1,
                previousWeight: 38,
                previousReps: 10,
                weight: 38,
                reps: 10,
                isCompleted: true,
                type: SetType.normal,
              ),
            ],
          ),
        ],
      ),
    ];
  }

  // Combine built-in catalogue and user's custom exercises
  List<ExerciseModel> get allExercises => [...exercises, ...customExercises];

  // Dynamic Last-Time / Carry-Over lookup
  List<WorkoutSetModel>? getPreviousPerformance(String exerciseId) {
    for (final session in workoutHistory) {
      for (final ex in session.exercises) {
        if (ex.exercise.id == exerciseId && ex.sets.isNotEmpty) {
          return ex.sets;
        }
      }
    }
    return null;
  }

  // Dynamic Personal Records calculated from all completed workouts
  List<PersonalRecordModel> calculatePersonalRecords() {
    final Map<String, double> maxWeightMap = {};
    final Map<String, int> repsMap = {};

    for (final session in workoutHistory) {
      for (final ex in session.exercises) {
        for (final set in ex.sets) {
          if (set.isCompleted && set.weight > 0) {
            final currentMax = maxWeightMap[ex.exercise.name] ?? 0.0;
            if (set.weight > currentMax) {
              maxWeightMap[ex.exercise.name] = set.weight;
              repsMap[ex.exercise.name] = set.reps;
            }
          }
        }
      }
    }

    final List<PersonalRecordModel> prs = [];
    maxWeightMap.forEach((name, weight) {
      prs.add(
        PersonalRecordModel(
          exerciseName: name,
          record: '${weight.toInt()} kg × ${repsMap[name] ?? 1} reps',
          date: 'Recorded Session',
        ),
      );
    });

    if (prs.isEmpty) {
      return progressStats.personalRecords;
    }
    return prs;
  }

  // Dynamic Weekly Volume calculated from real sessions
  List<double> calculateWeeklyVolume() {
    // 7 days Mon-Sun
    final List<double> volumePerDay = List.filled(7, 0.0);
    final now = DateTime.now();

    for (final session in workoutHistory) {
      final diff = now.difference(session.date).inDays;
      if (diff >= 0 && diff < 7) {
        final dayIndex = (session.date.weekday - 1) % 7;
        volumePerDay[dayIndex] += session.totalVolumeKg;
      }
    }

    // If no workouts this week, provide default demo volume for clean visuals
    if (volumePerDay.every((v) => v == 0)) {
      return [18400, 22600, 19800, 26400, 24100, 28900, 14200];
    }
    return volumePerDay;
  }

  ProgressStatModel get progressStats => ProgressStatModel(
        weeklyVolume: calculateWeeklyVolume(),
        weekDays: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        weightProgression: const [76.5, 76.8, 77.2, 77.0, 77.6, 78.1, 78.4],
        weightDates: const ['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7'],
        personalRecords: calculatePersonalRecords(),
      );

  // Admin Data
  final Map<String, dynamic> adminAnalytics = {
    'totalWorkouts': 26,
    'userActivity': 3277,
    'activeRoutines': 18,
    'systemStatus': 'Operational',
  };

  final List<Map<String, dynamic>> adminUsers = [
    {
      'name': 'Alex',
      'email': 'alex.morgan@example.com',
      'workouts': 123,
      'sets': 42,
      'role': 'Admin',
    },
    {
      'name': 'Noor',
      'email': 'noor.khan@example.com',
      'workouts': 106,
      'sets': 45,
      'role': 'Athlete',
    },
    {
      'name': 'Umer',
      'email': 'umer.tariq@example.com',
      'workouts': 51,
      'sets': 20,
      'role': 'Athlete',
    },
    {
      'name': 'Ozer',
      'email': 'ozer.malik@example.com',
      'workouts': 28,
      'sets': 14,
      'role': 'Athlete',
    },
  ];
}
