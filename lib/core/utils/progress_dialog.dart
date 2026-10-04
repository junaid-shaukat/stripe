import 'package:flutter/material.dart';

import '/core/app_export.dart';

class ProgressDialog {
  static bool isVisible = false;

  ///common method for showing progress dialog
  static void onStart({bool isCancellable = false}) async {
    if (!isVisible) {
      Get.dialog(
        Center(
          child: CircularProgressIndicator(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(appTheme.primary),
          ),
        ),
        barrierDismissible: isCancellable,
      );
      isVisible = true;
    }
  }

  ///common method for hiding progress dialog
  static void onStop() {
    if (isVisible) Get.back();
    isVisible = false;
  }
}
