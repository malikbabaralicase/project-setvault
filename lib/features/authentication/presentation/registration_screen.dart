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
import '../../../core/widgets/setvault_logo.dart';
import '../../dashboard/presentation/main_navigation_screen.dart';
import 'auth_provider.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController(text: 'Alex Morgan');
  final _usernameController = TextEditingController(text: 'alexm');
  final _passwordController = TextEditingController(text: 'password123');
  final _confirmPasswordController = TextEditingController(text: 'password123');
  bool _agreedToTerms = true;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    final authProvider = context.read<AuthProvider>();
    final email = _usernameController.text.contains('@')
        ? _usernameController.text
        : '${_usernameController.text}@example.com';
    final success = await authProvider.register(
      name: _nameController.text,
      email: email,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return BackgroundScaffold(
      appBar: const CustomAppBar(title: 'Registration'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
          vertical: 12,
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const SetVaultLogo(size: 40, showTagline: false),
            const SizedBox(height: 20),
            GlassCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Account',
                    style: AppTypography.headingMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Start your personal strength progression ledger',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  GlassInput(
                    label: 'Full Name',
                    hintText: 'Alex Morgan',
                    controller: _nameController,
                    prefixIcon: const Icon(Icons.badge_outlined),
                  ),
                  const SizedBox(height: 14),
                  GlassInput(
                    label: 'Username',
                    hintText: 'alexm',
                    controller: _usernameController,
                    prefixIcon: const Icon(Icons.alternate_email_rounded),
                  ),
                  const SizedBox(height: 14),
                  GlassInput(
                    label: 'Password',
                    hintText: '••••••••••••',
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                  ),
                  const SizedBox(height: 14),
                  GlassInput(
                    label: 'Confirm Password',
                    hintText: '••••••••••••',
                    controller: _confirmPasswordController,
                    isPassword: true,
                    prefixIcon: const Icon(Icons.lock_reset_rounded),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _agreedToTerms,
                          activeColor: AppColors.cyan,
                          checkColor: AppColors.deepMidnightNavy,
                          side: const BorderSide(
                            color: AppColors.glassBorder,
                            width: 1.5,
                          ),
                          onChanged: (val) {
                            setState(() {
                              _agreedToTerms = val ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'I agree to the workout privacy & data storage policy',
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (authProvider.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      authProvider.errorMessage!,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  GlassButton(
                    text: 'REGISTER',
                    type: GlassButtonType.primary,
                    width: double.infinity,
                    isLoading: authProvider.isLoading,
                    onPressed: _agreedToTerms ? _handleRegister : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: AppTypography.bodySmall,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Log In',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.cyan,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

