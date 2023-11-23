import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';

import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'package:path/path.dart' as b;

import 'package:ppidunia/common/extensions/snackbar.dart';
import 'package:flutter/material.dart';

class DownloadHelper {
  static Future<void> downloadDoc(
      {required BuildContext context, required String url}) async {
    Directory documentsIos = await getApplicationDocumentsDirectory();
    String? saveDir = Platform.isIOS
        ? documentsIos.path
        : await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOCUMENTS);

    try {
      String ext = b.basename(url).split('.').last;
      String name = b.basename(url).split('.').first;
      String filename =
          "$name-${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-${Random().nextInt(100000)}.$ext";

      ProgressDialog pr = ProgressDialog(context: context);
      pr.show(
          backgroundColor: ColorResources.greyDarkPrimary,
          msgTextAlign: TextAlign.start,
          msgMaxLines: 1,
          msgColor: ColorResources.greyLight,
          msg: "Please wait...",
          progressBgColor: ColorResources.greyLight,
          progressValueColor: ColorResources.greyDarkPrimary);
      Dio dio = Dio();
      await dio.download(
        url,
        "$saveDir/$filename",
        onReceiveProgress: (int count, int total) {},
      );
      pr.close();
      ShowSnackbar.snackbar(
          context,
          "File saved to $saveDir/${b.basename(url)}",
          "",
          ColorResources.success);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
