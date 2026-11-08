import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';

enum GlassButtonType { primary, secondary, outline, text }

class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final GlassButtonType type;
  final Widget? icon;
  final double? width;
  final double height;
  final bool isLoading;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const GlassButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = GlassButtonType.primary,
    this.icon,
    this.width,
    this.height = AppDimensions.buttonHeight,
    this.isLoading = false,
    this.borderRadius = AppDimensions.buttonRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = AppColors.primaryWhite;
    LinearGradient? gradient;
    Color? solidColor;
    Border? border;
    List<BoxShadow> shadows = [];

    switch (type) {
      case GlassButtonType.primary:
        gradient = const LinearGradient(
          colors: [AppColors.electricBlue, AppColors.brightBlue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );
        shadows = [
          const BoxShadow(
            color: AppColors.blueGlow,
            blurRadius: 14,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ];
        break;

      case GlassButtonType.secondary:
        solidColor = AppColors.glassBlue.withOpacity(0.5);
        border = Border.all(
          color: AppColors.glassBorder,
          width: AppDimensions.borderWidth,
        );
        break;

      case GlassButtonType.outline:
        solidColor = Colors.transparent;
        border = Border.all(
          color: AppColors.cyan.withOpacity(0.5),
          width: 1.2,
        );
        textColor = AppColors.cyan;
        break;

      case GlassButtonType.text:
        solidColor = Colors.transparent;
        textColor = AppColors.cyan;
        break;
    }

    Widget content = isLoading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryWhite),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: AppTypography.labelLarge.copyWith(
                  color: textColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          );

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(borderRadius),
              onTap: isLoading ? null : onPressed,
              child: Container(
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: gradient,
                  color: solidColor,
                  border: border,
                ),
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

