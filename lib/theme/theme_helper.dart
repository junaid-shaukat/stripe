import 'package:flutter/material.dart';

import '/core/app_export.dart';

ColorCodes get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.
// ignore_for_file: must_be_immutable
class ThemeHelper {
  // The current app theme
  final _appTheme = 'light';

  // A map of custom color themes supported by the app
  final Map<String, ColorCodes> _supportedCustomColor = {'light': ColorCodes()};

  // A map of color schemes supported by the app
  final Map<String, ColorScheme> _supportedColorScheme = {
    'light': ColorSchemes.light,
  };

  /// Changes the app theme to [newTheme].
  void changeTheme(String newTheme) {
    Get.forceAppUpdate();
  }

  /// Returns the light colors for the current theme.
  ColorCodes _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? ColorCodes();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme = _supportedColorScheme[_appTheme] ?? ColorSchemes.light;

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      visualDensity: VisualDensity.standard,
      scaffoldBackgroundColor: appTheme.surface,
      splashFactory: InkSparkle.splashFactory,
      textTheme: TextThemes.textTheme(colorScheme),
      appBarTheme: AppBarTheme(
        backgroundColor: appTheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextThemes.textTheme(colorScheme).headlineSmall,
        iconTheme: IconThemeData(color: appTheme.onSurface, size: 24.h),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: appTheme.surfaceContainerHighest,
          disabledForegroundColor: appTheme.textMuted,
          textStyle: TextThemes.textTheme(colorScheme).labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Rounded.xl),
          ),
          elevation: 0,
          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
          padding: EdgeInsetsDirectional.zero,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.secondary,
          side: BorderSide(color: appTheme.border, width: 1.5.h),
          textStyle: TextThemes.textTheme(colorScheme).labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Rounded.xl),
          ),
          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
          padding: EdgeInsetsDirectional.zero,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.secondary,
          textStyle: TextThemes.textTheme(colorScheme).labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Rounded.md),
          ),
          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: appTheme.surfaceContainerHigh,
        selectedColor: colorScheme.primaryContainer,
        disabledColor: appTheme.surfaceContainer,
        labelStyle: TextThemes.textTheme(colorScheme).labelMedium
            ?.copyWith(color: appTheme.textSecondary),
        secondaryLabelStyle: TextThemes.textTheme(colorScheme).labelMedium
            ?.copyWith(color: colorScheme.onPrimary),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: const StadiumBorder(),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.primary;
          }
          return appTheme.borderStrong;
        }),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        side: BorderSide(color: appTheme.borderStrong, width: 2.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        checkColor: WidgetStateProperty.all(Colors.white),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        shape: const StadiumBorder(),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: appTheme.surfaceContainerLowest,
        modalBackgroundColor: appTheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Rounded.xxl),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: appTheme.border,
      ),
    );
  }

  /// Returns the light colors for the current theme.
  ColorCodes themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
    // ---------------------------------------------------------------- Display
    displayLarge: TextStyle(
      color: appTheme.onSurface,
      fontFamily: 'PlusJakartaSans',
      fontSize: 40.fSize,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.03,
      height: 48 / 40,
    ),
    displayMedium: TextStyle(
      color: appTheme.onSurface,
      fontFamily: 'PlusJakartaSans',
      fontSize: 32.fSize,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.02,
      height: 40 / 32,
    ),

    // --------------------------------------------------------------- Headline
    headlineLarge: TextStyle(
      color: appTheme.onSurface,
      fontFamily: 'PlusJakartaSans',
      fontSize: 26.fSize,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.02,
      height: 34 / 26,
    ),
    headlineMedium: TextStyle(
      color: appTheme.onSurface,
      fontFamily: 'PlusJakartaSans',
      fontSize: 22.fSize,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.01,
      height: 28 / 22,
    ),
    headlineSmall: TextStyle(
      color: appTheme.onSurface,
      fontFamily: 'PlusJakartaSans',
      fontSize: 18.fSize,
      fontWeight: FontWeight.w600,
      height: 24 / 18,
    ),

    // ------------------------------------------------------------------ Title
    titleLarge: TextStyle(
      color: appTheme.onSurface,
      fontFamily: 'PlusJakartaSans',
      fontSize: 15.fSize,
      fontWeight: FontWeight.w600,
      height: 20 / 15,
    ),
    titleMedium: TextStyle(
      color: appTheme.onSurface,
      fontFamily: 'PlusJakartaSans',
      fontSize: 13.fSize,
      fontWeight: FontWeight.w600,
      height: 16 / 13,
    ),
    titleSmall: TextStyle(
      color: appTheme.textSecondary,
      fontFamily: 'PlusJakartaSans',
      fontSize: 11.fSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.02,
      height: 14 / 11,
    ),

    // ------------------------------------------------------------------- Body
    bodyLarge: TextStyle(
      color: appTheme.onSurfaceVariant,
      fontFamily: 'Inter',
      fontSize: 16.fSize,
      fontWeight: FontWeight.w400,
      height: 24 / 16,
    ),
    bodyMedium: TextStyle(
      color: appTheme.onSurfaceVariant,
      fontFamily: 'Inter',
      fontSize: 14.fSize,
      fontWeight: FontWeight.w400,
      height: 20 / 14,
    ),
    bodySmall: TextStyle(
      color: appTheme.textMuted,
      fontFamily: 'Inter',
      fontSize: 12.fSize,
      fontWeight: FontWeight.w400,
      height: 16 / 12,
    ),

    // ------------------------------------------------------------------ Label
    labelLarge: TextStyle(
      color: appTheme.onSurface,
      fontFamily: 'PlusJakartaSans',
      fontSize: 15.fSize,
      fontWeight: FontWeight.w600,
      height: 20 / 15,
    ),
    labelMedium: TextStyle(
      color: appTheme.onSurfaceVariant,
      fontFamily: 'PlusJakartaSans',
      fontSize: 13.fSize,
      fontWeight: FontWeight.w600,
      height: 16 / 13,
    ),
    labelSmall: TextStyle(
      color: appTheme.textMuted,
      fontFamily: 'PlusJakartaSans',
      fontSize: 11.fSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.02,
      height: 14 / 11,
    ),
  );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static ColorScheme light = ColorScheme.light(
    primary: Color(0XFFB90055),
    onPrimary: Color(0XFFFFFFFF),
    primaryContainer: Color(0XFFE11D6D),
    onPrimaryContainer: Color(0XFFFFFEFF),
    inversePrimary: Color(0XFFFFB1C2),

    secondary: Color(0XFF3D4DCD),
    onSecondary: Color(0XFFFFFFFF),
    secondaryContainer: Color(0XFF5767E8),
    onSecondaryContainer: Color(0XFFFFFBFF),

    tertiary: Color(0XFF4856AD),
    onTertiary: Color(0XFFFFFFFF),
    tertiaryContainer: Color(0XFF616FC8),
    onTertiaryContainer: Color(0XFFFFFFFF),

    error: Color(0XFFBA1A1A),
    onError: Color(0XFFFFFFFF),
    errorContainer: Color(0XFFFFDAD6),
    onErrorContainer: Color(0XFF93000A),

    surface: Color(0XFFFAF8FF),
    onSurface: Color(0XFF131B2E),
    onSurfaceVariant: Color(0XFF5A3F45),
    inverseSurface: Color(0XFF283044),
    onInverseSurface: Color(0XFFEEF0FF),

    outline: Color(0XFF8E6F75),
    outlineVariant: Color(0XFFE2BDC4),
    surfaceTint: Color(0XFFBB0057),
  );
}

