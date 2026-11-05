import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/background_scaffold.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_input.dart';
import '../../../core/widgets/glass_section_header.dart';
import 'admin_provider.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminProvider>();
    final analytics = provider.analytics;
    final users = provider.filteredUsers;

    return BackgroundScaffold(
      appBar: const CustomAppBar(title: 'Administrator Dashboard'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Backend Analytics
            const GlassSectionHeader(title: 'Backend Analytics'),
            const SizedBox(height: 6),

            GlassCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricItem(
                          label: 'Total Workouts',
                          value: '${analytics['totalWorkouts']}',
                          icon: Icons.fitness_center_rounded,
                          color: AppColors.electricBlue,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: AppColors.glassBorderSubtle,
                      ),
                      Expanded(
                        child: _buildMetricItem(
                          label: 'User Activity',
                          value: '${analytics['userActivity']}',
                          icon: Icons.insights_rounded,
                          color: AppColors.cyan,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.glassBorderSubtle, height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricItem(
                          label: 'Active Routines',
                          value: '${analytics['activeRoutines']}',
                          icon: Icons.list_alt_rounded,
                          color: AppColors.lightCyan,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: AppColors.glassBorderSubtle,
                      ),
                      Expanded(
                        child: _buildMetricItem(
                          label: 'System Status',
                          value: '${analytics['systemStatus']}',
                          icon: Icons.check_circle_rounded,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Section 2: User Management
            GlassSectionHeader(
              title: 'User Management',
              actionText: 'View All',
              onActionTap: () {},
            ),
            const SizedBox(height: 6),

            // Search filter for users
            GlassInput(
              hintText: 'Search athletes...',
              prefixIcon: const Icon(Icons.search_rounded),
              onChanged: (val) => provider.filterUsers(val),
            ),
            const SizedBox(height: 12),

            // Users List matching the collage
            ...users.map((user) {
              return GlassCard(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.glassBlue.withOpacity(0.5),
                        border: Border.all(
                          color: AppColors.glassBorder,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_rounded,
                          color: AppColors.primaryWhite,
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
                            user['name'],
                            style: AppTypography.cardTitle,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user['email'],
                            style: AppTypography.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${user['workouts']} Workouts',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.cyan,
                          ),
                        ),
                        Text(
                          '${user['sets']} Sets',
                          style: AppTypography.labelSmall,
                        ),
                      ],
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

  Widget _buildMetricItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.labelSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.statValue.copyWith(
              color: AppColors.primaryWhite,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
