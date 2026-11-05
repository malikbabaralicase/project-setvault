import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/background_scaffold.dart';
import '../../../core/widgets/custom_app_bar.dart';
import 'rest_timer_provider.dart';

class RestTimerScreen extends StatelessWidget {
  const RestTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestTimerProvider>();

    return BackgroundScaffold(
      appBar: const CustomAppBar(title: 'Rest Timer'),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
          vertical: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Preset Pills
            Wrap(
              spacing: 8,
              children: [30, 60, 90, 120, 180].map((sec) {
                final isSelected = provider.initialSeconds == sec;
                return ChoiceChip(
                  label: Text('${sec}s'),
                  selected: isSelected,
                  selectedColor: AppColors.electricBlue,
                  backgroundColor: AppColors.glassBlue.withOpacity(0.4),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primaryWhite
                        : AppColors.mutedBlue,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.cyan
                          : AppColors.glassBorder,
                      width: 1,
                    ),
                  ),
                  showCheckmark: false,
                  onSelected: (_) => provider.setPreset(sec),
                );
              }).toList(),
            ),

            // Large Glowing Circular Countdown Ring
            Center(
              child: SizedBox(
                width: 260,
                height: 260,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow blur ring
                    Container(
                      width: 230,
                      height: 230,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyan.withOpacity(0.2),
                            blurRadius: 28,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    // Custom Circular Progress Painter
                    CustomPaint(
                      size: const Size(240, 240),
                      painter: _TimerRingPainter(
                        progress: provider.progressFraction,
                        activeColor: AppColors.cyan,
                        inactiveColor: AppColors.glassBlue.withOpacity(0.5),
                      ),
                    ),
                    // Centered Text
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'SET',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.mutedBlue,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          provider.formattedTime,
                          style: AppTypography.timerDisplay.copyWith(
                            fontSize: 48,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Adjustment Buttons (-30s, +30s)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAdjustButton(
                  label: '-30s',
                  onTap: () => provider.adjustTime(-30),
                ),
                const SizedBox(width: 20),
                // Play / Pause glowing circular button
                GestureDetector(
                  onTap: () => provider.toggleTimer(),
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.electricBlue, AppColors.cyan],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blueGlow.withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        provider.isRunning
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: AppColors.primaryWhite,
                        size: 42,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                _buildAdjustButton(
                  label: '+30s',
                  onTap: () => provider.adjustTime(30),
                ),
              ],
            ),

            // Reset Button
            TextButton.icon(
              onPressed: () => provider.resetTimer(),
              icon: const Icon(Icons.refresh_rounded, color: AppColors.mutedBlue),
              label: Text(
                'Reset Timer',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.mutedBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdjustButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.glassBlue.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.glassBorder,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.primaryWhite,
          ),
        ),
      ),
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  _TimerRingPainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    // Track Paint
    final trackPaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    canvas.drawCircle(center, radius, trackPaint);

    // Active Progress Arc
    final activePaint = Paint()
      ..shader = SweepGradient(
        colors: const [
          AppColors.electricBlue,
          AppColors.cyan,
          AppColors.lightCyan,
        ],
        startAngle: 0.0,
        endAngle: 2 * pi,
        transform: const GradientRotation(-pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;

    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
