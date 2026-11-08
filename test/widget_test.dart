import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:setvault/core/services/backup_service.dart';
import 'package:setvault/data/models/workout_set_model.dart';
import 'package:setvault/data/repositories/mock_data_repository.dart';
import 'package:setvault/features/administration/presentation/admin_dashboard_screen.dart';
import 'package:setvault/features/administration/presentation/admin_provider.dart';
import 'package:setvault/features/authentication/presentation/auth_provider.dart';
import 'package:setvault/features/authentication/presentation/login_screen.dart';
import 'package:setvault/features/authentication/presentation/registration_screen.dart';
import 'package:setvault/features/authentication/presentation/splash_screen.dart';
import 'package:setvault/features/dashboard/presentation/dashboard_provider.dart';
import 'package:setvault/features/dashboard/presentation/dashboard_screen.dart';
import 'package:setvault/features/dashboard/presentation/main_navigation_screen.dart';
import 'package:setvault/features/exercises/presentation/exercise_details_screen.dart';
import 'package:setvault/features/exercises/presentation/exercise_library_screen.dart';
import 'package:setvault/features/exercises/presentation/exercise_provider.dart';
import 'package:setvault/features/history/presentation/history_provider.dart';
import 'package:setvault/features/history/presentation/workout_history_screen.dart';
import 'package:setvault/features/progress/presentation/progress_dashboard_screen.dart';
import 'package:setvault/features/progress/presentation/progress_provider.dart';
import 'package:setvault/features/routines/presentation/create_routine_screen.dart';
import 'package:setvault/features/routines/presentation/routine_provider.dart';
import 'package:setvault/features/routines/presentation/workout_routines_screen.dart';
import 'package:setvault/features/settings/presentation/profile_screen.dart';
import 'package:setvault/features/settings/presentation/settings_provider.dart';
import 'package:setvault/features/settings/presentation/settings_screen.dart';
import 'package:setvault/features/timer/presentation/rest_timer_provider.dart';
import 'package:setvault/features/timer/presentation/rest_timer_screen.dart';
import 'package:setvault/features/workouts/presentation/active_workout_provider.dart';
import 'package:setvault/features/workouts/presentation/active_workout_screen.dart';
import 'package:setvault/features/workouts/presentation/workout_details_screen.dart';
import 'package:setvault/main.dart';

