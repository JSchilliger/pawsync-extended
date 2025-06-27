// This file defines the application's design system, including colors,
// fonts, text styles, and major UI element styles (like button styles).
// All UI elements should reference these definitions rather than using hard-coded values.

import 'package:flutter/material.dart';

// Application Color Palette
// These are placeholder colors. The user will provide the actual color palette.
class AppColors {
  static const Color primary = Color(0xFF6200EE); // Example Primary Color
  static const Color primaryVariant = Color(0xFF3700B3); // Example Darker Primary
  static const Color secondary = Color(0xFF03DAC6); // Example Accent Color
  static const Color secondaryVariant = Color(0xFF018786); // Example Darker Accent
  static const Color background = Color(0xFFFFFFFF); // App Background Color
  static const Color surface = Color(0xFFFFFFFF); // Card/Dialog Backgrounds
  static const Color error = Color(0xFFB00020); // Error Color

  static const Color onPrimary = Color(0xFFFFFFFF); // Text/icon color on Primary background
  static const Color onSecondary = Color(0xFF000000); // Text/icon color on Secondary background
  static const Color onBackground = Color(0xFF000000); // Text/icon color on App Background
  static const Color onSurface = Color(0xFF000000); // Text/icon color on Surface
  static const Color onError = Color(0xFFFFFFFF); // Text/icon color on Error background

  // Neutral/Utility Colors
  static const Color textPrimary = Color(0xFF333333); // Primary text color
  static const Color textSecondary = Color(0xFF757575); // Secondary text color
  static const Color disabled = Color(0xFFBDBDBD); // Disabled state color
  static const Color divider = Color(0xFFE0E0E0); // Divider color
}

// Application Text Styles
// These are placeholder font families and styles.
// The user will provide actual font choices and refined styles.
class AppTextStyles {
  static const String _fontFamilyDefault = 'Roboto'; // Example default font
  static const String _fontFamilyHeading = 'RobotoSlab'; // Example heading font

  // Headline Styles
  static const TextStyle h1 = TextStyle(
    fontFamily: _fontFamilyHeading,
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const TextStyle h2 = TextStyle(
    fontFamily: _fontFamilyHeading,
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const TextStyle h3 = TextStyle(
    fontFamily: _fontFamilyHeading,
    fontSize: 24.0,
    fontWeight: FontWeight.w600, // Semi-bold
    color: AppColors.textPrimary,
  );
  static const TextStyle h4 = TextStyle(
    fontFamily: _fontFamilyHeading,
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body Text Styles
  static const TextStyle bodyL = TextStyle(
    fontFamily: _fontFamilyDefault,
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  static const TextStyle bodyM = TextStyle(
    fontFamily: _fontFamilyDefault,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  static const TextStyle bodyS = TextStyle(
    fontFamily: _fontFamilyDefault,
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Button Text Style
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamilyDefault,
    fontSize: 16.0,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 1.25,
  );

  // Caption Style
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamilyDefault,
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}

// Main Application Theme
// This theme ties together the color palette, text styles, and component themes.
ThemeData getAppThemeData(BuildContext context) {
  return ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.light, // Assuming a light theme by default
    primaryColor: AppColors.primary,
    // primaryColorDark: AppColors.primaryVariant, // For variations of primary color
    // primaryColorLight: AppColors.primary, // Could be a lighter variant if needed
    colorScheme: const ColorScheme(
      primary: AppColors.primary,
      // primaryVariant: AppColors.primaryVariant, // Deprecated, use primaryContainer
      primaryContainer: AppColors.primaryVariant, // Or a lighter shade of primary
      secondary: AppColors.secondary,
      // secondaryVariant: AppColors.secondaryVariant, // Deprecated, use secondaryContainer
      secondaryContainer: AppColors.secondaryVariant, // Or a lighter shade of secondary
      surface: AppColors.surface,
      background: AppColors.background,
      error: AppColors.error,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onSurface: AppColors.onSurface,
      onBackground: AppColors.onBackground,
      onError: AppColors.onError,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.background,

    // Define the default font family.
    fontFamily: AppTextStyles._fontFamilyDefault,

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      displayLarge: AppTextStyles.h1, // Formerly headline1
      displayMedium: AppTextStyles.h2, // Formerly headline2
      displaySmall: AppTextStyles.h3, // Formerly headline3
      headlineMedium: AppTextStyles.h4, // Formerly headline4
      // headlineSmall: // Formerly headline5 (use titleLarge instead or define h5)
      // titleLarge: // Formerly headline6 (use h4 or define h5/h6)

      bodyLarge: AppTextStyles.bodyL, // Formerly bodyText1
      bodyMedium: AppTextStyles.bodyM, // Formerly bodyText2
      bodySmall: AppTextStyles.bodyS, // Formerly caption

      labelLarge: AppTextStyles.button, // For buttons
      // titleMedium: // For subtitles
      // titleSmall: // For smaller subtitles
      // labelSmall: // For smaller labels
    ),

    // Define default ButtonThemes.
    // Note: Newer Flutter versions prefer styling buttons directly via ButtonStyle
    // in ElevatedButton.styleFrom, TextButton.styleFrom, OutlinedButton.styleFrom, etc.
    // However, defining a base ButtonThemeData can still be useful.
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primary,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),

    // Define default ElevatedButton style
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        textStyle: AppTextStyles.button,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),

    // Define default TextButton style
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.button,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),

    // Define default OutlinedButton style
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        textStyle: AppTextStyles.button,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary, // Color for title and icons
      elevation: 4.0,
      titleTextStyle: AppTextStyles.h4, // Or a more specific style like titleLarge
    ),

    // Card theme
    cardTheme: CardTheme(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      color: AppColors.surface,
    ),

    // Input decoration theme for TextFields
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppColors.error, width: 2.0),
      ),
      labelStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
      hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.disabled),
      // filled: true, // Example: if you want filled TextFields
      // fillColor: AppColors.surface.withOpacity(0.5), // Example fillColor
    ),

    // Define other component themes as needed (e.g., dialogTheme, chipTheme, etc.)

    // TODO: Define dark theme if required by the project.
  );
}

// It might also be useful to have a separate dark theme definition
// ThemeData getAppDarkThemeData(BuildContext context) { ... }
