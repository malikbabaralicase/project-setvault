import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/administration/presentation/admin_provider.dart';
import 'features/authentication/presentation/auth_provider.dart';
import 'features/authentication/presentation/splash_screen.dart';
import 'features/dashboard/presentation/dashboard_provider.dart';
import 'features/exercises/presentation/exercise_provider.dart';
import 'features/history/presentation/history_provider.dart';
import 'features/progress/presentation/progress_provider.dart';
import 'features/routines/presentation/routine_provider.dart';
import 'features/settings/presentation/settings_provider.dart';
import 'features/timer/presentation/rest_timer_provider.dart';
import 'features/workouts/presentation/active_workout_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system bar styles for deep midnight navy theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.deepMidnightNavy,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const SetVaultApp());
}

class SetVaultApp extends StatelessWidget {
  const SetVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: 'SetVault',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