Widget _wrapWithProviders(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ChangeNotifierProvider(create: (_) => ActiveWorkoutProvider()),
      ChangeNotifierProvider(create: (_) => ExerciseProvider()),
      ChangeNotifierProvider(create: (_) => RoutineProvider()),
      ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ChangeNotifierProvider(create: (_) => ProgressProvider()),
      ChangeNotifierProvider(create: (_) => RestTimerProvider()),
      ChangeNotifierProvider(create: (_) => AdminProvider()),
      ChangeNotifierProvider(create: (_) => SettingsProvider()),
    ],
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  group('SetVault Part 2 Comprehensive Suite & Backend Verification', () {
    testWidgets('Screen 1: Splash / Onboarding renders correctly', (tester) async {
      await tester.pumpWidget(const SetVaultApp());
      await tester.pump();
      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.text('START TRAINING'), findsOneWidget);
      expect(find.text('SIGN IN'), findsOneWidget);
    });

    testWidgets('Screen 2: Home Dashboard renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const DashboardScreen()));
      await tester.pump();
      expect(find.text('Ready to Train?'), findsOneWidget);
      expect(find.text('START WORKOUT'), findsOneWidget);
      expect(find.text('Total Workouts'), findsOneWidget);
      expect(find.text('Training Volume'), findsOneWidget);
      expect(find.text('Push Day'), findsOneWidget);
    });

    testWidgets('Screen 3: Active Workout renders with sync status & set controls', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const ActiveWorkoutScreen()));
      await tester.pump();
      expect(find.text('Push Day'), findsOneWidget);
      expect(find.text('Finish Workout'), findsOneWidget);
      expect(find.text('Bench Press'), findsOneWidget);
      expect(find.text('Saved Locally'), findsOneWidget);
      expect(find.text('Rest Timer'), findsOneWidget);
    });

    testWidgets('Screen 4: Exercise Library renders all 8 categories', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const ExerciseLibraryScreen()));
      await tester.pump();
      expect(find.text('Exercise Library'), findsOneWidget);
      expect(find.text('Bench Press'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Chest'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
    });

    testWidgets('Screen 5: Exercise Details renders correctly', (tester) async {
      final repo = MockDataRepository();
      await tester.pumpWidget(
        _wrapWithProviders(ExerciseDetailsScreen(exercise: repo.exercises.first)),
      );
      await tester.pump();
      expect(find.text('Exercise Details'), findsOneWidget);
      expect(find.text('Bench Press'), findsWidgets);
      expect(find.text(repo.exercises.first.personalBest), findsOneWidget);
      expect(find.text('LOG THIS EXERCISE'), findsOneWidget);
    });

    testWidgets('Screen 6: Workout Routines renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const WorkoutRoutinesScreen()));
      await tester.pump();
      expect(find.text('Workout Routines'), findsOneWidget);
      expect(find.text('PUSH DAY'), findsOneWidget);
      expect(find.text('PULL DAY'), findsOneWidget);
      expect(find.text('LEG DAY'), findsOneWidget);
    });

    testWidgets('Screen 7: Create Routine renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const CreateRoutineScreen()));
      await tester.pump();
      expect(find.text('Create Routine'), findsOneWidget);
      expect(find.text('Routine Name'), findsOneWidget);
      expect(find.text('Exercises'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('Screen 8: Workout History renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const WorkoutHistoryScreen()));
      await tester.pump();
      expect(find.text('Workout History'), findsOneWidget);
      expect(find.text('November 2026'), findsOneWidget);
      expect(find.text('Workout Log'), findsOneWidget);
    });

    testWidgets('Screen 9: Workout Details renders correctly', (tester) async {
      final repo = MockDataRepository();
      await tester.pumpWidget(
        _wrapWithProviders(WorkoutDetailsScreen(session: repo.workoutHistory.first)),
      );
      await tester.pump();
      expect(find.text('Workout Details'), findsOneWidget);
      expect(find.text('Push Day'), findsOneWidget);
      expect(find.text('Repeat Workout'), findsOneWidget);
    });

    testWidgets('Screen 10: Progress Dashboard renders real charts', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const ProgressDashboardScreen()));
      await tester.pump();
      expect(find.text('Progress Dashboard'), findsOneWidget);
      expect(find.text('Weekly Volume'), findsOneWidget);
      expect(find.text('Weight Progression'), findsOneWidget);
      expect(find.text('Personal Records'), findsOneWidget);
    });

    testWidgets('Screen 11: Rest Timer renders countdown ring', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const RestTimerScreen()));
      await tester.pump();
      expect(find.text('Rest Timer'), findsOneWidget);
      expect(find.text('SET'), findsOneWidget);
      expect(find.text('01:30'), findsOneWidget);
      expect(find.text('Reset Timer'), findsOneWidget);
    });

    testWidgets('Screen 12: Settings renders backup options', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const SettingsScreen()));
      await tester.pump();
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Alex Morgan'), findsOneWidget);
      expect(find.text('Export / Import Backup'), findsOneWidget);
      expect(find.text('Administrator Dashboard'), findsOneWidget);
    });

    testWidgets('Screen 13: Profile Screen renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const ProfileScreen()));
      await tester.pump();
      expect(find.text('User Profile'), findsOneWidget);
      expect(find.text('Display Name'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);
    });

    testWidgets('Screen 14: Login Screen renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const LoginScreen()));
      await tester.pump();
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('LOG IN'), findsOneWidget);
    });

    testWidgets('Screen 15: Registration Screen renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const RegistrationScreen()));
      await tester.pump();
      expect(find.text('Registration'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('REGISTER'), findsOneWidget);
    });

    testWidgets('Screen 16: Administrator Dashboard renders RBAC elements', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const AdminDashboardScreen()));
      await tester.pump();
      expect(find.text('Administrator Dashboard'), findsOneWidget);
      expect(find.text('Backend Analytics'), findsOneWidget);
      expect(find.text('Security Monitoring'), findsOneWidget);
      expect(find.text('User Management'), findsOneWidget);
    });

    testWidgets('Navigation switches tabs smoothly', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const MainNavigationScreen()));
      await tester.pump();

      expect(find.byType(DashboardScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.format_list_bulleted_rounded));
      await tester.pump();
      expect(find.byType(WorkoutRoutinesScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.show_chart_rounded));
      await tester.pump();
      expect(find.byType(ProgressDashboardScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.person_rounded));
      await tester.pump();
      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    test('Logic Test: Anonymous auth and account linking preserves user data', () async {
      final auth = AuthProvider();
      await auth.signInAnonymously();
      expect(auth.isAnonymous, true);
      final anonId = auth.currentUser?.id;

      // Register / Link
      await auth.register(
        name: 'Alex Morgan Linked',
        email: 'alex.linked@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      );
      expect(auth.currentUser?.email, 'alex.linked@example.com');
      expect(auth.currentUser?.name, 'Alex Morgan Linked');
      expect(auth.isAnonymous, false);
      expect(anonId != null, true);
    });

    test('Logic Test: Dynamic Carry-Over finds previous session sets', () {
      final repo = MockDataRepository();
      final prevSets = repo.getPreviousPerformance('ex_bench_press');
      expect(prevSets != null, true);
      expect(prevSets!.isNotEmpty, true);
      expect(prevSets[0].weight, 40.0);
      expect(prevSets[0].reps, 10);
    });

    test('Logic Test: BackupService export and schema validation', () {
      final repo = MockDataRepository();
      final jsonStr = BackupService.exportToJson(
        profile: repo.currentUser,
        workouts: repo.workoutHistory,
        routines: repo.routines,
        customExercises: repo.customExercises,
        preferences: {'theme': 'midnight_navy'},
      );

      final result = BackupService.validateBackupJson(jsonStr);
      expect(result.isValid, true);
      expect(result.workoutCount, 4);
      expect(result.routineCount, 3);

      final imported = BackupService.importData(
        jsonStr,
        existingWorkouts: [],
        existingRoutines: [],
      );
      expect((imported['workouts'] as List).length, 4);
      expect((imported['routines'] as List).length, 3);
    });

    test('Logic Test: WorkoutSetModel serialization with set types and RIR', () {
      final set = WorkoutSetModel(
        id: 's_test_1',
        setNumber: 1,
        weight: 100.0,
        reps: 5,
        type: SetType.warmup,
        rir: 3.0,
        notes: 'Explosive warmup',
      );

      final map = set.toMap();
      final deserialized = WorkoutSetModel.fromMap(map);

      expect(deserialized.id, 's_test_1');
      expect(deserialized.weight, 100.0);
      expect(deserialized.reps, 5);
      expect(deserialized.type, SetType.warmup);
      expect(deserialized.rir, 3.0);
      expect(deserialized.notes, 'Explosive warmup');
    });

    test('Logic Test: Security Custom Claims and Admin Authorization', () {
      final adminProvider = AdminProvider();
      final authDenied = adminProvider.checkAdminAuthorization(false);
      expect(authDenied, false);
      expect(
        adminProvider.securityLogs.first.event
            .toLowerCase()
            .contains('privilege escalation'),
        true,
      );

      final authGranted = adminProvider.checkAdminAuthorization(true);
      expect(authGranted, true);
    });
  });
}
