import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ppidunia/common/utils/modals.dart';

class StorageNotifier with ChangeNotifier {

  StorageNotifier() {
    isDialogShowing = false;
  } 

  bool isDialogShowing = false;

  void cancelDialog() {
    isDialogShowing = false;

    notifyListeners();
  }

  Future<void> checkStoragePermission() async {

    var androidInfo = await DeviceInfoPlugin().androidInfo;

    var sdkInt = androidInfo.version.sdkInt;

    if(sdkInt >= 33) {

      var photos = await Permission.photos.request().isDenied || await Permission.photos.request().isPermanentlyDenied;

      if(photos) {
        if (!isDialogShowing) {
          isDialogShowing = true;
          await GeneralModal.dialogRequestNotification(
            msg: "Files & media access permission is required, please activate it first",  
          );
          return;
        }
      }

    } else {

      var storage = await Permission.storage.request().isDenied || await Permission.storage.request().isPermanentlyDenied;

      if(storage) {
        if (!isDialogShowing) {
          isDialogShowing = true;
          await GeneralModal.dialogRequestNotification(
            msg: "Files & media access permission is required, please activate it first",   
          );
          return;
        }
      }

    }

  }

}