import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/background_scaffold.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_section_header.dart';
import '../../administration/presentation/admin_dashboard_screen.dart';
import '../../authentication/presentation/login_screen.dart';
import 'profile_screen.dart';
import 'settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final user = settingsProvider.user;

    return BackgroundScaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
          vertical: 8,
        ),
        child: Column(
          children: [
            // User Profile Card
            GlassCard(
              padding: const EdgeInsets.all(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.cyan, width: 1.5),
                      gradient: const RadialGradient(
                        colors: [AppColors.glassBlue, AppColors.secondaryNavy],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: AppColors.primaryWhite,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: AppTypography.cardTitle),
                        const SizedBox(height: 2),
                        Text(
                          'Profile settings',
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

            const SizedBox(height: 20),

            // Settings Group
            GlassCard(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(color: AppColors.glassBorderSubtle, height: 1),
                  _buildSettingTile(
                    icon: Icons.storage_rounded,
                    title: 'Data Management',
                    subtitle: 'Local cache • Cloud sync ready',
                    onTap: () {
                      _showDataManagementDialog(context);
                    },
                  ),
                  const Divider(color: AppColors.glassBorderSubtle, height: 1),
                  _buildSettingTile(
                    icon: Icons.palette_outlined,
                    title: 'Appearance',
                    subtitle: 'Midnight Navy Theme',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Appearance Toggle Section
            const GlassSectionHeader(title: 'Appearance'),
            const SizedBox(height: 6),
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Appearance Options',
                        style: AppTypography.cardTitle.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Enable ambient cyan/electric blue glow',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),
                  Switch(
                    value: settingsProvider.glowEffectsEnabled,
                    activeThumbColor: AppColors.cyan,
                    activeTrackColor: AppColors.electricBlue.withOpacity(0.5),
                    inactiveThumbColor: AppColors.mutedBlue,
                    inactiveTrackColor: AppColors.darkNavy,
                    onChanged: (val) =>
                        settingsProvider.toggleGlowEffects(val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Administrator Portal Section
            const GlassSectionHeader(title: 'Administration'),
            const SizedBox(height: 6),
            GlassCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminDashboardScreen(),
                  ),
                );
              },
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.cyan.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: AppColors.cyan,
                  ),
                ),
                title: Text(
                  'Administrator Dashboard',
                  style: AppTypography.cardTitle,
                ),
                subtitle: Text(
                  'View platform metrics and user directory',
                  style: AppTypography.bodySmall,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.mutedBlue,
                  size: 16,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // About Project Card
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.cyan,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text('About SetVault', style: AppTypography.cardTitle),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tagline: Your Workouts. Your Progress. Your Data.\n'
                    'Project Owners: Malik Babar Ali, Sadia Iqbal\n'
                    'Architecture: Part 1 - Flutter UI Foundation',
                    style: AppTypography.bodySmall.copyWith(height: 1.4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Log Out Button
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: AppColors.error),
              ),
              tileColor: AppColors.error.withOpacity(0.08),
              leading: const Icon(Icons.logout_rounded, color: AppColors.error),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.mutedBlue),
      title: Text(title, style: AppTypography.cardTitle.copyWith(fontSize: 15)),
      subtitle: subtitle != null
          ? Text(subtitle, style: AppTypography.bodySmall)
          : null,
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: AppColors.mutedBlue,
        size: 14,
      ),
      onTap: onTap,
    );
  }

  void _showDataManagementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.secondaryNavy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        title: Text('Data Management', style: AppTypography.headingMedium),
        content: Text(
          'Part 1: In-memory repository active.\n'
          'Part 2: Firebase Cloud Firestore synchronization will connect seamlessly.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricBlue,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(color: AppColors.primaryWhite)),
          ),
        ],
      ),
    );
  }
}