/// Predefined gradient styles.
class Gradients {
  /// Signature 135° magenta → violet → indigo gradient.
  /// Used for primary CTAs, audio waveforms and language switchers.
  static const signature = <Color>[
    Color(0xFFE11D6D),
    Color(0xFF8B2BE2),
    Color(0xFF3B4BCC),
  ];

  /// Short two-stop variant for compact CTAs.
  static const primaryAction = <Color>[Color(0xFFE11D6D), Color(0xFF3B4BCC)];

  /// Voice / recording orb gradient.
  static const orb = <Color>[
    Color(0xFFFF4D8D),
    Color(0xFFE11D6D),
    Color(0xFF3B4BCC),
  ];

  static const warm = <Color>[
    Color(0xFFFFD9E0),
    Color(0xFFE11D6D),
    Color(0xFF8F0041),
  ];

  static const cool = <Color>[
    Color(0xFFDFE0FF),
    Color(0xFF3D4DCD),
    Color(0xFF000A63),
  ];

  /// Convenience [LinearGradient] for the signature CTA.
  static const LinearGradient signatureLinear = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: signature,
  );

  static const LinearGradient primaryActionLinear = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: primaryAction,
  );

  /// AINTIS emblem — magenta swirl gradient (viewbox 240x240).
  static const LinearGradient emblemPinkLinear = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF43F5E), Color(0xFFE11D6D), Color(0xFF9D174D)],
  );

  /// AINTIS emblem — deep navy swirl gradient.
  static const LinearGradient emblemNavyLinear = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A8A), Color(0xFF0F172A), Color(0xFF020617)],
  );

  /// AINTIS emblem — dual magenta → indigo blend gradient.
  static const LinearGradient emblemBlendLinear = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE11D6D), Color(0xFF831843), Color(0xFF0F172A)],
  );

  /// AINTIS splash spinner arc gradient.
  static const SweepGradient emblemSpinnerSweep = SweepGradient(
    startAngle: 0,
    endAngle: 6.283185307179587,
    colors: [Color(0xFFE83687), Color(0x00000000)],
  );

  /// Ambient background glow behind the splash emblem.
  static const RadialGradient splashAmbient = RadialGradient(
    center: Alignment(0, -0.22),
    radius: 0.78,
    colors: [
      Color(0x47F472B6), // 28% f472b6
      Color(0x1FDB2777), // 12% db2777
      Color(0x4DF1F5F9), // 30% f1f5f9
      Color(0x00F1F5F9), // transparent
    ],
    stops: [0.0, 0.28, 0.55, 0.75],
  );
}

