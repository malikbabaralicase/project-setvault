import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/background_scaffold.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_section_header.dart';
import 'progress_provider.dart';

class ProgressDashboardScreen extends StatelessWidget {
  const ProgressDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgressProvider>();

    return BackgroundScaffold(
      appBar: const CustomAppBar(title: 'Progress Dashboard'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chart 1: Weekly Volume
            const GlassSectionHeader(title: 'Weekly Volume'),
            const SizedBox(height: 6),
            GlassCard(
              padding: const EdgeInsets.fromLTRB(10, 18, 16, 12),
              child: SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 5000,
                      getDrawingHorizontalLine: (val) => const FlLine(
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
                          interval: 10000,
                          reservedSize: 34,
                          getTitlesWidget: (val, meta) => Text(
                            '${(val / 1000).toInt()}k',
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
                          getTitlesWidget: (val, meta) {
                            final idx = val.toInt();
                            if (idx >= 0 && idx < provider.weekDays.length) {
                              return Text(
                                provider.weekDays[idx],
                                style: AppTypography.labelSmall.copyWith(
                                  fontSize: 10,
                                  color: AppColors.mutedBlue,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          provider.weeklyVolume.length,
                          (i) => FlSpot(i.toDouble(), provider.weeklyVolume[i]),
                        ),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: AppColors.cyan,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
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

            const SizedBox(height: 20),

            // Chart 2: Weight Progression
            const GlassSectionHeader(title: 'Weight Progression'),
            const SizedBox(height: 6),
            GlassCard(
              padding: const EdgeInsets.fromLTRB(10, 18, 16, 12),
              child: SizedBox(
                height: 160,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      getDrawingHorizontalLine: (val) => const FlLine(
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
                          interval: 1,
                          reservedSize: 34,
                          getTitlesWidget: (val, meta) => Text(
                            val.toStringAsFixed(1),
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
                          getTitlesWidget: (val, meta) {
                            final idx = val.toInt();
                            if (idx >= 0 && idx < provider.weightDates.length) {
                              return Text(
                                provider.weightDates[idx],
                                style: AppTypography.labelSmall.copyWith(
                                  fontSize: 10,
                                  color: AppColors.mutedBlue,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          provider.weightProgression.length,
                          (i) => FlSpot(i.toDouble(), provider.weightProgression[i]),
                        ),
                        isCurved: true,
                        curveSmoothness: 0.3,
                        color: AppColors.electricBlue,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 3.5,
                            color: AppColors.electricBlue,
                            strokeWidth: 1.5,
                            strokeColor: AppColors.cyan,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.electricBlue.withOpacity(0.3),
                              AppColors.electricBlue.withOpacity(0.0),
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

            const SizedBox(height: 20),

            // Personal Records List
            const GlassSectionHeader(title: 'Personal Records'),
            const SizedBox(height: 6),
            ...provider.personalRecords.map((pr) {
              return GlassCard(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pr.exerciseName,
                      style: AppTypography.cardTitle,
                    ),
                    Text(
                      pr.record,
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.cyan,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
