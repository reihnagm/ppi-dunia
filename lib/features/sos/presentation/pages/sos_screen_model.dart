import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/utils/modals.dart';

import 'package:ppidunia/features/sos/data/repositories/sos.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/features/location/presentation/providers/location.dart';

import 'package:ppidunia/services/navigation.dart';

import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';

import 'package:ppidunia/views/basewidgets/dialog/custom/custom.dart';
import 'package:ppidunia/common/extensions/snackbar.dart';
import 'package:ppidunia/features/dashboard/presentation/pages/dashboard_state.dart';
import 'package:sn_progress_dialog/options/cancel.dart';
import 'package:sn_progress_dialog/options/completed.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

enum SosStatus { idle, loading, loaded, empty, error }

class SosScreenModel with ChangeNotifier {
  SosRepo sr;
  LocationProvider lp;

  SosScreenModel({required this.sr, required this.lp});

  SosStatus _sosStatus = SosStatus.idle;
  SosStatus get sosStatus => _sosStatus;

  void setStateSosStatus(SosStatus sosStatus) {
    _sosStatus = sosStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> sendSos(BuildContext context,
      {required String title, required String message}) async {
    setStateSosStatus(SosStatus.loading);
    try {
      Navigator.pop(context);
      ProgressDialog pr = ProgressDialog(context: context);
      pr.show(
          backgroundColor: ColorResources.greyDarkPrimary,
          msgTextAlign: TextAlign.start,
          msgMaxLines: 1,
          msgColor: ColorResources.greyLight,
          msg: "Please wait...",
          progressBgColor: ColorResources.greyLight,
          progressValueColor: ColorResources.greyDarkPrimary,
          onStatusChanged: (status) async {
            if (status == DialogStatus.opened){
              print("opened");
              Position position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.bestForNavigation);

              List<Placemark> placemarks =
                  await placemarkFromCoordinates(position.latitude, position.longitude);

              Placemark place = placemarks[0];

              lp.setLatLng(position.latitude, position.longitude);

              SharedPrefs.writeCurrentAddress(
                  "${place.thoroughfare} ${place.subThoroughfare} \n${place.locality}, ${place.postalCode}");

              if (lp.getCurrentLat == 0.0 || lp.getCurrentLng == 0.0) {
                GeneralModal.info(msg: "Location not found", isBackHome: true);
                return;
              }

              debugPrint(position.latitude.toString());
              debugPrint(position.longitude.toString());

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
              ShowSnackbar.snackbar(
                context, getTranslated('SENT_SOS'), '', ColorResources.success);
            }
          }
      );
      setStateSosStatus(SosStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.cause.toString());
      // ignore: use_build_context_synchronously
      CustomDialog.showError(context, error: 'SR01');
      setStateSosStatus(SosStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      // ignore: use_build_context_synchronously
      CustomDialog.showError(context, error: 'SP01');
      setStateSosStatus(SosStatus.error);
    }
  }
}