/// Class containing elevation / ambient shadow presets.
class AppShadows {
  /// Level 1 — floating white content cards.
  static List<BoxShadow> get card => [
    BoxShadow(color: Color(0x0A0F172A), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(
      color: Color(0x0DE11D6D),
      blurRadius: 25,
      spreadRadius: -5,
      offset: Offset(0, 10),
    ),
    BoxShadow(
      color: Color(0x0D3B4BCC),
      blurRadius: 10,
      spreadRadius: -6,
      offset: Offset(0, 8),
    ),
  ];

  /// Level 2 — primary CTA buttons, bottom sheets, modals.
  static List<BoxShadow> get cta => [
    BoxShadow(
      color: Color(0x59E11D6D),
      blurRadius: 24,
      spreadRadius: -4,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x403B4BCC),
      blurRadius: 12,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
  ];

  /// Level 3 — small floating controls (language swap, chips).
  static List<BoxShadow> get floating => [
    BoxShadow(color: Color(0x140F172A), blurRadius: 12, offset: Offset(0, 4)),
  ];

  /// Focus ring glow for inputs.
  static List<BoxShadow> get focusGlow => [
    BoxShadow(color: Color(0x1F3B4BCC), blurRadius: 0, spreadRadius: 4),
  ];

  /// Splash — circular brand emblem card bloom.
  static List<BoxShadow> get splashBadge => [
    BoxShadow(
      color: Color(0x38DF146E),
      blurRadius: 40,
      spreadRadius: -8,
      offset: Offset(0, 16),
    ),
    BoxShadow(
      color: Color(0x140D224E),
      blurRadius: 24,
      spreadRadius: -6,
      offset: Offset(0, 8),
    ),
  ];

  /// Splash — neon glow for the magenta tagline dot.
  static List<BoxShadow> get glowMagentaDot => [
    BoxShadow(
      color: Color(0xA6DF146E),
      blurRadius: 10,
      spreadRadius: 2,
    ),
  ];

  /// Splash — neon glow for the indigo tagline dot.
  static List<BoxShadow> get glowIndigoDot => [
    BoxShadow(
      color: Color(0x8C0D224E),
      blurRadius: 10,
      spreadRadius: 2,
    ),
  ];
}

/// Reusable input decoration factory matching the design system.
class AppInputs {
  static OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Rounded.lg),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static InputDecoration decoration({
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? helperText,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: appTheme.textMuted,
        fontFamily: 'Inter',
        fontSize: 16.fSize,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      helperText: helperText,
      errorText: errorText,
      filled: true,
      fillColor: appTheme.surfaceContainerLowest,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      helperStyle: TextStyle(color: appTheme.textMuted, fontSize: 12.fSize),
      errorStyle: TextStyle(color: appTheme.error, fontSize: 12.fSize),
      border: _border(appTheme.border, 1.5),
      enabledBorder: _border(appTheme.border, 1.5),
      focusedBorder: _border(appTheme.secondary, 1.5),
      errorBorder: _border(appTheme.error, 1.5),
      focusedErrorBorder: _border(appTheme.error, 1.5),
      disabledBorder: _border(appTheme.border, 1.5),
    );
  }
}

