// This file defines the application's design system, including colors,
// fonts, text styles, and major UI element styles (like button styles).
// All UI elements should reference these definitions rather than using hard-coded values.

import 'package:flutter/material.dart';

// Application Color Palette (Pastel Focus with Pop Highlights)
class AppColors {
  // Base Palette (Pastel Tones)
  static const Color primary = Color(0xFF7986CB);       // Indigo 300 (Muted Blue/Lavender)
  static const Color primaryVariant = Color(0xFF3F51B5);  // Indigo 500 (Darker Primary)
  static const Color onPrimary = Color(0xFFFFFFFF);       // White

  static const Color secondary = Color(0xFF4DB6AC);      // Teal 300 (Softer Teal)
  static const Color secondaryVariant = Color(0xFF00897B); // Teal 600 (Darker Secondary)
  static const Color onSecondary = Color(0xFF000000);     // Black (for contrast on lighter Teal 300)

  static const Color background = Color(0xFFFAFAFA);     // Grey 50 (Very light, almost white, but softer)
  static const Color onBackground = Color(0xFF424242);    // Grey 800 (Dark text on light background)

  static const Color surface = Color(0xFFFFFFFF);        // White (For cards, dialogs to stand out)
  static const Color onSurface = Color(0xFF424242);      // Grey 800 (Dark text on white surface)

  static const Color surfaceVariant = Color(0xFFF0F0F0);  // Grey 100 alt / Off-white (Subtle distinctions)
  // onSurfaceVariant would typically be a dark color like onSurface or textPrimary

  // Semantic Colors (Softer but Clear)
  static const Color error = Color(0xFFE57373);          // Red 300
  static const Color onError = Color(0xFFFFFFFF);         // White text on error color

  static const Color success = Color(0xFF81C784);        // Green 300
  static const Color onSuccess = Color(0xFFFFFFFF);       // White or dark green text

  static const Color warning = Color(0xFFFFB74D);        // Orange 300
  static const Color onWarning = Color(0xFF000000);       // Dark text on warning

  static const Color info = Color(0xFF64B5F6);           // Blue 300
  static const Color onInfo = Color(0xFFFFFFFF);          // White text on info

  // Highlight Color (For "Pop" elements, used sparingly)
  static const Color highlight = Color(0xFF00ACC1);      // Cyan 600 (Vibrant Cyan)
  static const Color onHighlight = Color(0xFFFFFFFF);    // White

  // Neutral/Utility Colors
  static const Color textPrimary = Color(0xFF424242);    // Grey 800 (Same as onBackground/onSurface)
  static const Color textSecondary = Color(0xFF757575);  // Grey 600
  static const Color disabled = Color(0xFFBDBDBD);        // Grey 400
  static const Color divider = Color(0xFFE0E0E0);          // Grey 300

  // Additional Neutrals if needed
  static const Color greyLight = Color(0xFFF5F5F5);      // Grey 100
  static const Color greyMedium = Color(0xFF9E9E9E);     // Grey 500
  static const Color greyDark = Color(0xFF616161);        // Grey 700
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
  static const TextStyle h4 = TextStyle( // Often maps to titleLarge
    fontFamily: _fontFamilyHeading,
    fontSize: 20.0,
    fontWeight: FontWeight.w600, // Material titleLarge is often FontWeight.normal or medium
    color: AppColors.textPrimary,
  );
  // Adding h5 and h6 for more granularity if needed, or for mapping to titleMedium/Small
  static const TextStyle h5 = TextStyle( // Can map to titleMedium
    fontFamily: _fontFamilyHeading,
    fontSize: 18.0, // Example size
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle h6 = TextStyle( // Can map to titleSmall
    fontFamily: _fontFamilyDefault, // Switching to default font for smaller titles
    fontSize: 16.0, // Example size
    fontWeight: FontWeight.w500, // Medium weight
    color: AppColors.textPrimary,
  );


  // Title styles (closer to Material Design naming)
  // These can reuse h4, h5, h6 or be distinct
  static final TextStyle titleLarge = h4.copyWith(fontFamily: _fontFamilyDefault, fontWeight: FontWeight.w500, color: AppColors.textPrimary); // Example: Roboto, 20, Medium
  static final TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamilyDefault,
    fontSize: 16.0,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );
  static final TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamilyDefault,
    fontSize: 14.0,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.1,
    color: AppColors.textSecondary, // Often a bit more muted
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
    primaryColor: AppColors.primary, // Still useful for some older widgets
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryVariant, // Using variant as container for now
      onPrimaryContainer: AppColors.onPrimary, // Text on primary container

      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryVariant, // Using variant as container for now
      onSecondaryContainer: AppColors.onSecondary, // Text on secondary container

