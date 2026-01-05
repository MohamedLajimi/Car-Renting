import 'package:flutter/material.dart';
import 'app_palette.dart';

class AppTheme {
  static OutlineInputBorder _border([Color color = AppPalette.border]) =>
      OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      );

  static ThemeData appTheme = ThemeData(
    fontFamily: 'SpaceGrotesk',
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppPalette.background,
    primaryColor: AppPalette.primary,
    dividerColor: AppPalette.border,

    colorScheme: const ColorScheme.dark(
      primary: AppPalette.primary,
      surface: AppPalette.card,
      error: AppPalette.error,
      onSurface: AppPalette.primaryText,
      onSurfaceVariant: AppPalette.secondaryText,
    ),

    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (BuildContext context) =>
          const Icon(Icons.keyboard_arrow_left, size: 30),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppPalette.primaryText,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppPalette.primaryText,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppPalette.primaryText,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppPalette.primaryText,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: AppPalette.secondaryText,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppPalette.primaryText,
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'SpaceGrotesk',
        color: AppPalette.primaryText,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: AppPalette.primaryText),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: CircleBorder(),
    ),

    dividerTheme: DividerThemeData(
      color: AppPalette.secondaryText,
      thickness: 0.4,
    ),

    inputDecorationTheme: InputDecorationTheme(
      errorMaxLines: 5,
      filled: true,
      fillColor: AppPalette.card,
      contentPadding: const EdgeInsets.all(18),
      enabledBorder: _border(),
      focusedBorder: _border(AppPalette.primary),
      errorBorder: _border(AppPalette.error),
      focusedErrorBorder: _border(AppPalette.error),
      hintStyle: const TextStyle(color: AppPalette.secondaryText, fontSize: 14),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPalette.primary,
        foregroundColor: AppPalette.primaryText,
        elevation: 0,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    chipTheme: const ChipThemeData(
      backgroundColor: AppPalette.card,
      side: BorderSide(color: AppPalette.border),
      labelStyle: TextStyle(color: AppPalette.primaryText),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: StadiumBorder(),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppPalette.background,
      selectedItemColor: AppPalette.primary,
      unselectedItemColor: AppPalette.secondaryText,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppPalette.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppPalette.card,
      modalBackgroundColor: AppPalette.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),

    cardTheme: CardThemeData(
      color: AppPalette.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppPalette.border),
      ),
    ),
  );
}
