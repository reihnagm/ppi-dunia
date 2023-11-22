

import 'package:flutter/material.dart';

import 'package:ppidunia/data/repository/sos/sos.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/providers/location/location.dart';

import 'package:ppidunia/services/navigation.dart';

import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/exceptions.dart';
import 'package:ppidunia/utils/shared_preferences.dart';

import 'package:ppidunia/views/basewidgets/dialog/custom/custom.dart';
import 'package:ppidunia/views/basewidgets/snackbar/snackbar.dart';
import 'package:ppidunia/views/screens/dashboard/dashboard_state.dart';

enum SosStatus { idle, loading, loaded, empty, error } 

class SosScreenModel with ChangeNotifier {
  SosRepo sr; 
  LocationProvider lp;

  SosScreenModel({
    required this.sr,
    required this.lp
  });

  SosStatus _sosStatus = SosStatus.idle; 
  SosStatus get sosStatus => _sosStatus;

  void setStateSosStatus(SosStatus sosStatus) {
    _sosStatus = sosStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> sendSos(BuildContext context, {required String title, required String message}) async {
    setStateSosStatus(SosStatus.loading);
    try {
      await sr.sendSos(
        title: title, 
        message: "$message at ${lp.getCurrentNameAddress}", 
        lat: lp.getCurrentLat.toString(),
        lng: lp.getCurrentLng.toString(),
        userId: SharedPrefs.getUserId(),
      );
      // ignore: use_build_context_synchronously
      NS.pushReplacement(context, const DashboardScreen());
      // ignore: use_build_context_synchronously
      ShowSnackbar.snackbar(context, getTranslated('SENT_SOS'), '', ColorResources.success);
      setStateSosStatus(SosStatus.loaded);
    } on CustomException catch(e) {
      debugPrint(e.cause.toString());
      // ignore: use_build_context_synchronously
      CustomDialog.showError(context, error: 'SR01');
      setStateSosStatus(SosStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      // ignore: use_build_context_synchronously
      CustomDialog.showError(context, error: 'SP01');
      setStateSosStatus(SosStatus.error);
    }
  }
}