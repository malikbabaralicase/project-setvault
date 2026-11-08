import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/background_scaffold.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/glass_card.dart';
import '../../workouts/presentation/active_workout_screen.dart';
import 'create_routine_screen.dart';
import 'routine_provider.dart';

class WorkoutRoutinesScreen extends StatelessWidget {
  const WorkoutRoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoutineProvider>();
    final routines = provider.routines;

    return BackgroundScaffold(
      appBar: CustomAppBar(
        title: 'Workout Routines',
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            color: AppColors.cyan,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateRoutineScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
          vertical: 12,
        ),
        itemCount: routines.length,
        itemBuilder: (context, idx) {
          final r = routines[idx];
          return GlassCard(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            onTap: () {
              // Direct one-tap start workout with this routine
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ActiveWorkoutScreen(),
                ),
              );
            },
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.title,
                        style: AppTypography.headingMedium.copyWith(
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Workouts: ${r.totalWorkouts} sessions',
                        style: AppTypography.bodySmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Training Volume: ${r.trainingVolumeKg.toInt()} kg',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.cyan,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.glassBlue.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.glassBorder,
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.cyan,
                    size: 18,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

