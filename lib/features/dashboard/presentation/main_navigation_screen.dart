import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/background_scaffold.dart';
import '../../../core/widgets/glass_navigation_bar.dart';
import '../../exercises/presentation/exercise_library_screen.dart';
import '../../progress/presentation/progress_dashboard_screen.dart';
import '../../routines/presentation/workout_routines_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import 'dashboard_provider.dart';
import 'dashboard_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final currentIndex = provider.currentNavIndex;

    final List<Widget> screens = [
      const DashboardScreen(),
      const ExerciseLibraryScreen(),
      const WorkoutRoutinesScreen(),
      const ProgressDashboardScreen(),
      const SettingsScreen(),
    ];

    return BackgroundScaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: GlassNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          provider.setNavIndex(index);
        },
      ),
    );
  }
}
