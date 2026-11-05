import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/background_scaffold.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../data/models/workout_session_model.dart';
import 'active_workout_screen.dart';

class WorkoutDetailsScreen extends StatelessWidget {
  final WorkoutSessionModel session;

  const WorkoutDetailsScreen({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      appBar: CustomAppBar(
        title: 'Workout Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            color: AppColors.primaryWhite,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Workout session link copied to clipboard'),
                  backgroundColor: AppColors.glassBlue,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session Hero Card with Date Badge
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.electricBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.cyan.withOpacity(0.4),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Nov',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.cyan,
                          ),
                        ),
                        Text(
                          '${session.date.day}',
                          style: AppTypography.headingLarge.copyWith(
                            color: AppColors.primaryWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.title,
                          style: AppTypography.headingLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'November ${session.date.day}, ${session.date.year}',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Duration and Sets Stat Card
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        color: AppColors.cyan,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text('Duration', style: AppTypography.bodySmall),
                    ],
                  ),
                  Text(
                    '00:25:43',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.cyan,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text('Completed Sets', style: AppTypography.sectionHeading),
            const SizedBox(height: 10),

            // Exercise Sets Breakdown
            ...session.exercises.map((ex) {
              return GlassCard(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ex.exercise.name, style: AppTypography.cardTitle),
                    const SizedBox(height: 12),
                    ...ex.sets.map((set) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
                              child: Text(
                                'Set ${set.setNumber}',
                                style: AppTypography.labelMedium.copyWith(
                                  color: AppColors.mutedBlue,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${set.weight.toInt()} kg × ${set.reps}',
                                style: AppTypography.labelLarge,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.success,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                size: 14,
                                color: AppColors.deepMidnightNavy,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),

            // Repeat Workout Action
            GlassButton(
              text: 'Repeat Workout',
              type: GlassButtonType.primary,
              width: double.infinity,
              icon: const Icon(
                Icons.replay_rounded,
                color: AppColors.primaryWhite,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ActiveWorkoutScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
