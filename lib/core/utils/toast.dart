import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Add this for SVG support
import 'package:fluttertoast/fluttertoast.dart';

import '/core/app_export.dart';

class ToastParams {
  final String? title;
  final String? message;

  ToastParams({this.title, this.message});

  ToastParams fromJson(Map<String, dynamic> json) {
    return ToastParams(title: json['title'], message: json['message']);
  }

  ToastParams copyWith({String? title, String? message}) {
    return ToastParams(
      title: title ?? this.title,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final Map<String, dynamic> dataMap = {};

    void addField(String key, dynamic value) {
      if (!skip.contains(key) && value != null) {
        dataMap[key] = value;
      }
    }

    addField('title', title);
    addField('message', message);

    return dataMap;
  }
}

class ToastOptions {
  final Color? color;
  final double radius;
  final String? icon; // Can be SVG path or IconData
  final Color? background;
  final bool ignorePointer;
  final bool isDismissible;
  final ToastGravity? gravity;
  final Duration fadeDuration;
  final Duration toastDuration;
  final double iconSize; // Added for icon sizing

  ToastOptions({
    this.icon,
    this.color,
    this.gravity,
    this.background,
    this.radius = 25,
    this.ignorePointer = false,
    this.isDismissible = false,
    this.iconSize = 24,
    this.toastDuration = const Duration(seconds: 5),
    this.fadeDuration = const Duration(milliseconds: 350),
  });

  ToastOptions copyWith({
    String? icon,
    Color? color,
    double? radius,
    Color? background,
    bool? ignorePointer,
    bool? isDismissible,
    ToastGravity? gravity,
    double? iconSize,
    Duration? fadeDuration,
    Duration? toastDuration,
  }) {
    return ToastOptions(
      icon: icon ?? this.icon,
      color: color ?? this.color,
      radius: radius ?? this.radius,
      gravity: gravity ?? this.gravity,
      background: background ?? this.background,
      iconSize: iconSize ?? this.iconSize,
      fadeDuration: fadeDuration ?? this.fadeDuration,
      ignorePointer: ignorePointer ?? this.ignorePointer,
      isDismissible: isDismissible ?? this.isDismissible,
      toastDuration: toastDuration ?? this.toastDuration,
    );
  }
}

class Toast {
  static final FToast _fToast = FToast();

  /// Call this once after app start
  static void init(BuildContext context) {
    _fToast.init(context);
  }

  static void show({
    Widget? child,
    ToastParams? params,
    ToastOptions? options,
    Widget Function(BuildContext, Widget, ToastGravity?)?
    positionedToastBuilder,
  }) {
    // Remove any active toast before showing a new one
    _fToast.removeCustomToast();

    _fToast.showToast(
      child: child ?? _buildToast(params: params, options: options),
      isDismissible: options?.isDismissible ?? true,
      ignorePointer: options?.ignorePointer ?? false,
      positionedToastBuilder: positionedToastBuilder,
      gravity: options?.gravity ?? ToastGravity.BOTTOM,
      fadeDuration: options?.fadeDuration ?? const Duration(milliseconds: 350),
      toastDuration: options?.toastDuration ?? const Duration(seconds: 5),
    );
  }

  static void success({
    String? title,
    String? message,
    ToastParams? params,
    ToastOptions? options,
  }) {
    params ??= ToastParams();
    options ??= ToastOptions();
    params = params.copyWith(title: title, message: message ?? 'success'.tr);
    options = options.copyWith(
      background: Colors.green,
      icon: options.icon ?? 'assets/icons/success.svg', // Add your SVG path
    );
    show(options: options, params: params);
  }

  static void error({
    String? title,
    String? message,
    ToastParams? params,
    ToastOptions? options,
  }) {
    params ??= ToastParams();
    options ??= ToastOptions();
    params = params.copyWith(title: title, message: message ?? 'error'.tr);
    options = options.copyWith(
      background: Colors.red,
      icon: options.icon ?? 'assets/icons/error.svg',
    );
    show(options: options, params: params);
  }

