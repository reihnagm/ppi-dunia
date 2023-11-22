import 'package:flutter/material.dart';
import 'package:ppidunia/data/repository/auth/auth.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/exceptions.dart';
import 'package:ppidunia/utils/shared_preferences.dart';
import 'package:ppidunia/views/basewidgets/snackbar/snackbar.dart';
import 'package:ppidunia/views/screens/auth/sign_in/sign_in_state.dart';

enum SetNewPasswordStatus { idle, loading, success, error }
SetNewPasswordStatus _setNewPasswordStatus = SetNewPasswordStatus.idle;

abstract class NewPasswordScreenModelData {
  void setStateSetNewPasswordStatus(SetNewPasswordStatus status);
  Future<void> setNewPassword(BuildContext context, {
    required String newPassword,
    required String oldPassword,
  });
}

class NewPasswordScreenModel with ChangeNotifier implements NewPasswordScreenModelData{
  final AuthRepo ar;

  NewPasswordScreenModel({
    required this.ar,
  });
  
  SetNewPasswordStatus get setNewPasswordStatus => _setNewPasswordStatus;
  
  TextEditingController verificationCodeC = TextEditingController();
  TextEditingController newPasswordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();

  FocusNode verificationCodeFn = FocusNode();
  FocusNode newPasswordFn = FocusNode();
  FocusNode confirmPasswordFn = FocusNode();

  bool submissionValidation(BuildContext context,{
    required String verificationCode,
    required String newPassword,
    required String confirmPassword,
  }) {
    if(verificationCode.isEmpty) {
      ShowSnackbar.snackbar(context, getTranslated('VERIFICATION_CODE_EMPTY'), '', ColorResources.error); 
      verificationCodeFn.requestFocus();
      return false;
    } else if(newPassword.isEmpty) {
      ShowSnackbar.snackbar(context, getTranslated('NEW_PASSWORD_EMPTY'), '', ColorResources.error); 
      newPasswordFn.requestFocus();
      return false;
    } else if(newPassword.length < 8) {
      ShowSnackbar.snackbar(context, getTranslated('NEW_PASSWORD_LENGTH'), '', ColorResources.error); 
      newPasswordFn.requestFocus();
      return false;
    } else if(confirmPassword.isEmpty) {
      ShowSnackbar.snackbar(context, getTranslated('OLD_PASSWORD_EMPTY'), '', ColorResources.error); 
      confirmPasswordFn.requestFocus();
      return false;
    } else if(confirmPassword.length < 8) {
      ShowSnackbar.snackbar(context, getTranslated('CONFIRM_PASSWORD_LENGTH'), '', ColorResources.error); 
      confirmPasswordFn.requestFocus();
      return false;
    }else if(confirmPassword != newPassword) {
      ShowSnackbar.snackbar(context, getTranslated('INVALID_CONFIRM_PASSWORD_INPUT'), '', ColorResources.error);
      confirmPasswordFn.requestFocus();
      return false;
    }

    return true;
  }

  void submitControllerValue(BuildContext context) {
    final verificationCode = verificationCodeC.text.trim();
    final newPassword = newPasswordC.text.trim();
    final confirmPassword = confirmPasswordC.text.trim();
    
    final bool isClear = submissionValidation(context,
      verificationCode: verificationCode,
      confirmPassword: confirmPassword,
      newPassword: newPassword,
    );
    if(isClear) {
      setNewPassword(context, newPassword: confirmPassword, oldPassword: verificationCode);
    }

    notifyListeners();
  }

  @override
  void setStateSetNewPasswordStatus(SetNewPasswordStatus status) {
    _setNewPasswordStatus = status;
    notifyListeners();
  }

  @override
  Future<void> setNewPassword(BuildContext context, {
    required String newPassword,
    required String oldPassword,
  }) async {
    setStateSetNewPasswordStatus(SetNewPasswordStatus.loading);
    try {
      await ar.changePassword(
        email: SharedPrefs.getForgetEmail(),
        newPassword: newPassword,
        oldPassword: oldPassword,
      );
      ShowSnackbar.snackbar(context, getTranslated('PASSWORD_UPDATED'), '', ColorResources.success);
      NS.pushReplacementDefault(context, const SignInScreen());
      SharedPrefs.removeForgets();
      setStateSetNewPasswordStatus(SetNewPasswordStatus.success);
      notifyListeners();
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      NetworkException.handle(context, e.toString());
      if(e.toString().toLowerCase().contains('password') || e.toString().toLowerCase().contains('old')) {
        ShowSnackbar.snackbar(context, getTranslated('INVALID_VERIFICATION_CODE'), '', ColorResources.error);
        verificationCodeFn.requestFocus();
      }
      setStateSetNewPasswordStatus(SetNewPasswordStatus.error);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      setStateSetNewPasswordStatus(SetNewPasswordStatus.error);
      notifyListeners();
    }
  }
}