/// Class containing custom colors for a light theme.
class ColorCodes {
  // Surface
  Color get surface => const Color(0XFFFAF8FF);
  Color get surfaceDim => const Color(0XFFD2D9F4);
  Color get surfaceBright => const Color(0XFFFAF8FF);
  Color get surfaceContainerLowest => const Color(0XFFFFFFFF);
  Color get surfaceContainerLow => const Color(0XFFF2F3FF);
  Color get surfaceContainer => const Color(0XFFEAEDFF);
  Color get surfaceContainerHigh => const Color(0XFFE2E7FF);
  Color get surfaceContainerHighest => const Color(0XFFDAE2FD);

  // On Surface
  Color get onSurface => const Color(0XFF131B2E);
  Color get onSurfaceVariant => const Color(0XFF5A3F45);
  Color get inverseSurface => const Color(0XFF283044);
  Color get inverseOnSurface => const Color(0XFFEEF0FF);

  // Outline
  Color get outline => const Color(0XFF8E6F75);
  Color get outlineVariant => const Color(0XFFE2BDC4);
  Color get surfaceTint => const Color(0XFFBB0057);

  // Primary (Rose Magenta)
  Color get primary => const Color(0XFFB90055);
  Color get onPrimary => const Color(0XFFFFFFFF);
  Color get primaryContainer => const Color(0XFFE11D6D);
  Color get onPrimaryContainer => const Color(0XFFFFFEFF);
  Color get inversePrimary => const Color(0XFFFFB1C2);
  Color get primaryDim => const Color(0XFFD81B60);
  Color get gradientMid => const Color(0XFF8B2BE2);

  // Secondary (Royal Indigo)
  Color get secondary => const Color(0XFF3D4DCD);
  Color get onSecondary => const Color(0XFFFFFFFF);
  Color get secondaryContainer => const Color(0XFF5767E8);
  Color get onSecondaryContainer => const Color(0XFFFFFBFF);

  // Tertiary (Deep Navy-Indigo)
  Color get tertiary => const Color(0XFF4856AD);
  Color get onTertiary => const Color(0XFFFFFFFF);
  Color get tertiaryContainer => const Color(0XFF616FC8);
  Color get onTertiaryContainer => const Color(0XFFFFFFFF);

  // Error
  Color get error => const Color(0XFFBA1A1A);
  Color get onError => const Color(0XFFFFFFFF);
  Color get errorContainer => const Color(0XFFFFDAD6);
  Color get onErrorContainer => const Color(0XFF93000A);

  // Primary Fixed
  Color get primaryFixed => const Color(0XFFFFD9E0);
  Color get primaryFixedDim => const Color(0XFFFFB1C2);
  Color get onPrimaryFixed => const Color(0XFF3F0019);
  Color get onPrimaryFixedVariant => const Color(0XFF8F0041);

  // Secondary Fixed
  Color get secondaryFixed => const Color(0XFFDFE0FF);
  Color get secondaryFixedDim => const Color(0XFFBCC2FF);
  Color get onSecondaryFixed => const Color(0XFF000A63);
  Color get onSecondaryFixedVariant => const Color(0XFF2334B8);

  // Tertiary Fixed
  Color get tertiaryFixed => const Color(0XFFDFE0FF);
  Color get tertiaryFixedDim => const Color(0XFFBBC3FF);
  Color get onTertiaryFixed => const Color(0XFF000E5E);
  Color get onTertiaryFixedVariant => const Color(0XFF303E95);

