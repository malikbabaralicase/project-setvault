import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/background_scaffold.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/exercise_thumbnail.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_section_header.dart';
import '../../../data/models/exercise_model.dart';
import '../../workouts/presentation/active_workout_screen.dart';

class ExerciseDetailsScreen extends StatelessWidget {
  final ExerciseModel exercise;

  const ExerciseDetailsScreen({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      appBar: CustomAppBar(
        title: 'Exercise Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            color: AppColors.cyan,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${exercise.name} saved to favorites'),
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
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise Big Name
            Text(
              exercise.name,
              style: AppTypography.displayLarge.copyWith(fontSize: 26),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.electricBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.electricBlue, width: 1),
                  ),
                  child: Text(
                    exercise.muscleGroup.toUpperCase(),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.cyan,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  exercise.equipment,
                  style: AppTypography.bodySmall,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Large Media Box
            ExerciseThumbnail(
              exerciseName: exercise.name,
              height: 200,
              borderRadius: 18,
            ),

            const SizedBox(height: 18),

            // Personal Best Glass Card
            GlassCard(
              padding: const EdgeInsets.all(18),
              hasGlow: true,
              glowColor: AppColors.blueGlow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        exercise.personalBest,
                        style: AppTypography.headingMedium.copyWith(
                          color: AppColors.primaryWhite,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Icon(
                        Icons.emoji_events_rounded,
                        color: AppColors.warning,
                        size: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    exercise.lastPerformance,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.cyan,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Performance History Section
            const GlassSectionHeader(title: 'Performance History'),
            const SizedBox(height: 8),

            // Spline Chart with glowing line
            GlassCard(
              padding: const EdgeInsets.fromLTRB(12, 20, 16, 12),
              child: SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) => const FlLine(
                        color: AppColors.glassBorderSubtle,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 20,
                          reservedSize: 32,
                          getTitlesWidget: (val, meta) => Text(
                            '${val.toInt()}',
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 10,
                              color: AppColors.mutedBlue,
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (val, meta) => Text(
                            'S${val.toInt() + 1}',
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 10,
                              color: AppColors.mutedBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          exercise.performanceHistory.length,
                          (i) => FlSpot(i.toDouble(), exercise.performanceHistory[i]),
                        ),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: AppColors.cyan,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.cyan,
                            strokeWidth: 2,
                            strokeColor: AppColors.deepMidnightNavy,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.cyan.withOpacity(0.35),
                              AppColors.cyan.withOpacity(0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // Instructions
            const GlassSectionHeader(title: 'Execution Instructions'),
            const SizedBox(height: 6),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Text(
                exercise.instructions,
                style: AppTypography.bodyMedium.copyWith(
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Start Exercise Action
            GlassButton(
              text: 'LOG THIS EXERCISE',
              type: GlassButtonType.primary,
              width: double.infinity,
              icon: const Icon(
                Icons.play_arrow_rounded,
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

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
