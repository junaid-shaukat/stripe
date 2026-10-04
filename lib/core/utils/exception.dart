abstract class AppException implements Exception {
  final dynamic message;

  const AppException(this.message);

  @override
  String toString() {
    return message;
  }
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class InternalError extends AppException {
  InternalError(super.message);
}

class CustomException implements Exception {
  final int status;
  final bool success;
  final dynamic data;
  final String message;
  final dynamic errors;

  CustomException(
    this.message, {
    this.data,
    this.errors,
    this.status = 500,
    this.success = false,
  });

  @override
  String toString() => message;

  Map<String, dynamic> toJson() => {
    'status': status,
    'success': success,
    'data': data,
    'message': message,
    'errors': errors,
  };
}

class BadResponse implements Exception {
  final int status;
  final bool success;
  final dynamic data;
  final String message;
  final dynamic errors;

  BadResponse(
    this.message, {
    this.data,
    this.errors,
    this.status = 500,
    this.success = false,
  });

  @override
  String toString() => message;

  Map<String, dynamic> toJson() => {
    'status': status,
    'success': success,
    'data': data,
    'message': message,
    'errors': errors,
  };
}
