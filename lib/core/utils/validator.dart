import '/core/app_export.dart';

class Validator {
  static String? isEmailAddress(String? input, {bool isRequired = true}) {
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);

    if (input == null || input.isEmpty) {
      if (isRequired) {
        return "required".trParams({"field": "email_address".tr.toLowerCase()});
      } else {
        return null;
      }
    }

    if (!regExp.hasMatch(input)) {
      return "invalid".trParams({"field": "email_address".tr.toLowerCase()});
    }

    return null;
  }

  static String? isFullName(String? input, {bool isRequired = true}) {
    const pattern = r'^[a-zA-Z ]+$';
    RegExp regExp = RegExp(pattern);

    if (input == null || input.isEmpty) {
      if (isRequired) {
        return "required".trParams({"field": "full_name".tr.toLowerCase()});
      } else {
        return null;
      }
    }

    if (!regExp.hasMatch(input)) {
      return "invalid.field.allowed".trParams({
        "field": "full_name".tr.toLowerCase(),
        "allowed": "only_alphabets".tr.toLowerCase(),
      });
    }

    return null;
  }

  static String? isMobileNumber(String? input, {bool isRequired = true}) {
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    RegExp regExp = RegExp(pattern);

    if (input == null || input.isEmpty) {
      if (isRequired) {
        return "required".trParams({"field": "mobile_number".tr.toLowerCase()});
      } else {
        return null;
      }
    }
    if (!regExp.hasMatch(input)) {
      return "invalid.field.allowed".trParams({
        "field": "mobile_number".tr.toLowerCase(),
        "allowed": "only_numbers".tr.toLowerCase(),
      });
    }

    return null;
  }

  static String? isPassword(String? input, {bool isRequired = true}) {
    const pattern = r'^.{8,}$';
    RegExp regExp = RegExp(pattern);

    if (input == null || input.isEmpty) {
      if (isRequired) {
        return "required".trParams({"field": "password".tr.toLowerCase()});
      } else {
        return null;
      }
    }
    if (!regExp.hasMatch(input)) {
      return "invalid.field.allowed".trParams({
        "field": "password".tr.toLowerCase(),
        "allowed": "at_least_8_characters".tr.toLowerCase(),
      });
    }
    return null;
  }

  static String? isConfirmPassword(
    String? input,
    String? password, {
    bool isRequired = true,
  }) {
    if (input == null || input.isEmpty) {
      if (isRequired) {
        return "required".trParams({
          "field": "confirm_password".tr.toLowerCase(),
        });
      } else {
        return null;
      }
    }
    if (input != password) {
      return "not_match".trParams({
        "a": "confirm_password".tr.toLowerCase(),
        "b": "password".tr.toLowerCase(),
      });
    }
    return null;
  }

  static String? isPinCode(String? input, {bool isRequired = true}) {
    const pattern = r'^[0-9]{6}$';
    RegExp regExp = RegExp(pattern);

    if (input == null || input.isEmpty) {
      if (isRequired) {
        return "required".trParams({"field": "pin_code".tr.toLowerCase()});
      } else {
        return null;
      }
    }
    if (!regExp.hasMatch(input)) {
      return "invalid.field.allowed".trParams({
        "field": "pin_code".tr.toLowerCase(),
        "allowed": "only_numbers".tr.toLowerCase(),
      });
    }
    return null;
  }
}
