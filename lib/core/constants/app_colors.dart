import 'package:flutter/material.dart';

/// Exact design tokens specified for SetVault
class AppColors {
  AppColors._();

  // BACKGROUND PALETTE
  static const Color deepMidnightNavy = Color(0xFF061326);
  static const Color darkNavy = Color(0xFF091B35);
  static const Color secondaryNavy = Color(0xFF102747);
  static const Color glassBlue = Color(0xFF15385E);

  // ACCENT COLORS
  static const Color electricBlue = Color(0xFF287BFF);
  static const Color brightBlue = Color(0xFF398DFF);
  static const Color cyan = Color(0xFF52D8FF);
  static const Color lightCyan = Color(0xFF8CEBFF);

  // TEXT COLORS
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color secondaryWhite = Color(0xFFD5E4F5);
  static const Color mutedBlue = Color(0xFF91A7C1);
  static const Color disabledText = Color(0xFF63758D);

  // BORDERS AND GLOW
  static const Color glassBorder = Color.fromRGBO(120, 190, 255, 0.25);
  static const Color glassBorderSubtle = Color.fromRGBO(120, 190, 255, 0.12);
  static const Color blueGlow = Color.fromRGBO(40, 123, 255, 0.35);
  static const Color cyanGlow = Color.fromRGBO(82, 216, 255, 0.20);

  // STATUS COLORS
  static const Color success = Color(0xFF38D996);
  static const Color warning = Color(0xFFFFBE55);
  static const Color error = Color(0xFFFF647C);

  // GRADIENTS
  static const LinearGradient electricGradient = LinearGradient(
    colors: [electricBlue, brightBlue, cyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [
      Color(0xCC102747), // ~80% opacity
      Color(0x99091B35), // ~60% opacity
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient activeCardGradient = LinearGradient(
    colors: [
      Color(0xEE15385E),
      Color(0xCC102747),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [electricBlue, brightBlue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient glowGradient = LinearGradient(
    colors: [
      Color(0x33287BFF),
      Color(0x1152D8FF),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
