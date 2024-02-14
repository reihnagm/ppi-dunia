import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ppidunia/common/extensions/snackbar.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/modals.dart';

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
        GeneralModal.dialogRequestNotification(
            msg: 'Permission for $permissionName is required.',  
        );
      }
      return;
    }
    permissionType.request();
  }
}