  // Background
  Color get background => const Color(0XFFFAF8FF);
  Color get onBackground => const Color(0XFF131B2E);

  // Surface Variant
  Color get surfaceVariant => const Color(0XFFDAE2FD);

  // Canvas (page gradient + ambient glow accents)
  Color get canvasTop => const Color(0XFFF8FAFC);
  Color get canvasBottom => const Color(0XFFF1F5F9);
  Color get glowPrimary => const Color(0X14E11D6D); // 8% magenta
  Color get glowSecondary => const Color(0X143B4BCC); // 8% indigo

  // Borders
  Color get border => const Color(0XFFE2E8F0);
  Color get borderStrong => const Color(0XFFCBD5E1);

  // Text
  Color get textPrimary => const Color(0XFF0F172A);
  Color get textSecondary => const Color(0XFF475569);
  Color get textMuted => const Color(0XFF94A3B8);

  // Glass / HUD
  Color get glassFill => const Color(0XD9FFFFFF); // 85% white
  Color get glassBorder => const Color(0X33FFFFFF);

  // AINTIS brand palette (splash / brand emblem)
  Color get aintisMagenta => const Color(0XFFDF146E);
  Color get aintisPurple => const Color(0XFFB71775);
  Color get aintisNavy => const Color(0XFF0D224E);
  Color get aintisDeepNavy => const Color(0XFF06132F);
  Color get aintisText => const Color(0XFFD61B6F);

  // AINTIS emblem gradient stops
  Color get emblemPinkLight => const Color(0XFFF43F5E);
  Color get emblemPinkMid => const Color(0XFFE11D6D);
  Color get emblemPinkDark => const Color(0XFF9D174D);
  Color get emblemNavyLight => const Color(0XFF1E3A8A);
  Color get emblemNavyMid => const Color(0XFF0F172A);
  Color get emblemNavyDark => const Color(0XFF020617);
  Color get emblemBlendMid => const Color(0XFF831843);
  Color get dotIndigo => const Color(0XFF1E2A5E);
  Color get loaderArc => const Color(0XFFE83687);

  // AINTIS ambient / glow accents
  Color get ambientGlowCore => const Color(0X47F472B6); // 28% f472b6
  Color get ambientGlowMid => const Color(0X1FDB2777); // 12% db2777
  Color get ambientGlowSoft => const Color(0X4DF1F5F9); // 30% f1f5f9
  Color get glowMagenta => const Color(0XA6DF146E); // 65% df146e
  Color get glowIndigo => const Color(0X8C0D224E); // 55% 0d224e
  Color get badgeShadowMagenta => const Color(0X38DF146E); // 22% df146e
  Color get badgeShadowNavy => const Color(0X140D224E); // 8% 0d224e

  // System chrome (status / navigation bar)
  Color get statusBarText => const Color(0XFF555E6D);
  Color get statusBarTime => const Color(0XFF374151);
  Color get systemNavBar => const Color(0XFF000000);
  Color get systemNavIcon => const Color(0XFFA3A3A3);

  // Splash surfaces
  Color get splashSurface => const Color(0XFFF8FAFC);
  Color get splashFrameBorder => const Color(0X6666A3B4);

  // Utility colors
  Color get success => const Color(0XFF34A853);
  Color get warning => const Color(0XFFFFA44A);
  Color get info => const Color(0XFF0DCAF0);
  Color get tertiaryWash => const Color(0XFFF4F7F6);

  // Transparent
  Color get transparent => Colors.transparent;

  // Shadow
  Color get shadow => const Color(0XFF000000);

  // Opacity
  Color get opacity => const Color(0XFF000000);

  // Disabled
  Color get disabled => const Color(0XFF94A3B8);

