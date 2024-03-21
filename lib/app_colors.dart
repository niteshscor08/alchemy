import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color lightPrimaryTextColor = Color(0xFF3369B4); // Deep Teal
  static const Color lightAssistantColor = Color(0xFFE1BEE7);   // Light Lavender
  static const List<Color> lightSuggestionBoxGradient = [
    Color(0xFFF4511E), // Tangerine
    Color(0xFFDAA520), // Goldenrod
    Color(0xFFD19B30), // Burnt Orange
  ];
  static const Color lightBorderColor = Color(0xFFDDDDDD);     // Light Gray

  // Dark Theme Colors
  static const Color darkPrimaryTextColor = Color(0xFFEAEAEA);  // Off-white
  static const Color darkAssistantColor = Color(0xFF004C67);    // Dark Teal
  static const List<Color> darkSuggestionBoxGradient = [
    Color(0xFFC74423), // Deep Orange
    Color(0xFFB8860B), // Dark Goldenrod
    Color(0xFFA06820), // Dark Burnt Orange
  ];
  static const Color darkBorderColor = Color(0xFF424242);     // Dark Gray

  // Shared Colors (used in both themes)
  static const Color blackColor = Colors.black;
  static const Color whiteColor = Colors.white; // Used only in light theme
}
