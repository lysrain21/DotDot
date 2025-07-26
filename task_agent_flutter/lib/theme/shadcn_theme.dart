import 'package:flutter/material.dart';

// shadcn/ui color system based on HSL values from globals.css
class ShadcnColors {
  // UI.css color scheme based on provided design
  static const Color background = Color(0xFFF3F3F3); // Light gray background from UI.css
  static const Color foreground = Color(0xFF2D2D2D); // Dark text color
  static const Color card = Color(0xFFFFFFFF); // White cards
  static const Color cardForeground = Color(0xFF2D2D2D); // Dark text on cards
  static const Color popover = Color(0xFFFFFFFF);
  static const Color popoverForeground = Color(0xFF2D2D2D);
  static const Color primary = Color(0xFFCFFF0B); // Lime green from UI.css
  static const Color primaryForeground = Color(0xFF3B3B3B); // Dark text on lime green
  static const Color secondary = Color(0xFF3B3B3B); // Dark gray from UI.css
  static const Color secondaryForeground = Color(0xFFFFFFFF); // White text on dark gray
  static const Color muted = Color(0xFFF5F5F5);
  static const Color mutedForeground = Color(0xFF999999); // Gray text from UI.css
  static const Color accent = Color(0xFFCFFF0B);
  static const Color accentForeground = Color(0xFF3B3B3B);
  static const Color destructive = Color(0xFF646464); // Dark gray from UI.css
  static const Color destructiveForeground = Color(0xFFFFFFFF);
  static const Color border = Color(0xFF3B3B3B); // Dark border from UI.css
  static const Color input = Color(0xFFFFFFFF);
  static const Color ring = Color(0xFFCFFF0B); // Lime green focus ring

  // Dark theme colors
  static const Color darkBackground = Color(0xFF2D2D2D);
  static const Color darkForeground = Color(0xFFFAFAFA);
  static const Color darkCard = Color(0xFF3B3B3B);
  static const Color darkCardForeground = Color(0xFFFAFAFA);
  static const Color darkPopover = Color(0xFF3B3B3B);
  static const Color darkPopoverForeground = Color(0xFFFAFAFA);
  static const Color darkPrimary = Color(0xFFCFFF0B);
  static const Color darkPrimaryForeground = Color(0xFF3B3B3B);
  static const Color darkSecondary = Color(0xFF646464);
  static const Color darkSecondaryForeground = Color(0xFFFFFFFF);
  static const Color darkMuted = Color(0xFF3B3B3B);
  static const Color darkMutedForeground = Color(0xFF999999);
  static const Color darkAccent = Color(0xFFCFFF0B);
  static const Color darkAccentForeground = Color(0xFF3B3B3B);
  static const Color darkDestructive = Color(0xFF646464);
  static const Color darkDestructiveForeground = Color(0xFFFFFFFF);
  static const Color darkBorder = Color(0xFF3B3B3B);
  static const Color darkInput = Color(0xFF3B3B3B);
  static const Color darkRing = Color(0xFFCFFF0B);
}

class ShadcnTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: ShadcnColors.background,
      primaryColor: ShadcnColors.primary,
      colorScheme: const ColorScheme.light(
        primary: ShadcnColors.primary,
        secondary: ShadcnColors.secondary,
        surface: ShadcnColors.card,
        background: ShadcnColors.background,
        error: ShadcnColors.destructive,
        onPrimary: ShadcnColors.primaryForeground,
        onSecondary: ShadcnColors.secondaryForeground,
        onSurface: ShadcnColors.foreground,
        onBackground: ShadcnColors.foreground,
        onError: ShadcnColors.destructiveForeground,
      ),
      cardTheme: CardThemeData(
        color: ShadcnColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: ShadcnColors.border),
        ),
        margin: const EdgeInsets.all(0),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ShadcnColors.background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ShadcnColors.foreground,
        ),
        iconTheme: IconThemeData(color: ShadcnColors.foreground),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ShadcnColors.primary,
          foregroundColor: ShadcnColors.primaryForeground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ShadcnColors.foreground,
          side: const BorderSide(color: ShadcnColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ShadcnColors.foreground,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ShadcnColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ShadcnColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ShadcnColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ShadcnColors.ring, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ShadcnColors.destructive),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(
          color: ShadcnColors.mutedForeground,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: ShadcnColors.foreground,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: ShadcnColors.foreground,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: ShadcnColors.foreground,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: ShadcnColors.foreground,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ShadcnColors.foreground,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ShadcnColors.foreground,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ShadcnColors.foreground,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ShadcnColors.foreground,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: ShadcnColors.foreground,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ShadcnColors.foreground,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ShadcnColors.foreground,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: ShadcnColors.mutedForeground,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ShadcnColors.primary,
        foregroundColor: ShadcnColors.primaryForeground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: ShadcnColors.border,
        thickness: 1,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: ShadcnColors.darkBackground,
      primaryColor: ShadcnColors.darkPrimary,
      colorScheme: const ColorScheme.dark(
        primary: ShadcnColors.darkPrimary,
        secondary: ShadcnColors.darkSecondary,
        surface: ShadcnColors.darkCard,
        background: ShadcnColors.darkBackground,
        error: ShadcnColors.darkDestructive,
        onPrimary: ShadcnColors.darkPrimaryForeground,
        onSecondary: ShadcnColors.darkSecondaryForeground,
        onSurface: ShadcnColors.darkForeground,
        onBackground: ShadcnColors.darkForeground,
        onError: ShadcnColors.darkDestructiveForeground,
      ),
      cardTheme: CardThemeData(
        color: ShadcnColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: ShadcnColors.darkBorder),
        ),
        margin: const EdgeInsets.all(0),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ShadcnColors.darkBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ShadcnColors.darkForeground,
        ),
        iconTheme: IconThemeData(color: ShadcnColors.darkForeground),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ShadcnColors.darkPrimary,
          foregroundColor: ShadcnColors.darkPrimaryForeground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ShadcnColors.darkForeground,
          side: const BorderSide(color: ShadcnColors.darkBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ShadcnColors.darkForeground,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ShadcnColors.darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ShadcnColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ShadcnColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ShadcnColors.darkRing, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ShadcnColors.darkDestructive),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(
          color: ShadcnColors.darkMutedForeground,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: ShadcnColors.darkForeground,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: ShadcnColors.darkForeground,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: ShadcnColors.darkForeground,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: ShadcnColors.darkForeground,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ShadcnColors.darkForeground,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ShadcnColors.darkForeground,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ShadcnColors.darkForeground,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ShadcnColors.darkForeground,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: ShadcnColors.darkForeground,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ShadcnColors.darkForeground,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ShadcnColors.darkForeground,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: ShadcnColors.darkMutedForeground,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ShadcnColors.darkPrimary,
        foregroundColor: ShadcnColors.darkPrimaryForeground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: ShadcnColors.darkBorder,
        thickness: 1,
      ),
      useMaterial3: true,
    );
  }
}

// shadcn/ui component styles
class ShadcnTextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.025,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.025,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.025,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.025,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.025,
  );

  static const TextStyle h6 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.025,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}

// shadcn/ui spacing system
class ShadcnSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}