  // Base palette
  Color get red => const Color(0xFFDC3545);
  Color get blue => const Color(0xFF0D6EFD);
  Color get pink => const Color(0xFFD63384);
  Color get teal => const Color(0xFF20C997);
  Color get cyan => const Color(0xFF0DCAF0);
  Color get gray => const Color(0xFF6C757D);
  Color get green => const Color(0xFF198754);
  Color get black => const Color(0xFF000000);
  Color get white => const Color(0xFFFFFFFF);
  Color get indigo => const Color(0xFF6610F2);
  Color get purple => const Color(0xFF6F42C1);
  Color get orange => const Color(0xFFFD7E14);
  Color get yellow => const Color(0xFFFFC107);
  Color get grayDark => const Color(0xFF343A40);

  // Bootstrap gray scale
  Color get gray100 => const Color(0xFFF8F9FA);
  Color get gray200 => const Color(0xFFE9ECEF);
  Color get gray300 => const Color(0xFFDEE2E6);
  Color get gray400 => const Color(0xFFCED4DA);
  Color get gray500 => const Color(0xFFADB5BD);
  Color get gray600 => const Color(0xFF6C757D);
  Color get gray700 => const Color(0xFF495057);
  Color get gray800 => const Color(0xFF343A40);
  Color get gray900 => const Color(0xFF212529);

  // Bootstrap blue scale
  Color get blue100 => const Color(0xFFCFE2FF);
  Color get blue200 => const Color(0xFF9EC5FE);
  Color get blue300 => const Color(0xFF6EA8FE);
  Color get blue400 => const Color(0xFF3D8BFD);
  Color get blue500 => const Color(0xFF0D6EFD);
  Color get blue600 => const Color(0xFF0A58CA);
  Color get blue700 => const Color(0xFF084298);
  Color get blue800 => const Color(0xFF052C65);
  Color get blue900 => const Color(0xFF031633);

  // Bootstrap indigo scale
  Color get indigo100 => const Color(0xFFE0CFFC);
  Color get indigo200 => const Color(0xFFC29FFA);
  Color get indigo300 => const Color(0xFFA370F7);
  Color get indigo400 => const Color(0xFF8540F5);
  Color get indigo500 => const Color(0xFF6610F2);
  Color get indigo600 => const Color(0xFF520DC2);
  Color get indigo700 => const Color(0xFF3D0A91);
  Color get indigo800 => const Color(0xFF290661);
  Color get indigo900 => const Color(0xFF140330);

  // Bootstrap purple scale
  Color get purple100 => const Color(0xFFE2D9F3);
  Color get purple200 => const Color(0xFFC5B3E6);
  Color get purple300 => const Color(0xFFA98EDA);
  Color get purple400 => const Color(0xFF8C68CD);
  Color get purple500 => const Color(0xFF6F42C1);
  Color get purple600 => const Color(0xFF59359A);
  Color get purple700 => const Color(0xFF432874);
  Color get purple800 => const Color(0xFF2C1A4D);
  Color get purple900 => const Color(0xFF160D27);

  // Bootstrap pink scale
  Color get pink100 => const Color(0xFFF7D6E6);
  Color get pink200 => const Color(0xFFEFADCE);
  Color get pink300 => const Color(0xFFE685B5);
  Color get pink400 => const Color(0xFFDE5C9D);
  Color get pink500 => const Color(0xFFD63384);
  Color get pink600 => const Color(0xFFAB296A);
  Color get pink700 => const Color(0xFF801F4F);
  Color get pink800 => const Color(0xFF561435);
  Color get pink900 => const Color(0xFF2B0A1B);

  // Bootstrap red scale
  Color get red100 => const Color(0xFFF8D7DA);
  Color get red200 => const Color(0xFFF1AEB5);
  Color get red300 => const Color(0xFFEA868F);
  Color get red400 => const Color(0xFFE35D6A);
  Color get red500 => const Color(0xFFDC3545);
  Color get red600 => const Color(0xFFB02A37);
  Color get red700 => const Color(0xFF842029);
  Color get red800 => const Color(0xFF58151C);
  Color get red900 => const Color(0xFF2C0B0E);

  // Bootstrap orange scale
  Color get orange100 => const Color(0xFFFFE5D0);
  Color get orange200 => const Color(0xFFFECBA1);
  Color get orange300 => const Color(0xFFFEB272);
  Color get orange400 => const Color(0xFFFD9843);
  Color get orange500 => const Color(0xFFFD7E14);
  Color get orange600 => const Color(0xFFCA6510);
  Color get orange700 => const Color(0xFF984C0C);
  Color get orange800 => const Color(0xFF653208);
  Color get orange900 => const Color(0xFF331904);

