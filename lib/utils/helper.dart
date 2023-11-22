import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';

import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ppidunia/utils/color_resources.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'package:path/path.dart' as b;

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/views/basewidgets/snackbar/snackbar.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/date_symbol_data_local.dart';

class Helper {
  
  static String formatCurrency(double number, {bool useSymbol = true}) {
    final NumberFormat _fmt = NumberFormat.currency(locale: 'id', symbol: useSymbol ? 'Rp ' : '');
    String s = _fmt.format(number);
    String _format = s.toString().replaceAll(RegExp(r"([,]*00)(?!.*\d)"), "");
    return _format;
  }
  
  static String formatDate(DateTime dateTime) {
    initializeDateFormatting("id");
    return DateFormat.yMMMMEEEEd("id").format(dateTime);
  }

  static createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  static createUniqueV4Id() {
    var id = const Uuid();
    return id.v4();
  }

  static Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }
  
  static Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
    return Color(int.parse('0x$alphaChannel$hexString'));
  }

  static int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  static greetings(BuildContext context) {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return getTranslated("GOOD_MORNING");
    }
    if (hour < 17) {
      return getTranslated("GOOD_AFTERNOON");
    }
    return  getTranslated("GOOD_EVENING");
  }

  static Future<void> downloadDoc({required BuildContext context, required String url}) async {
    Directory documentsIos = await getApplicationDocumentsDirectory();
    String? saveDir = Platform.isIOS 
    ? documentsIos.path 
    : await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOCUMENTS);

    try {
      String ext = b.basename(url).split('.').last;
      String name = b.basename(url).split('.').first;
      String filename = "$name-${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-${Random().nextInt(100000)}.$ext";
      
      ProgressDialog pr = ProgressDialog(context: context);
      pr.show(
        backgroundColor: ColorResources.greyDarkPrimary,
        msgTextAlign: TextAlign.start,
        msgMaxLines: 1,
        msgColor: ColorResources.greyLight,
        msg: "Please wait...",
        progressBgColor: ColorResources.greyLight,
        progressValueColor: ColorResources.greyDarkPrimary
      );
      Dio dio = Dio();
      await dio.download(url, "$saveDir/$filename",
        onReceiveProgress: (int count, int total) { },
      );  
      pr.close();
      ShowSnackbar.snackbar(context, "File saved to $saveDir/${b.basename(url)}", "", ColorResources.success);
    } catch(e) {
      debugPrint(e.toString());
    }
  }

}