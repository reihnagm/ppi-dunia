import 'package:flutter/material.dart';
import 'package:ppidunia/data/models/auth/user.dart';

import 'package:ppidunia/data/repository/auth/auth.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/utils/exceptions.dart';
import 'package:ppidunia/utils/shared_preferences.dart';
import 'package:ppidunia/utils/color_resources.dart';

import 'package:ppidunia/services/navigation.dart';

import 'package:ppidunia/views/basewidgets/snackbar/snackbar.dart';
import 'package:ppidunia/views/basewidgets/textfield/textfield.dart';
import 'package:ppidunia/views/screens/auth/sign_up/widgets/change_email_bottomsheet_widget.dart';

import 'package:ppidunia/views/screens/dashboard/dashboard_state.dart';

enum VerifyOtpStatus { idle, loading, success, error }
VerifyOtpStatus _verifyOtpStatus = VerifyOtpStatus.idle;

enum ResendOtpStatus { idle, loading, success, error }
ResendOtpStatus _resendOtpStatus = ResendOtpStatus.idle;

abstract class OtpScreenModelData {
  void setStateVerifyOTPStatus(VerifyOtpStatus status);
  Future<void> verifyOTP(BuildContext context, {required String otp,});
  void setStateResendOTPStatus(ResendOtpStatus status);
  Future<void> resendOTP(BuildContext context);
  Future<void> changeEmail(BuildContext context, {required String value, required String oldValue});
}

class OtpScreenModel with ChangeNotifier implements OtpScreenModelData{
  final AuthRepo ar;

  OtpScreenModel({required this.ar});
  
  final TextEditingController emailC = TextEditingController();
  String changeEmailError = "";

  String oldEmail = SharedPrefs.getRegEmail();
  String value = "";

  VerifyOtpStatus get verifyOtpStatus => _verifyOtpStatus;
  ResendOtpStatus get resendOtpStatus => _resendOtpStatus;

  void initEmail() {
    emailC.text = oldEmail;
    notifyListeners();
  }

  void _submissionValidation(BuildContext context, String otp) {
    if(otp.isEmpty) {
      ShowSnackbar.snackbar(context, getTranslated('EMPTY_OTP'), '', ColorResources.error);
      return;
    } else {
      verifyOTP(context, otp: otp);
    }
    notifyListeners();
  }

  void submit(BuildContext context) {
    final otp = value.trim();
    _submissionValidation(context, otp);
    notifyListeners();
  }
  
  void navigateToHome(BuildContext context){
    SharedPrefs.removeEmailOTP();
    emailC.clear();
    changeEmailError = "";
    NS.pushReplacement(context, const DashboardScreen());
    notifyListeners();
  }

  bool _onProcessOTP = true;
  bool get onProcessOTP => _onProcessOTP;

  void setOnProcessOTP(BuildContext context,) {
    _onProcessOTP = !_onProcessOTP;
    notifyListeners();
  }

  void resetOnProcessOTP(BuildContext context,) {
    _onProcessOTP = true;
    notifyListeners();
  }

  void buildBottomSheet(BuildContext context, OtpScreenModel viewModel) {
    final screenSize = MediaQuery.sizeOf(context);
    changeEmailError = "";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      barrierColor: ColorResources.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(35),
        )
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                return ChangeEmailBottomsheetWidget(
                  emailC: emailC,
                  screenSize: screenSize,
                  scrollC: scrollController,
                );
              }
            );
          }
        );
      },
    );
    notifyListeners();
  }

  bool submissionValidation(BuildContext context, String email) {
    if(email.isEmpty) {
      changeEmailError = getTranslated('EMAIL_EMPTY');
      FocusScope.of(context).unfocus();
      notifyListeners();
      return false;
    }
    else if(!email.isValidEmail()) {
      changeEmailError = getTranslated('INVALID_FORMAT_EMAIL');
      FocusScope.of(context).unfocus();
      notifyListeners();
      return false;
    }
    return true;
  }

  void submitChangeEmail(BuildContext context) {
    final newEmail = emailC.text.trim();

    final bool isClear = submissionValidation(context, newEmail);
    if(isClear) {
      changeEmail(context, value: newEmail, oldValue: oldEmail);
    }
    
    notifyListeners();
  }
  
  @override
  void setStateResendOTPStatus(ResendOtpStatus status) {
    _resendOtpStatus = status;
    notifyListeners();
  }
  
  @override
  Future<void> resendOTP(BuildContext context) async {
    setStateResendOTPStatus(ResendOtpStatus.loading);
    try {
      await ar.resendOTP(email: SharedPrefs.getEmailOTP());
      setStateResendOTPStatus(ResendOtpStatus.loading);
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      NetworkException.handle(context, e.toString());
      setStateResendOTPStatus(ResendOtpStatus.error);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      setStateResendOTPStatus(ResendOtpStatus.error);
      notifyListeners();
    }
  }
  
  
  @override
  void setStateVerifyOTPStatus(VerifyOtpStatus status) {
    _verifyOtpStatus = status;
    notifyListeners();
  }
  
  @override
  Future<void> verifyOTP(BuildContext context, {required String otp}) async {
    setStateVerifyOTPStatus(VerifyOtpStatus.loading);
    try {
      UserModel user = await ar.verifyOTP(
        otp: otp,
        email: SharedPrefs.getEmailOTP(),
      );
      setOnProcessOTP(context);
      SharedPrefs.writeAuthData(user.data!);
      SharedPrefs.writeAuthToken();
      SharedPrefs.deleteIfUserRegistered();
      setStateVerifyOTPStatus(VerifyOtpStatus.loading);
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      NetworkException.handle(context, e.toString());
      setStateVerifyOTPStatus(VerifyOtpStatus.error);
      SharedPrefs.deleteIfUserRegistered();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      setStateVerifyOTPStatus(VerifyOtpStatus.error);
      SharedPrefs.deleteIfUserRegistered();
      notifyListeners();
    }
  }
  
  @override
  Future<void> changeEmail(BuildContext context, {required String value, required String oldValue}) async {
    try {
      await ar.updateEmail(
        oldEmail: oldValue,
        newEmail: value,
      );
      oldEmail = value;
      SharedPrefs.writeEmailOTP(value);
      changeEmailError = "";
      Navigator.pop(context);
      notifyListeners();
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      NetworkException.handle(context, e.toString());
      Navigator.pop(context);
      notifyListeners();
    } catch (e) {
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      Navigator.pop(context);
      notifyListeners();
    }
  }
}