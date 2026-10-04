import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({
    super.key,
    this.width,
    this.height,
    this.margin,
    this.onPressed,
    this.alignment,
    this.isDisabled,
    this.buttonStyle,
    required this.text,
    this.buttonTextStyle,
  });

  final String text;
  final double? width;
  final double? height;
  final bool? isDisabled;
  final Alignment? alignment;
  final VoidCallback? onPressed;
  final ButtonStyle? buttonStyle;
  final TextStyle? buttonTextStyle;
  final EdgeInsetsDirectional? margin;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
