import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class SetVaultLogo extends StatelessWidget {
  final double size;
  final bool showTagline;
  final bool showText;

  const SetVaultLogo({
    super.key,
    this.size = 54,
    this.showTagline = false,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(size * 1.4, size),
          painter: _DumbbellPainter(),
        ),
        if (showText) ...[
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTypography.displayLarge.copyWith(
                fontSize: size * 0.55,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
              children: const [
                TextSpan(
                  text: 'Set',
                  style: TextStyle(color: AppColors.primaryWhite),
                ),
                TextSpan(
                  text: 'Vault',
                  style: TextStyle(
                    color: AppColors.cyan,
                    shadows: [
                      Shadow(
                        color: AppColors.cyanGlow,
                        blurRadius: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        if (showTagline) ...[
          const SizedBox(height: 8),
          Text(
            'Your Workouts. Your Progress. Your Data.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.mutedBlue,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ],
    );
  }
}

class _DumbbellPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Paint barPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.electricBlue, AppColors.cyan],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..strokeWidth = h * 0.14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Paint platePaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.cyan, AppColors.electricBlue],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    final Paint glowPaint = Paint()
      ..color = AppColors.cyan.withOpacity(0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Center bar
    final double barY = h * 0.5;
    canvas.drawLine(
      Offset(w * 0.22, barY),
      Offset(w * 0.78, barY),
      barPaint,
    );

    // Outer plates - Left
    final RRect leftOuter = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.16, barY),
        width: w * 0.08,
        height: h * 0.72,
      ),
      Radius.circular(w * 0.03),
    );
    // Inner plates - Left
    final RRect leftInner = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.26, barY),
        width: w * 0.08,
        height: h * 0.92,
      ),
      Radius.circular(w * 0.03),
    );

    // Outer plates - Right
    final RRect rightOuter = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.84, barY),
        width: w * 0.08,
        height: h * 0.72,
      ),
      Radius.circular(w * 0.03),
    );
    // Inner plates - Right
    final RRect rightInner = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.74, barY),
        width: w * 0.08,
        height: h * 0.92,
      ),
      Radius.circular(w * 0.03),
    );

    // Draw glow
    canvas.drawRRect(leftInner, glowPaint);
    canvas.drawRRect(rightInner, glowPaint);

    // Draw plates
    canvas.drawRRect(leftOuter, platePaint);
    canvas.drawRRect(leftInner, platePaint);
    canvas.drawRRect(rightInner, platePaint);
    canvas.drawRRect(rightOuter, platePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

