import 'package:flutter/material.dart';

class AppColors {
  static const Color primary            = Color(0xFF00C9A7);
  static const Color primaryDark        = Color(0xFF00A886);
  static const Color primaryLight       = Color(0xFF4DDBBC);
  static const Color bgDark             = Color(0xFF0A0F0D);
  static const Color bgDark2            = Color(0xFF111916);
  static const Color bgDark3            = Color(0xFF1A2420);
  static const Color bgLight            = Color(0xFFF4FAF8);
  static const Color bgLight2           = Color(0xFFEAF5F1);
  static const Color cardDark           = Color(0xFF162220);
  static const Color cardLight          = Color(0xFFFFFFFF);
  static const Color textDarkPrimary    = Color(0xFFE8F5F1);
  static const Color textDarkSecondary  = Color(0xFF8AADA6);
  static const Color textLightPrimary   = Color(0xFF0D1F1A);
  static const Color textLightSecondary = Color(0xFF4A7066);
  static const Color success            = Color(0xFF00C9A7);
  static const Color error              = Color(0xFFFF5C5C);
  static const Color warning            = Color(0xFFFFB347);
  static const Color info               = Color(0xFF4DA6FF);
  static const Color gold               = Color(0xFFFFD700);
  static const Color goldLight          = Color(0xFFFFE566);
  static const Color glassDark          = Color(0x1AFFFFFF);
  static const Color glassLight         = Color(0x80FFFFFF);
  static const Color glassBorder        = Color(0x26FFFFFF);
}

class AppGradients {
  static const LinearGradient primary = LinearGradient(
    colors: [Color(0xFF00C9A7), Color(0xFF00A886)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient darkBg = LinearGradient(
    colors: [Color(0xFF0A0F0D), Color(0xFF111916), Color(0xFF0A0F0D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient card = LinearGradient(
    colors: [Color(0xFF1A2E29), Color(0xFF162220)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient premium = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const RadialGradient glow = RadialGradient(
    colors: [Color(0x3300C9A7), Color(0x0000C9A7)],
    radius: 1.0,
  );
}

class AppTextStyles {
  static const String fontFamily = 'Poppins';
  static const TextStyle display = TextStyle(fontFamily: fontFamily, fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5);
  static const TextStyle headline1 = TextStyle(fontFamily: fontFamily, fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.3);
  static const TextStyle headline2 = TextStyle(fontFamily: fontFamily, fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.2);
  static const TextStyle headline3 = TextStyle(fontFamily: fontFamily, fontSize: 18, fontWeight: FontWeight.w600);
  static const TextStyle body1 = TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);
  static const TextStyle body2 = TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w400, height: 1.5);
  static const TextStyle caption = TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w400);
  static const TextStyle button = TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.3);
  static const TextStyle label = TextStyle(fontFamily: fontFamily, fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5);
}

class AppRadius {
  static const double xs   = 6.0;
  static const double sm   = 10.0;
  static const double md   = 14.0;
  static const double lg   = 20.0;
  static const double xl   = 28.0;
  static const double xxl  = 40.0;
  static const double full = 100.0;
}

class AppSpacing {
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;
}

class AppShadows {
  static List<BoxShadow> card = [
    BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
  ];
  static List<BoxShadow> glow = [
    BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 24, spreadRadius: 2),
  ];
  static List<BoxShadow> button = [
    BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 6)),
  ];
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: AppTextStyles.fontFamily,
    scaffoldBackgroundColor: AppColors.bgDark,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      surface: AppColors.cardDark,
      error: AppColors.error,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: AppColors.textDarkPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontFamily: AppTextStyles.fontFamily, fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDarkPrimary),
      iconTheme: IconThemeData(color: AppColors.textDarkPrimary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
        textStyle: AppTextStyles.button,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardDark,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: const BorderSide(color: AppColors.glassBorder, width: 1)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: const BorderSide(color: AppColors.error, width: 1)),
      hintStyle: AppTextStyles.body2.copyWith(color: AppColors.textDarkSecondary),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.bgDark2,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textDarkSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.glassBorder, thickness: 1),
    iconTheme: const IconThemeData(color: AppColors.textDarkSecondary, size: 22),
    textTheme: TextTheme(
      displayLarge:   AppTextStyles.display.copyWith(color: AppColors.textDarkPrimary),
      headlineLarge:  AppTextStyles.headline1.copyWith(color: AppColors.textDarkPrimary),
      headlineMedium: AppTextStyles.headline2.copyWith(color: AppColors.textDarkPrimary),
      headlineSmall:  AppTextStyles.headline3.copyWith(color: AppColors.textDarkPrimary),
      bodyLarge:      AppTextStyles.body1.copyWith(color: AppColors.textDarkPrimary),
      bodyMedium:     AppTextStyles.body2.copyWith(color: AppColors.textDarkSecondary),
      labelLarge:     AppTextStyles.button.copyWith(color: AppColors.textDarkPrimary),
      labelSmall:     AppTextStyles.label.copyWith(color: AppColors.textDarkSecondary),
      bodySmall:      AppTextStyles.caption.copyWith(color: AppColors.textDarkSecondary),
    ),
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: AppTextStyles.fontFamily,
    scaffoldBackgroundColor: AppColors.bgLight,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryDark,
      surface: AppColors.cardLight,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textLightPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontFamily: AppTextStyles.fontFamily, fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textLightPrimary),
      iconTheme: IconThemeData(color: AppColors.textLightPrimary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardLight,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
        textStyle: AppTextStyles.button,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgLight2,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: const BorderSide(color: Color(0xFFDDEDE8), width: 1)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: const BorderSide(color: AppColors.error, width: 1)),
      hintStyle: AppTextStyles.body2.copyWith(color: AppColors.textLightSecondary),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardLight,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textLightSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFFDDEDE8), thickness: 1),
    iconTheme: const IconThemeData(color: AppColors.textLightSecondary, size: 22),
    textTheme: TextTheme(
      displayLarge:   AppTextStyles.display.copyWith(color: AppColors.textLightPrimary),
      headlineLarge:  AppTextStyles.headline1.copyWith(color: AppColors.textLightPrimary),
      headlineMedium: AppTextStyles.headline2.copyWith(color: AppColors.textLightPrimary),
      headlineSmall:  AppTextStyles.headline3.copyWith(color: AppColors.textLightPrimary),
      bodyLarge:      AppTextStyles.body1.copyWith(color: AppColors.textLightPrimary),
      bodyMedium:     AppTextStyles.body2.copyWith(color: AppColors.textLightSecondary),
      labelLarge:     AppTextStyles.button.copyWith(color: AppColors.textLightPrimary),
      labelSmall:     AppTextStyles.label.copyWith(color: AppColors.textLightSecondary),
      bodySmall:      AppTextStyles.caption.copyWith(color: AppColors.textLightSecondary),
    ),
  );
}
