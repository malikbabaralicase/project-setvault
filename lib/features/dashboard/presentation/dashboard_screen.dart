import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_section_header.dart';
import '../../../core/widgets/glass_stat_card.dart';
import '../../workouts/presentation/active_workout_screen.dart';
import '../../workouts/presentation/workout_details_screen.dart';
import 'dashboard_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final user = provider.user;
    final recentWorkout = provider.recentWorkout;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Bar: User Profile Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.cyan,
                        width: 1.5,
                      ),
                      gradient: const RadialGradient(
                        colors: [
                          AppColors.glassBlue,
                          AppColors.secondaryNavy,
                        ],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.cyanGlow,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: AppColors.primaryWhite,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.demoUserGreeting,
                        style: AppTypography.bodySmall,
                      ),
                      Text(
                        user.name.split(' ').first,
                        style: AppTypography.headingMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  // Streak badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.glassBlue.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.warning.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          color: AppColors.warning,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${user.streakDays}d',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.warning,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Notification bell
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.glassBlue.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.glassBorder,
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        const Icon(
                          Icons.notifications_outlined,
                          color: AppColors.primaryWhite,
                          size: 20,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.cyan,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),
          Text(
            'November 5, 2026',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.mutedBlue,
            ),
          ),

          const SizedBox(height: 20),

          // Hero Workout Card: "Ready to Train?"
          GlassCard(
            padding: const EdgeInsets.all(20),
            hasGlow: true,
            glowColor: AppColors.blueGlow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ready to Train?',
                  style: AppTypography.headingLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Begin your planned session.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.secondaryWhite.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 18),
                GlassButton(
                  text: 'START WORKOUT',
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
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Two Stat Cards: Total Workouts & Training Volume
          Row(
            children: [
              Expanded(
                child: GlassStatCard(
                  label: 'Total Workouts',
                  value: '${user.totalWorkouts}',
                  icon: Icons.fitness_center_rounded,
                  iconColor: AppColors.electricBlue,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: GlassStatCard(
                  label: 'Training Volume',
                  value: '128,450 kg',
                  icon: Icons.scale_rounded,
                  iconColor: AppColors.cyan,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Section Header: Recent Workout
          GlassSectionHeader(
            title: 'Recent Workout',
            actionText: 'View All',
            onActionTap: () {
              provider.setNavIndex(3); // Progress or History
            },
          ),
          const SizedBox(height: 8),

          // Recent Workout Card
          GlassCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkoutDetailsScreen(
                    session: recentWorkout,
                  ),
                ),
              );
            },
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [AppColors.glassBlue, AppColors.secondaryNavy],
                    ),
                    border: Border.all(
                      color: AppColors.glassBorder,
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.fitness_center_rounded,
                    color: AppColors.cyan,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recentWorkout.title,
                        style: AppTypography.cardTitle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Summary • 58 min • 15 sets',
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
          ),

          const SizedBox(height: 90), // Space for floating bottom nav
        ],
      ),
    );
  }
}