      tertiary: AppColors.highlight, // Using highlight as a tertiary color
      onTertiary: AppColors.onHighlight,
      // tertiaryContainer: AppColors.highlight.withOpacity(0.2), // Example
      // onTertiaryContainer: AppColors.onHighlight,


      error: AppColors.error,
      onError: AppColors.onError,
      // errorContainer: AppColors.error.withOpacity(0.1),
      // onErrorContainer: AppColors.error,

      background: AppColors.background,
      onBackground: AppColors.onBackground,

      surface: AppColors.surface,
      onSurface: AppColors.onSurface,

      surfaceVariant: AppColors.surfaceVariant, // Added in Material 3
      onSurfaceVariant: AppColors.onSurface, // Text on surfaceVariant

      // outline: AppColors.divider, // For borders on components
      // outlineVariant: AppColors.greyMedium,
      // shadow: Colors.black.withOpacity(0.1),
      // scrim: Colors.black.withOpacity(0.3),
      // inverseSurface: AppColors.textPrimary,
      // onInverseSurface: AppColors.surface,
      // inversePrimary: AppColors.onPrimary,
      // surfaceTint: AppColors.primary, // Color used to tint surfaces based on elevation
    ),
    scaffoldBackgroundColor: AppColors.background,

    // Define the default font family.
    fontFamily: AppTextStyles._fontFamilyDefault,

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      // Headline styles
      displayLarge: AppTextStyles.h1,    // Material: headline1
      displayMedium: AppTextStyles.h2,   // Material: headline2
      displaySmall: AppTextStyles.h3,    // Material: headline3
      headlineMedium: AppTextStyles.h4,  // Material: headline4 (can also be used for titleLarge if font matches)
      headlineSmall: AppTextStyles.h5,   // Material: headline5

      // Title styles
      titleLarge: AppTextStyles.titleLarge,   // Material: headline6 / titleLarge
      titleMedium: AppTextStyles.titleMedium, // Material: subtitle1
      titleSmall: AppTextStyles.titleSmall,   // Material: subtitle2

      // Body text styles
      bodyLarge: AppTextStyles.bodyL,     // Material: bodyText1
      bodyMedium: AppTextStyles.bodyM,    // Material: bodyText2 / Default body style
      bodySmall: AppTextStyles.bodyS,     // Material: caption

      // Label styles (often for buttons and other specific UI elements)
      labelLarge: AppTextStyles.button,   // Material: button
      labelMedium: AppTextStyles.button.copyWith(fontSize: 14.0, letterSpacing: 0.1), // Example for smaller buttons or emphasis
      labelSmall: AppTextStyles.caption.copyWith(letterSpacing: 0.5), // Material: overline (often all caps)
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
    appBarTheme: AppBarTheme( // Use new colors
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: 4.0,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.onPrimary), // Ensure onPrimary color
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
      labelStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary), // Existing, seems fine
      hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.disabled), // Existing, seems fine
      // filled: true,
      // fillColor: AppColors.surfaceVariant.withOpacity(0.5), // Example using new surfaceVariant
    ),

    // Define other component themes as needed (e.g., dialogTheme, chipTheme, etc.)
    // Example: Dialog Theme
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.surface,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary),
      contentTextStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ),

    // Example: Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceVariant,
      disabledColor: AppColors.disabled.withOpacity(0.3),
      selectedColor: AppColors.secondary.withOpacity(0.8),
      secondarySelectedColor: AppColors.secondary, // For checkmark, etc.
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      labelStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textPrimary), // Text color for unselected chip
      secondaryLabelStyle: AppTextStyles.bodyM.copyWith(color: AppColors.onSecondary), // Text color for selected chip
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      side: BorderSide.none, // Or BorderSide(color: AppColors.divider) for outlined chips
    ),

    // TODO: Define dark theme if required by the project.
  );
}

// It might also be useful to have a separate dark theme definition
// ThemeData getAppDarkThemeData(BuildContext context) { ... }
