import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ppidunia/common/extensions/snackbar.dart';
import 'package:ppidunia/common/utils/color_resources.dart';

class PermissionHelper {
  static Future<void> check(BuildContext context, {
    required Permission permissionType,
    required String permissionName
  }) async {
    if (await permissionType.status.isDenied) {
      permissionType.request();
      return;
    } else if (await permissionType.status.isPermanentlyDenied) {
      if (context.mounted) {
        ShowSnackbar.snackbar(context, 'Izin untuk $permissionName diperlukan.', '',
          ColorResources.error);
      }
      Future.delayed(
        const Duration(seconds: 1),
        () => openAppSettings(),
      );
      return;
    }
    permissionType.request();
  }
}
