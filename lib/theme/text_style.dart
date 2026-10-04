import 'package:flutter/material.dart';

import '/core/app_export.dart';

class TextStyles {
  static TextStyle titleMedium({
    Color? color,
    double? fontSize,
    String? fontFamily,
    List<Shadow>? shadows,
    double? letterSpacing,
    FontWeight? fontWeight,
  }) => theme.textTheme.titleMedium!.copyWith(
    shadows: shadows,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
    letterSpacing: letterSpacing,
    color: color ?? appTheme.onSurface,
  );

  /// Splash — central AINTIS wordmark inside the emblem.
  static TextStyle wordmark({double? fontSize}) => TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: fontSize ?? 29.fSize,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.5,
    height: 1,
    color: appTheme.aintisNavy,
  );

  /// Splash — "Powered by AI" tagline.
  static TextStyle tagline({double? fontSize}) => TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: fontSize ?? 18.fSize,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
    height: 24 / 18,
    color: appTheme.aintisMagenta,
  );

  /// Splash — status bar clock.
  static TextStyle statusBarTime({double? fontSize}) => TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: fontSize ?? 13.fSize,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    height: 1,
    color: appTheme.statusBarTime,
  );

  /// Splash — status bar network / battery micro labels.
  static TextStyle statusBarMicro({double? fontSize}) => TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: fontSize ?? 8.fSize,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
    height: 9 / 8,
    color: appTheme.statusBarText,
  );
}
