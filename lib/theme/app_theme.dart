import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the voice assistant application.
class AppTheme {
  AppTheme._();

  // Voice Assistant Color Palette - Intelligent Dark Console
  static const Color primaryCyan = Color(0xFF00E5FF);
  static const Color deepCharcoal = Color(0xFF1A1A1A);
  static const Color elevatedSurface = Color(0xFF2D2D2D);
  static const Color trueDarkBackground = Color(0xFF121212);
  static const Color tealAccent = Color(0xFF64FFDA);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color errorRed = Color(0xFFFF5252);
  static const Color warningAmber = Color(0xFFFFC107);
  static const Color successGreen = Color(0xFF4CAF50);

  // Additional semantic colors
  static const Color borderColor = Color(0xFF333333);
  static const Color shadowColor = Color(0x33000000); // 20% opacity black
  static const Color dividerColor = Color(0xFF333333);

  // Text emphasis colors for dark theme
  static const Color textHighEmphasis = Color(0xDEFFFFFF); // 87% opacity
  static const Color textMediumEmphasis = Color(0x99FFFFFF); // 60% opacity
  static const Color textDisabled = Color(0x61FFFFFF); // 38% opacity

  /// Dark theme optimized for voice assistant interface
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryCyan,
      onPrimary: trueDarkBackground,
      primaryContainer: primaryCyan.withAlpha(51),
      onPrimaryContainer: textPrimary,
      secondary: tealAccent,
      onSecondary: trueDarkBackground,
      secondaryContainer: tealAccent.withAlpha(51),
      onSecondaryContainer: textPrimary,
      tertiary: tealAccent,
      onTertiary: trueDarkBackground,
      tertiaryContainer: tealAccent.withAlpha(51),
      onTertiaryContainer: textPrimary,
      error: errorRed,
      onError: textPrimary,
      surface: elevatedSurface,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: borderColor,
      outlineVariant: borderColor.withAlpha(128),
      shadow: shadowColor,
      scrim: shadowColor,
      inverseSurface: textPrimary,
      onInverseSurface: trueDarkBackground,
      inversePrimary: primaryCyan,
    ),
    scaffoldBackgroundColor: trueDarkBackground,
    cardColor: elevatedSurface,
    dividerColor: dividerColor,

    // AppBar theme for voice assistant header
    appBarTheme: AppBarTheme(
      backgroundColor: trueDarkBackground,
      foregroundColor: textPrimary,
      elevation: 0,
      shadowColor: shadowColor,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    ),

    // Card theme for status cards and panels
    cardTheme: CardTheme(
      color: elevatedSurface,
      elevation: 2.0,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),

    // Bottom navigation for voice modes
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: deepCharcoal,
      selectedItemColor: primaryCyan,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
    ),

    // Floating action button for voice activation
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryCyan,
      foregroundColor: trueDarkBackground,
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: trueDarkBackground,
        backgroundColor: primaryCyan,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryCyan,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: primaryCyan, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryCyan,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Typography using Inter font family
    textTheme: _buildTextTheme(),

    // Input decoration for voice settings
    inputDecorationTheme: InputDecorationTheme(
      fillColor: deepCharcoal,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryCyan, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorRed, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabled,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      prefixIconColor: textSecondary,
      suffixIconColor: textSecondary,
    ),

    // Switch theme for voice settings
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryCyan;
        }
        return textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryCyan.withAlpha(77);
        }
        return borderColor;
      }),
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryCyan;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(trueDarkBackground),
      side: const BorderSide(color: borderColor, width: 2),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryCyan;
        }
        return borderColor;
      }),
    ),

    // Progress indicator for voice processing
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryCyan,
      linearTrackColor: borderColor,
      circularTrackColor: borderColor,
    ),

    // Slider theme for voice controls
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryCyan,
      thumbColor: primaryCyan,
      overlayColor: primaryCyan.withAlpha(51),
      inactiveTrackColor: borderColor,
      trackHeight: 4.0,
    ),

    // Tab bar theme for voice modes
    tabBarTheme: TabBarTheme(
      labelColor: primaryCyan,
      unselectedLabelColor: textSecondary,
      indicatorColor: primaryCyan,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Tooltip theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: elevatedSurface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      textStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // SnackBar theme for voice feedback
    snackBarTheme: SnackBarThemeData(
      backgroundColor: elevatedSurface,
      contentTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: primaryCyan,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 6.0,
    ),

    // Bottom sheet theme for contextual panels
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: elevatedSurface,
      modalBackgroundColor: elevatedSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      elevation: 8.0,
    ),

    // Dialog theme
    dialogTheme: DialogTheme(
      backgroundColor: elevatedSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 8.0,
      titleTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),

    // List tile theme
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: primaryCyan.withAlpha(26),
      iconColor: textSecondary,
      textColor: textPrimary,
      titleTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      subtitleTextStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Expansion tile theme
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
      iconColor: textSecondary,
      collapsedIconColor: textSecondary,
      textColor: textPrimary,
      collapsedTextColor: textPrimary,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    ),
  );

  /// Light theme (minimal implementation for fallback)
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryCyan,
      onPrimary: Colors.white,
      primaryContainer: primaryCyan.withAlpha(26),
      onPrimaryContainer: trueDarkBackground,
      secondary: tealAccent,
      onSecondary: Colors.white,
      secondaryContainer: tealAccent.withAlpha(26),
      onSecondaryContainer: trueDarkBackground,
      tertiary: tealAccent,
      onTertiary: Colors.white,
      tertiaryContainer: tealAccent.withAlpha(26),
      onTertiaryContainer: trueDarkBackground,
      error: errorRed,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: trueDarkBackground,
      onSurfaceVariant: Colors.grey[600]!,
      outline: Colors.grey[300]!,
      outlineVariant: Colors.grey[200]!,
      shadow: Colors.black26,
      scrim: Colors.black26,
      inverseSurface: trueDarkBackground,
      onInverseSurface: Colors.white,
      inversePrimary: primaryCyan,
    ),
    textTheme: _buildTextTheme(isLight: true),
  );

  /// Helper method to build text theme using Inter font family
  static TextTheme _buildTextTheme({bool isLight = false}) {
    final Color textColor = isLight ? Colors.black87 : textHighEmphasis;
    final Color textColorMedium = isLight ? Colors.black54 : textMediumEmphasis;
    final Color textColorDisabled = isLight ? Colors.black38 : textDisabled;

    return TextTheme(
      // Display styles for large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),

      // Headline styles for section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),

      // Title styles for cards and dialogs
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),

      // Body text styles
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textColorMedium,
        letterSpacing: 0.4,
      ),

      // Label styles for buttons and captions
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: textColorDisabled,
        letterSpacing: 0.5,
      ),
    );
  }

  /// Data text style using JetBrains Mono for system metrics
  static TextStyle dataTextStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? textPrimary,
      letterSpacing: 0,
    );
  }

  /// Voice waveform animation colors
  static List<Color> get waveformColors => [
        primaryCyan,
        tealAccent,
        primaryCyan.withAlpha(179),
        tealAccent.withAlpha(179),
      ];

  /// Floating action bubble decoration
  static BoxDecoration get floatingBubbleDecoration => BoxDecoration(
        color: elevatedSurface.withAlpha(230),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  /// Glassmorphism effect decoration
  static BoxDecoration get glassmorphismDecoration => BoxDecoration(
        color: elevatedSurface.withAlpha(204),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor.withAlpha(77),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      );
}
