import 'package:flutter/material.dart';

class AppColors {
  // Official Palette
  static const Color primaryDark = Color(0xFF005461); // Bleu profond
  static const Color primary = Color(0xFF018790);     // Bleu-vert
  static const Color accent = Color(0xFF00B7B5);      // Turquoise
  static const Color background = Color(0xFFF4F4F4);  // Gris très clair
  
  // Additional shades
  static const Color white = Colors.white;
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF777777);
  static const Color danger = Color(0xFFFF5252);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryDark, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
