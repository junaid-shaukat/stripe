import 'package:flutter/material.dart';

import '/core/app_export.dart';

class Permissions {
  bool ignore;
  String title;
  IconData icon;
  Permission key;
  String description;
  Rx<PermissionStatus> status;

  static List<Permissions> all = [
    Permissions(
      title: 'location'.tr,
      icon: Icons.location_on,
      key: Permission.location,
      status: PermissionStatus.denied,
      description: 'location.permissions.description'.tr,
    ),
    Permissions(
      ignore: true,
      title: 'camera'.tr,
      key: Permission.camera,
      icon: Icons.photo_camera,
      status: PermissionStatus.denied,
      description: 'camera.permissions.description'.tr,
    ),
    Permissions(
      title: 'notifications'.tr,
      icon: Icons.notifications,
      key: Permission.notification,
      status: PermissionStatus.denied,
      description: 'notifications.permissions.description'.tr,
    ),
  ];

  Permissions({
    required this.key,
    required this.icon,
    required this.title,
    this.ignore = false,
    PermissionStatus? status,
    required this.description,
  }) : status = Rx<PermissionStatus>(status ?? PermissionStatus.denied);

  Map<String, dynamic> toJson({List<String> skip = const []}) {
    final map = <String, dynamic>{};

    void addField(String key, dynamic value) {
      if (!skip.contains(key) && value != null) {
        map[key] = value;
      }
    }

    addField('key', key);
    addField('icon', icon);
    addField('title', title);
    addField('status', status.value);
    addField('description', description);
    return map;
  }
}
