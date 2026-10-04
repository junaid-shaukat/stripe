// permission_service.dart
import '/core/app_export.dart';

/// A service to handle permission checks and requests, including system service status.
class PermissionService {
  PermissionService._internal();

  static final PermissionService instance = PermissionService._internal();

  factory PermissionService() => instance;

  bool _requesting = false;
  Permission? _currentRequest;

  bool get requesting => _requesting;

  Permission? get currentRequest => _currentRequest;

  Future<bool> check() async {
    for (final item in Permissions.all) {
      final status = await item.key.status;
      item.status.value = status;
    }

    return Permissions.all.every(
      (item) => item.ignore || item.status.value == PermissionStatus.granted,
    );
  }

  Future<PermissionStatus> status(Permission permission) async {
    final status = await permission.status;
    return status;
  }

  Future<PermissionStatus> request(Permission permission) async {
    if (_requesting) {
      return _currentRequest == permission
          ? await permission.status
          : PermissionStatus.denied;
    }

    _requesting = true;
    _currentRequest = permission;
    try {
      final status = await permission.request();
      return status;
    } finally {
      _requesting = false;
      _currentRequest = null;
    }
  }
}
