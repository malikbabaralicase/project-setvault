import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:setvault/core/constants/app_strings.dart';
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
  group('SetVault Part 1 Comprehensive Screen & Logic Tests', () {
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

    testWidgets('Screen 3: Active Workout renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const ActiveWorkoutScreen()));
      await tester.pump();
      expect(find.text('Push Day'), findsOneWidget);
      expect(find.text('Finish Workout'), findsOneWidget);
      expect(find.text('Bench Press'), findsOneWidget);
      expect(find.text('Rest Timer'), findsOneWidget);
    });

    testWidgets('Screen 4: Exercise Library renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const ExerciseLibraryScreen()));
      await tester.pump();
      expect(find.text('Exercise Library'), findsOneWidget);
      expect(find.text('Bench Press'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Chest'), findsOneWidget);
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

    testWidgets('Screen 10: Progress Dashboard renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const ProgressDashboardScreen()));
      await tester.pump();
      expect(find.text('Progress Dashboard'), findsOneWidget);
      expect(find.text('Weekly Volume'), findsOneWidget);
      expect(find.text('Weight Progression'), findsOneWidget);
      expect(find.text('Personal Records'), findsOneWidget);
    });

    testWidgets('Screen 11: Rest Timer renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const RestTimerScreen()));
      await tester.pump();
      expect(find.text('Rest Timer'), findsOneWidget);
      expect(find.text('SET'), findsOneWidget);
      expect(find.text('01:30'), findsOneWidget);
      expect(find.text('Reset Timer'), findsOneWidget);
    });

    testWidgets('Screen 12: Settings & Profile renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const SettingsScreen()));
      await tester.pump();
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Alex Morgan'), findsOneWidget);
      expect(find.text('Appearance Options'), findsOneWidget);
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

    testWidgets('Screen 16: Administrator Dashboard renders correctly', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const AdminDashboardScreen()));
      await tester.pump();
      expect(find.text('Administrator Dashboard'), findsOneWidget);
      expect(find.text('Backend Analytics'), findsOneWidget);
      expect(find.text('User Management'), findsOneWidget);
      expect(find.text('26'), findsOneWidget);
      expect(find.text('3277'), findsOneWidget);
    });

    testWidgets('Main Navigation Screen switches tabs smoothly', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const MainNavigationScreen()));
      await tester.pump();

      expect(find.byType(DashboardScreen), findsOneWidget);

      // Tap on Routines tab
      await tester.tap(find.byIcon(Icons.format_list_bulleted_rounded));
      await tester.pump();
      expect(find.byType(WorkoutRoutinesScreen), findsOneWidget);

      // Tap on Progress tab
      await tester.tap(find.byIcon(Icons.show_chart_rounded));
      await tester.pump();
      expect(find.byType(ProgressDashboardScreen), findsOneWidget);

      // Tap on Settings tab
      await tester.tap(find.byIcon(Icons.person_rounded));
      await tester.pump();
      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    test('Unit Test: MockDataRepository consistent data contract', () {
      final repo = MockDataRepository();
      expect(repo.currentUser.name, AppStrings.demoUserName);
      expect(repo.workoutHistory.first.title, 'Push Day');
      expect(repo.routines.length, 3);
      expect(repo.adminAnalytics['totalWorkouts'], 26);
      expect(repo.adminUsers.length, 4);
    });
  });
}