  // Bootstrap yellow scale
  Color get yellow100 => const Color(0xFFFFF3CD);
  Color get yellow200 => const Color(0xFFFFE69C);
  Color get yellow300 => const Color(0xFFFFDA6A);
  Color get yellow400 => const Color(0xFFFFCD39);
  Color get yellow500 => const Color(0xFFFFC107);
  Color get yellow600 => const Color(0xFFCC9A06);
  Color get yellow700 => const Color(0xFF997404);
  Color get yellow800 => const Color(0xFF664D03);
  Color get yellow900 => const Color(0xFF332701);

  // Bootstrap green scale
  Color get green100 => const Color(0xFFD1E7DD);
  Color get green200 => const Color(0xFFA3CFBB);
  Color get green300 => const Color(0xFF75B798);
  Color get green400 => const Color(0xFF479F76);
  Color get green500 => const Color(0xFF198754);
  Color get green600 => const Color(0xFF146C43);
  Color get green700 => const Color(0xFF0F5132);
  Color get green800 => const Color(0xFF0A3622);
  Color get green900 => const Color(0xFF051B11);

  // Bootstrap teal scale
  Color get teal100 => const Color(0xFFD2F4EA);
  Color get teal200 => const Color(0xFFA6E9D5);
  Color get teal300 => const Color(0xFF79DFC1);
  Color get teal400 => const Color(0xFF4DD4AC);
  Color get teal500 => const Color(0xFF20C997);
  Color get teal600 => const Color(0xFF1AA179);
  Color get teal700 => const Color(0xFF13795B);
  Color get teal800 => const Color(0xFF0D503C);
  Color get teal900 => const Color(0xFF06281E);

  // Bootstrap cyan scale
  Color get cyan100 => const Color(0xFFCFF4FC);
  Color get cyan200 => const Color(0xFF9EEAF9);
  Color get cyan300 => const Color(0xFF6EDFF6);
  Color get cyan400 => const Color(0xFF3DD5F3);
  Color get cyan500 => const Color(0xFF0DCAF0);
  Color get cyan600 => const Color(0xFF0AA2C0);
  Color get cyan700 => const Color(0xFF087990);
  Color get cyan800 => const Color(0xFF055160);
  Color get cyan900 => const Color(0xFF032830);
}

/// Class containing rounded corner values.
class Rounded {
  /// Returns the small rounded corner value (4px).
  static double get sm => 4.0;

  /// Returns the default rounded corner value (8px).
  static double get df => 8.0;

  /// Returns the medium rounded corner value (12px).
  static double get md => 12.0;

  /// Returns the large rounded corner value (16px) — inputs & micro cards.
  static double get lg => 16.0;

  /// Returns the extra large rounded corner value (24px) — content cards.
  static double get xl => 24.0;

  /// Returns the extra extra large rounded corner value (32px) — sheets.
  static double get xxl => 32.0;

  /// Returns the fully rounded / pill value (9999px).
  static double get full => 9999.0;
}

/// Class containing spacing values.
class Spacing {
  /// Returns the base spacing unit (4px).
  static double get unit => 4.0;

  /// Returns the gutter spacing value (16px).
  static double get gutter => 16.0;

  /// Returns the mobile screen edge margin (20px).
  static double get marginMobile => 20.0;

  /// Returns the tablet screen edge margin (24px).
  static double get marginTablet => 24.0;

  /// Returns the desktop screen edge margin (48px).
  static double get marginDesktop => 48.0;

  /// Returns the focused content max width for tablet/desktop decks.
  static double get maxContentWidth => 680.0;

  /// Returns the spacing value for a small stack of widgets (8px).
  static double get stackSm => 8.0;

  /// Returns the spacing value for a medium stack of widgets (16px).
  static double get stackMd => 16.0;

  /// Returns the spacing value for a large stack of widgets (24px).
  static double get stackLg => 24.0;

  /// Returns the spacing value for an extra large stack of widgets (32px).
  static double get stackXl => 32.0;
}
