import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFF7B61FF);
  static const Color secondary = Color(0xFFF9F9F9);

  // Gradient Colors
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [Color(0xfffffa9e), Color(0xFFFAD0C4), Color(0xFFFAD0C4)],
  );

  // Text Colors
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;

  // Primary Colors
  static const Color red = Colors.red;
  static const Color green = Colors.green;
  static const Color blue = Colors.blue;
  static const Color yellow = Colors.yellow;
  static const Color orange = Colors.orange;
  static const Color purple = Colors.purple;
  static const Color pink = Colors.pink;

  // Shades (optional, commonly used)
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF2E2E2E);
  static const Color lightBlue = Color(0xFF2196F3);
  static const Color darkRed = Color(0xFFB71C1C);

  // Transparent
  static const Color transparent = Colors.transparent;

  static const Color blue50 = Color(0xFFE9EFFC);
  static const Color blue100 = Color(0xFFBBCDF4);
  static const Color blue200 = Color(0xFF9AB4EF);
  static const Color blue300 = Color(0xFF6C92E8);
  static const Color blue400 = Color(0xFF4F7DE4);
  static const Color blue500 = Color(0xFF235DDD);
  static const Color blue600 = Color(0xFF2055C9);
  static const Color blue700 = Color(0xFF19429D);
  static const Color blue800 = Color(0xFF13337A);
  static const Color blue900 = Color(0xFF0F275D); // filtered color

  // Green shades
  static const Color green50 = Color(0xFFE8F8F6);
  static const Color green100 = Color(0xFFB6E9E3);
  static const Color green200 = Color(0xFF93DED6);
  static const Color green300 = Color(0xFF62CFC3);
  static const Color green400 = Color(0xFF43C6B8);
  static const Color green500 = Color(0xFF14B8A6);
  static const Color green600 = Color(0xFF12A797);
  static const Color green700 = Color(0xFF0E8376);
  static const Color green800 = Color(0xFF0B655B);
  static const Color green900 = Color(0xFF084D46);

  // Black / Grey shades
  static const Color black50 = Color(0xFFE6E6E6);
  static const Color black100 = Color(0xFFB2B2B2);
  static const Color black200 = Color(0xFF8C8C8C);
  static const Color black300 = Color(0xFF585858);
  static const Color black400 = Color(0xFF373737);
  static const Color black500 = Color(0xFF050505);
  static const Color black600 = Color(0xFF050505);
  static const Color black700 = Color(0xFF040404);
  static const Color black800 = Color(0xFF030303);
  static const Color black900 = Color(0xFF020202);

  // Custom filtered / semantic colors

  static const Color textSecondary = Color(0xFF636F85);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textSubtitle = Color(0xff676C75);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color primaryBackground = Color(0xFFFFFFFF);

  // Surface Colors
  static const Color surfaceLight = Color(0xFFE0E0E0);
  static const Color surfaceDark = Color(0xFF2C2C2C);

  // Container Colors
  static const Color containerBackground = Color(0xFFD9D9D9);
  static const Color containerBackground1 = Color(0xFFF9F9FB);

  // Utility Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF29B6F6);

  /// textformfield border color
  static const Color textFormFieldBorder = Color(0xFFD9D9D9);
  static const Color containerBorder = Color(0xFFCDCED2);
  static const Color textThird = Color(0xFF6B6B6B);
  static const Color dividerColor = Color(0xFFD1D6DB);
  static const Color containerColor = Color(0xFFf0f0f0);
}