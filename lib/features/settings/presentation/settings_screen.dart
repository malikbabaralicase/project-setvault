import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/services/backup_service.dart';
import '../../../core/widgets/background_scaffold.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_section_header.dart';
import '../../../data/repositories/mock_data_repository.dart';
import '../../administration/presentation/admin_dashboard_screen.dart';
import '../../authentication/presentation/auth_provider.dart';
import '../../authentication/presentation/login_screen.dart';
import '../../authentication/presentation/registration_screen.dart';
import 'profile_screen.dart';
import 'settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser ?? settingsProvider.user;

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
                          user.isAnonymous
                              ? 'Guest Athlete (Tap to link account)'
                              : 'Profile settings',
                          style: AppTypography.bodySmall.copyWith(
                            color: user.isAnonymous
                                ? AppColors.warning
                                : AppColors.mutedBlue,
                          ),
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

            if (user.isAnonymous) ...[
              const SizedBox(height: 12),
              // Upgrade Guest Account Banner
              GlassCard(
                borderColor: AppColors.warning,
                padding: const EdgeInsets.all(14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegistrationScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      color: AppColors.warning,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Save Your Data to Cloud',
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.warning,
                            ),
                          ),
                          Text(
                            'Link an email to preserve workouts permanently across devices.',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.warning,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 18),

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
                    icon: Icons.backup_outlined,
                    title: 'Export / Import Backup',
                    subtitle: 'Versioned JSON format with validation',
                    onTap: () {
                      _showBackupDialog(context, user);
                    },
                  ),
                  const Divider(color: AppColors.glassBorderSubtle, height: 1),
                  _buildSettingTile(
                    icon: Icons.storage_rounded,
                    title: 'Data Management & Sync',
                    subtitle: 'Firestore offline persistence enabled',
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
                    'Architecture: Part 2 - Cloud Firestore, Auth & Offline Engine',
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
              onTap: () async {
                await auth.logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
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

  void _showBackupDialog(BuildContext context, dynamic user) {
    final repo = MockDataRepository();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.secondaryNavy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        title: Text('JSON Backup & Restore', style: AppTypography.headingMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export versioned snapshot of all workouts, routines, and custom exercises or import an existing backup.',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.electricBlue,
                minimumSize: const Size.fromHeight(42),
              ),
              icon: const Icon(Icons.download_rounded, color: AppColors.primaryWhite),
              label: const Text('Export JSON Backup', style: TextStyle(color: AppColors.primaryWhite)),
              onPressed: () {
                final jsonStr = BackupService.exportToJson(
                  profile: repo.currentUser,
                  workouts: repo.workoutHistory,
                  routines: repo.routines,
                  customExercises: repo.customExercises,
                  preferences: {'theme': 'midnight_navy'},
                );
                Navigator.pop(ctx);
                _showExportResultDialog(context, jsonStr);
              },
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.cyan),
                minimumSize: const Size.fromHeight(42),
              ),
              icon: const Icon(Icons.upload_file_rounded, color: AppColors.cyan),
              label: const Text('Validate & Import Backup', style: TextStyle(color: AppColors.cyan)),
              onPressed: () {
                Navigator.pop(ctx);
                _showImportInputDialog(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: AppColors.mutedBlue)),
          ),
        ],
      ),
    );
  }

  void _showExportResultDialog(BuildContext context, String jsonStr) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.secondaryNavy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        title: Text('Backup Ready (v1.0)', style: AppTypography.headingMedium),
        content: Text(
          'Backup successfully generated.\nSize: ${jsonStr.length} bytes\nWorkouts: 4 • Routines: 3',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricBlue,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done', style: TextStyle(color: AppColors.primaryWhite)),
          ),
        ],
      ),
    );
  }

  void _showImportInputDialog(BuildContext context) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.secondaryNavy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        title: Text('Import JSON Backup', style: AppTypography.headingMedium),
        content: TextField(
          controller: textController,
          maxLines: 5,
          style: const TextStyle(fontSize: 12, color: AppColors.primaryWhite),
          decoration: const InputDecoration(
            hintText: 'Paste valid SetVault JSON backup payload here...',
            hintStyle: TextStyle(color: AppColors.mutedBlue),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.mutedBlue)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricBlue,
            ),
            onPressed: () {
              final validation =
                  BackupService.validateBackupJson(textController.text.trim());
              Navigator.pop(ctx);
              if (validation.isValid) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Valid backup: ${validation.workoutCount} workouts, ${validation.routineCount} routines validated.',
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Validation failed: ${validation.error}'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: const Text('Validate & Restore', style: TextStyle(color: AppColors.primaryWhite)),
          ),
        ],
      ),
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
          '• Local Offline Engine: Active\n'
          '• Unfinished Workout Protection: Enabled\n'
          '• Cloud Firestore Cache: Unlimited\n'
          '• Sync Protocol: Real-time with automatic reconnection',
          style: AppTypography.bodyMedium.copyWith(height: 1.5),
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
