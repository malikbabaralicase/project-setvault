import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/background_scaffold.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/setvault_logo.dart';
import 'login_screen.dart';
import '../../dashboard/presentation/main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      body: Stack(
        children: [
          // Subtle gym silhouette backdrop
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: CustomPaint(
                painter: _GymSilhouettePainter(),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 40),
                // Center Logo and Tagline
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: const SetVaultLogo(
                      size: 72,
                      showTagline: true,
                    ),
                  ),
                ),
                // Bottom Action Buttons
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GlassButton(
                        text: 'START TRAINING',
                        type: GlassButtonType.primary,
                        width: double.infinity,
                        icon: const Icon(
                          Icons.play_arrow_rounded,
                          color: AppColors.primaryWhite,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MainNavigationScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      GlassButton(
                        text: 'SIGN IN',
                        type: GlassButtonType.secondary,
                        width: double.infinity,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Version 1.0.0 • Architecture Phase',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.mutedBlue.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GymSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.cyan.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final double w = size.width;
    final double h = size.height;

    // Geometric grid lines representing gym training cage & equipment
    canvas.drawLine(Offset(w * 0.15, h * 0.2), Offset(w * 0.15, h * 0.8), paint);
    canvas.drawLine(Offset(w * 0.85, h * 0.2), Offset(w * 0.85, h * 0.8), paint);
    canvas.drawLine(Offset(w * 0.1, h * 0.35), Offset(w * 0.9, h * 0.35), paint);
    canvas.drawLine(Offset(w * 0.1, h * 0.65), Offset(w * 0.9, h * 0.65), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
