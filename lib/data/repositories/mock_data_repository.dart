import '../models/user_model.dart';
import '../models/exercise_model.dart';
import '../models/workout_set_model.dart';
import '../models/workout_session_model.dart';
import '../models/workout_routine_model.dart';
import '../models/progress_stat_model.dart';

class MockDataRepository {
  // Singleton pattern for in-memory temporary Part 1 data
  static final MockDataRepository _instance = MockDataRepository._internal();
  factory MockDataRepository() => _instance;
  MockDataRepository._internal();

  // Demo User: Alex Morgan
  UserModel currentUser = const UserModel(
    id: 'user_alex_01',
    name: 'Alex Morgan',
    email: 'alex.morgan@example.com',
    username: 'alexm',
    totalWorkouts: 24,
    trainingVolumeKg: 128450.0,
    totalSets: 186,
    streakDays: 4,
    isAdmin: true,
  );

  // Exercise Library
  final List<ExerciseModel> exercises = [
    const ExerciseModel(
      id: 'ex_bench_press',
      name: 'Bench Press',
      muscleGroup: 'Chest',
      equipment: 'Barbell',
      personalBest: 'PB: 60 kg × 5 reps',
      lastPerformance: 'Last Performance: 40 kg × 9 reps',
      instructions:
          'Lie back on a flat bench. Grip the barbell with hands slightly wider than shoulder-width. Lower the bar smoothly to mid-chest, then press upwards explosively to full extension.',
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
          'Set bench to 30-45 degrees. Hold dumbbells at shoulder height and press upward until arms are straight, keeping core tight.',
      performanceHistory: [20, 22, 22, 24, 26, 28],
    ),
    const ExerciseModel(
      id: 'ex_incline_bb_press',
      name: 'Incline Barbell Press',
      muscleGroup: 'Chest',
      equipment: 'Barbell',
      personalBest: 'PB: 52 kg × 6 reps',
      lastPerformance: 'Last Performance: 45 kg × 8 reps',
      instructions:
          'Positioned on an incline bench, unrack the barbell and lower towards upper chest. Press firmly back up.',
      performanceHistory: [35, 40, 42, 45, 50, 52],
    ),
    const ExerciseModel(
      id: 'ex_overhead_press',
      name: 'Barbell Overhead Press',
      muscleGroup: 'Shoulders',
      equipment: 'Barbell',
      personalBest: 'PB: 45 kg × 6 reps',
      lastPerformance: 'Last Performance: 38 kg × 8 reps',
      instructions:
          'Stand tall with feet shoulder-width apart. Press the barbell overhead from clavicle to full lockout overhead.',
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
          'Raise dumbbells outward to the sides until elbows reach shoulder height. Control the descent.',
      performanceHistory: [8, 10, 10, 12, 12, 14],
    ),
    const ExerciseModel(
      id: 'ex_barbell_squat',
      name: 'Barbell Squat',
      muscleGroup: 'Legs',
      equipment: 'Barbell',
      personalBest: 'PB: 100 kg × 5 reps',
      lastPerformance: 'Last Performance: 85 kg × 8 reps',
      instructions:
          'Barbell resting on traps, descend by bending hips and knees until thighs are parallel to ground. Drive up through heels.',
      performanceHistory: [70, 75, 80, 85, 90, 100],
    ),
    const ExerciseModel(
      id: 'ex_deadlift',
      name: 'Conventional Deadlift',
      muscleGroup: 'Back',
      equipment: 'Barbell',
      personalBest: 'PB: 140 kg × 3 reps',
      lastPerformance: 'Last Performance: 120 kg × 5 reps',
      instructions:
          'Hinge at hips, grip the barbell firmly just outside knees. Drive hips forward and stand tall, keeping spine neutral.',
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
          'Overhand grip on pull-up bar. Pull chest to the bar by engaging lats and driving elbows down.',
      performanceHistory: [8, 9, 10, 11, 12, 15],
    ),
    const ExerciseModel(
      id: 'ex_tricep_pushdown',
      name: 'Cable Tricep Pushdown',
      muscleGroup: 'Arms',
      equipment: 'Cable',
      personalBest: 'PB: 32 kg × 12 reps',
      lastPerformance: 'Last Performance: 27 kg × 12 reps',
      instructions:
          'Grip cable bar or rope, tuck elbows to ribs, and extend arms downward until triceps are fully contracted.',
      performanceHistory: [20, 22, 25, 27, 30, 32],
    ),
  ];

