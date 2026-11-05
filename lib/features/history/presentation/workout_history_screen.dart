import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/background_scaffold.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/glass_card.dart';
import '../../workouts/presentation/workout_details_screen.dart';
import 'history_provider.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    final sessions = provider.sessions;

    return BackgroundScaffold(
      appBar: const CustomAppBar(title: 'Workout History'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Widget Card
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Month Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_left_rounded,
                          color: AppColors.primaryWhite,
                        ),
                        onPressed: () => provider.previousMonth(),
                      ),
                      Text(
                        'November 2026',
                        style: AppTypography.headingMedium.copyWith(
                          fontSize: 17,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.primaryWhite,
                        ),
                        onPressed: () => provider.nextMonth(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Weekday row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                        .map(
                          (day) => SizedBox(
                            width: 32,
                            child: Text(
                              day,
                              textAlign: TextAlign.center,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.mutedBlue,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 10),

                  // Days Grid (Row 1: 1-7, Row 2: 8-14, etc.)
                  _buildCalendarGrid(context, provider),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text('Workout Log', style: AppTypography.sectionHeading),
            const SizedBox(height: 10),

            // History Sessions List
            ...sessions.asMap().entries.map((entry) {
              final idx = entry.key;
              final session = entry.value;
              return GlassCard(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                onTap: () {
                  provider.selectSession(session);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkoutDetailsScreen(session: session),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.glassBlue.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.cyan.withOpacity(0.3),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.fitness_center_rounded,
                          color: AppColors.cyan,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Workout Date ${idx + 1}',
                            style: AppTypography.cardTitle,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${session.title} • ${session.durationSeconds ~/ 60} min',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.mutedBlue,
                      size: 16,
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context, HistoryProvider provider) {
    // Demo 14 days representing the calendar snippet in the collage
    final workoutDays = [4, 9, 10, 11];

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: List.generate(14, (i) {
        final dayNum = i + 1;
        final hasWorkout = workoutDays.contains(dayNum);
        final isSelected = dayNum == 4;

        return GestureDetector(
          onTap: () {
            provider.selectDate(DateTime(2026, 11, dayNum));
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? AppColors.electricBlue
                  : hasWorkout
                      ? AppColors.glassBlue
                      : Colors.transparent,
              border: isSelected
                  ? Border.all(color: AppColors.cyan, width: 1.5)
                  : hasWorkout
                      ? Border.all(
                          color: AppColors.cyan.withOpacity(0.5),
                          width: 1,
                        )
                      : null,
            ),
            child: Center(
              child: Text(
                '$dayNum',
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primaryWhite
                      : hasWorkout
                          ? AppColors.cyan
                          : AppColors.mutedBlue,
                  fontSize: 12,
                  fontWeight:
                      isSelected || hasWorkout ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
