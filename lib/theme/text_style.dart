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
}
