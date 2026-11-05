import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/background_scaffold.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_input.dart';
import '../../../core/widgets/glass_stat_card.dart';
import 'settings_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    final user = context.read<SettingsProvider>().user;
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _usernameController = TextEditingController(text: user.username);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<SettingsProvider>().user;

    return BackgroundScaffold(
      appBar: const CustomAppBar(title: 'User Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
          vertical: 12,
        ),
        child: Column(
          children: [
            // Center Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.cyan, width: 2),
                      gradient: const RadialGradient(
                        colors: [AppColors.glassBlue, AppColors.secondaryNavy],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.cyanGlow,
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: AppColors.primaryWhite,
                        size: 46,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.electricBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 16,
                        color: AppColors.primaryWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Text(user.name, style: AppTypography.headingLarge),
            Text(
              '@${user.username} • Athlete',
              style: AppTypography.bodySmall.copyWith(color: AppColors.cyan),
            ),

            const SizedBox(height: 20),

            // User Lifetime Stats
            Row(
              children: [
                Expanded(
                  child: GlassStatCard(
                    label: 'Total Sets',
                    value: '${user.totalSets}',
                    icon: Icons.layers_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlassStatCard(
                    label: 'Day Streak',
                    value: '${user.streakDays} Days',
                    icon: Icons.local_fire_department_rounded,
                    iconColor: AppColors.warning,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Form inputs
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GlassInput(
                    label: 'Display Name',
                    controller: _nameController,
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                  const SizedBox(height: 14),
                  GlassInput(
                    label: 'Email Address',
                    controller: _emailController,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 14),
                  GlassInput(
                    label: 'Username',
                    controller: _usernameController,
                    prefixIcon: const Icon(Icons.alternate_email_rounded),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            GlassButton(
              text: 'Save Changes',
              type: GlassButtonType.primary,
              width: double.infinity,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully'),
                    backgroundColor: AppColors.glassBlue,
                  ),
                );
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