  // Routines
  late List<WorkoutRoutineModel> routines = [
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
            ),
            WorkoutSetModel(
              id: 'rt_s2',
              setNumber: 2,
              previousWeight: 40,
              previousReps: 9,
              weight: 40,
              reps: 9,
              isCompleted: true,
            ),
            WorkoutSetModel(
              id: 'rt_s3',
              setNumber: 3,
              previousWeight: 35,
              previousReps: 12,
              weight: 35,
              reps: 12,
              isCompleted: false,
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
            ),
            WorkoutSetModel(
              id: 'rt_s5',
              setNumber: 2,
              previousWeight: 24,
              previousReps: 8,
              weight: 24,
              reps: 8,
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
      description: 'Back, Rear Delts & Biceps focus session',
      exercises: [
        RoutineExerciseTemplate(
          exercise: exercises[6], // Deadlift
          targetSets: [
            WorkoutSetModel(
              id: 'rt_s6',
              setNumber: 1,
              previousWeight: 120,
              previousReps: 5,
              weight: 120,
              reps: 5,
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
          exercise: exercises[5], // Squat
          targetSets: [
            WorkoutSetModel(
              id: 'rt_s7',
              setNumber: 1,
              previousWeight: 85,
              previousReps: 8,
              weight: 85,
              reps: 8,
            ),
          ],
        ),
      ],
    ),
  ];

  // Workout History
  late List<WorkoutSessionModel> workoutHistory = [
    WorkoutSessionModel(
      id: 'hist_01',
      title: 'Push Day',
      date: DateTime(2026, 11, 4, 18, 30),
      durationSeconds: 58 * 60, // 58 minutes
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
            ),
            WorkoutSetModel(
              id: 'ws_2',
              setNumber: 2,
              previousWeight: 40,
              previousReps: 9,
              weight: 40,
              reps: 9,
              isCompleted: true,
            ),
            WorkoutSetModel(
              id: 'ws_3',
              setNumber: 3,
              previousWeight: 35,
              previousReps: 12,
              weight: 35,
              reps: 12,
              isCompleted: true,
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
          exercise: exercises[6],
          sets: [
            WorkoutSetModel(
              id: 'ws_4',
              setNumber: 1,
              previousWeight: 120,
              previousReps: 5,
              weight: 120,
              reps: 5,
              isCompleted: true,
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
          exercise: exercises[5],
          sets: [
            WorkoutSetModel(
              id: 'ws_5',
              setNumber: 1,
              previousWeight: 85,
              previousReps: 8,
              weight: 85,
              reps: 8,
              isCompleted: true,
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
            ),
          ],
        ),
      ],
    ),
  ];

  // Progress Data
  final ProgressStatModel progressStats = const ProgressStatModel(
    weeklyVolume: [18400, 22600, 19800, 26400, 24100, 28900, 14200],
    weekDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    weightProgression: [76.5, 76.8, 77.2, 77.0, 77.6, 78.1, 78.4],
    weightDates: ['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7'],
    personalRecords: [
      PersonalRecordModel(
        exerciseName: 'Bench Press',
        record: '60 kg × 5 reps',
        date: 'Oct 24, 2026',
      ),
      PersonalRecordModel(
        exerciseName: 'Incline Press',
        record: '60 kg × 3 reps',
        date: 'Oct 18, 2026',
      ),
      PersonalRecordModel(
        exerciseName: 'Barbell Squat',
        record: '100 kg × 5 reps',
        date: 'Oct 12, 2026',
      ),
      PersonalRecordModel(
        exerciseName: 'Deadlift',
        record: '140 kg × 3 reps',
        date: 'Sep 29, 2026',
      ),
    ],
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
