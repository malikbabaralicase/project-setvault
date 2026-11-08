import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ExerciseThumbnail extends StatelessWidget {
  final String exerciseName;
  final double height;
  final double? width;
  final double borderRadius;

  const ExerciseThumbnail({
    super.key,
    required this.exerciseName,
    this.height = 120,
    this.width,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String badge;

    if (exerciseName.toLowerCase().contains('bench') ||
        exerciseName.toLowerCase().contains('press')) {
      icon = Icons.fitness_center_rounded;
      badge = 'CHEST';
    } else if (exerciseName.toLowerCase().contains('squat') ||
        exerciseName.toLowerCase().contains('leg')) {
      icon = Icons.directions_run_rounded;
      badge = 'LEGS';
    } else if (exerciseName.toLowerCase().contains('deadlift') ||
        exerciseName.toLowerCase().contains('pull')) {
      icon = Icons.accessibility_new_rounded;
      badge = 'BACK';
    } else if (exerciseName.toLowerCase().contains('raise') ||
        exerciseName.toLowerCase().contains('shoulder')) {
      icon = Icons.sports_gymnastics_rounded;
      badge = 'SHOULDERS';
    } else {
      icon = Icons.fitness_center_rounded;
      badge = 'ARMS';
    }

    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF15385E).withOpacity(0.9),
            const Color(0xFF091B35).withOpacity(0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.glassBorderSubtle,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Background abstract mesh
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              icon,
              size: height * 0.9,
              color: AppColors.cyan.withOpacity(0.06),
            ),
          ),
          // Center Icon
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [
                    Color(0x3352D8FF),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Icon(
                icon,
                size: height * 0.36,
                color: AppColors.cyan,
              ),
            ),
          ),
          // Muscle Badge
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.deepMidnightNavy.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.glassBorder,
                  width: 0.8,
                ),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: AppColors.lightCyan,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

