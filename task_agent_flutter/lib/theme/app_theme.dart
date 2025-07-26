import 'package:flutter/material.dart';

// Color scheme based on lucian_s_application
class AppColors {
  static const Color background = Color(0xFFF3F3F3);
  static const Color primaryDark = Color(0xFF3B3B3B);
  static const Color primaryDarker = Color(0xFF2C2C2C);
  static const Color accent = Color(0xFFCFFF0B);
  static const Color lightGray = Color(0xFFF4F4F4);
  static const Color gray = Color(0xFF999999);
  static const Color white = Colors.white;
  static const Color black = Color(0xFF1E1E1E);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryDark,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryDark,
        secondary: AppColors.accent,
        surface: AppColors.white,
        background: AppColors.background,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'DotGothic16',
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: AppColors.primaryDarker,
        ),
        iconTheme: IconThemeData(color: AppColors.primaryDarker),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Silkscreen',
          fontSize: 40,
          color: AppColors.primaryDarker,
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'DotGothic16',
          fontSize: 24,
          color: AppColors.primaryDarker,
          fontWeight: FontWeight.w400,
        ),
        titleLarge: TextStyle(
          fontFamily: 'DotGothic16',
          fontSize: 20,
          color: AppColors.primaryDarker,
          fontWeight: FontWeight.w400,
        ),
        titleMedium: TextStyle(
          fontFamily: 'DotGothic16',
          fontSize: 16,
          color: AppColors.primaryDarker,
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          color: AppColors.primaryDarker,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: AppColors.primaryDarker,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: AppColors.gray,
          fontWeight: FontWeight.w400,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'DotGothic16',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          side: const BorderSide(color: AppColors.primaryDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'DotGothic16',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          color: AppColors.gray,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.white,
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.primaryDark),
        ),
      ),
      useMaterial3: false,
    );
  }
}

// Text style helpers
class AppTextStyles {
  static const TextStyle display40Silkscreen = TextStyle(
    fontFamily: 'Silkscreen',
    fontSize: 40,
    color: AppColors.primaryDarker,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle headline24DotGothic = TextStyle(
    fontFamily: 'DotGothic16',
    fontSize: 24,
    color: AppColors.primaryDarker,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle title20DotGothic = TextStyle(
    fontFamily: 'DotGothic16',
    fontSize: 20,
    color: AppColors.accent,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle title16DotGothic = TextStyle(
    fontFamily: 'DotGothic16',
    fontSize: 16,
    color: AppColors.primaryDarker,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle body12Inter = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    color: AppColors.primaryDarker,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle body12Gray = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    color: AppColors.gray,
    fontWeight: FontWeight.w400,
  );
}