  static void info({
    String? title,
    String? message,
    ToastParams? params,
    ToastOptions? options,
  }) {
    params ??= ToastParams();
    options ??= ToastOptions();
    params = params.copyWith(title: title, message: message ?? 'info'.tr);
    options = options.copyWith(
      background: Colors.blue,
      icon: options.icon ?? 'assets/icons/info.svg',
    );
    show(options: options, params: params);
  }

  static void warning({
    String? title,
    String? message,
    ToastParams? params,
    ToastOptions? options,
  }) {
    params ??= ToastParams();
    options ??= ToastOptions();
    params = params.copyWith(title: title, message: message ?? 'warning'.tr);
    options = options.copyWith(
      background: Colors.orange, // Changed from red to orange for warning
      icon: options.icon ?? 'assets/icons/warning.svg',
    );
    show(options: options, params: params);
  }

  static void network({
    String? title,
    String? message,
    ToastParams? params,
    ToastOptions? options,
  }) {
    params ??= ToastParams();
    options ??= ToastOptions();
    params = params.copyWith(title: title, message: message ?? 'info'.tr);
    options = options.copyWith(
      background: Colors.blue,
      icon: options.icon ?? 'assets/icons/network.svg',
    );
    show(options: options, params: params);
  }

  static void badResponse(
    BadResponse e, {
    ToastParams? params,
    ToastOptions? options,
  }) {
    final messages = <String>[];

    final errors = e.errors;

    if (errors is List) {
      messages.addAll(errors.map((error) => error.toString()));
    } else if (errors is Map) {
      errors.forEach((field, value) {
        if (value is List) {
          messages.add('$field: ${value.join(', ')}');
        } else {
          messages.add('$field: ${value.toString()}');
        }
      });
    } else if (errors != null) {
      messages.add(errors.toString());
    }

    final title = e.message;

    final message = messages.isNotEmpty ? messages.join('\n') : e.message;

    params ??= ToastParams();

    params = params.copyWith(title: title, message: message);

    options ??= ToastOptions();

    options = options.copyWith(
      background: Colors.red,
      icon: options.icon ?? 'assets/icons/error.svg',
    );

    show(options: options, params: params);
  }

  static void custom({
    String? title,
    String? message,
    ToastParams? params,
    ToastOptions? options,
  }) {
    params ??= ToastParams();
    options ??= ToastOptions();
    params = params.copyWith(title: title, message: message ?? 'custom'.tr);
    options = options.copyWith(
      background: Colors.black,
      icon: options.icon ?? 'assets/icons/custom.svg',
    );
    show(options: options, params: params);
  }

  static Widget _buildToast({ToastParams? params, ToastOptions? options}) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 24, // Remove .h if it's not defined
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: options?.background ?? Colors.black,
        borderRadius: BorderRadius.circular(options?.radius ?? 25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center, // Changed to center
        children: [
          // Icon widget that supports both SVG and regular icons
          _buildIconWidget(options),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (params?.title != null && params!.title!.isNotEmpty) ...[
                  Text(
                    params.title!,
                    style: TextStyle(
                      fontSize: 15.fSize,
                      fontWeight: FontWeight.bold,
                      color: options?.color ?? Colors.white,
                    ),
                  ),
                ],
                if (params?.message != null && params!.message!.isNotEmpty) ...[
                  if (params.title != null && params.title!.isNotEmpty)
                    SizedBox(height: 4),
                  Text(
                    params.message!,
                    style: TextStyle(
                      fontSize: 14.fSize,
                      color:
                          options?.color ?? Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build icon with SVG support
  static Widget _buildIconWidget(ToastOptions? options) {
    final icon = options?.icon;
    final iconSize = options?.iconSize ?? 24;

    if (icon == null) {
      return SizedBox(width: iconSize, height: iconSize);
    }

    // Check if it's an SVG path
    if (icon.endsWith('.svg')) {
      return SvgPicture.asset(
        icon,
        width: iconSize,
        height: iconSize,
        colorFilter: ColorFilter.mode(
          options?.color ?? Colors.white,
          BlendMode.srcIn,
        ),
      );
    }

    // If it's an IconData (use IconData from your app's constants)
    // You can implement your own mapping logic here
    return Icon(
      Icons.circle, // Default fallback
      size: iconSize,
      color: options?.color ?? Colors.white,
    );
  }
}
