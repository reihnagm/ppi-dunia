import 'package:flutter/material.dart';
import 'package:ppidunia/data/repository/auth/auth.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/exceptions.dart';
import 'package:ppidunia/utils/shared_preferences.dart';
import 'package:ppidunia/views/basewidgets/snackbar/snackbar.dart';

enum ChangePasswordStatus { idle, loading, success, error }
ChangePasswordStatus _changePasswordStatus = ChangePasswordStatus.idle;

abstract class ChangePasswordScreenModelData {
  void setStateChangePasswordStatus(ChangePasswordStatus status);
  Future<void> setChangePassword(BuildContext context, {
    required String oldPassword,
    required String newPassword,
  });
}

class ChangePasswordScreenModel with ChangeNotifier implements ChangePasswordScreenModelData{
  final AuthRepo ar;

  ChangePasswordScreenModel({
    required this.ar,
  });
  
  ChangePasswordStatus get changePasswordStatus => _changePasswordStatus;
  
  TextEditingController oldPasswordC = TextEditingController();
  TextEditingController newPasswordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();

  FocusNode oldPasswordFn = FocusNode();
  FocusNode newPasswordFn = FocusNode();
  FocusNode confirmPasswordFn = FocusNode();

  bool submissionValidation(BuildContext context,{
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    if(oldPassword.isEmpty) {
      ShowSnackbar.snackbar(context, getTranslated('OLD_PASSWORD_EMPTY'), '', ColorResources.error); 
      oldPasswordFn.requestFocus();
      return false;
    } else if(oldPassword.length < 8) {
      ShowSnackbar.snackbar(context, getTranslated('OLD_PASSWORD_LENGTH'), '', ColorResources.error); 
      oldPasswordFn.requestFocus();
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
      ShowSnackbar.snackbar(context, getTranslated('CONFIRM_PASSWORD_EMPTY'), '', ColorResources.error); 
      newPasswordFn.requestFocus();
      return false;
    } else if(confirmPassword.length < 8) {
      ShowSnackbar.snackbar(context, getTranslated('CONFIRM_PASSWORD_LENGTH'), '', ColorResources.error); 
      confirmPasswordFn.requestFocus();
      return false;
    } else if(confirmPassword != newPassword) {
      ShowSnackbar.snackbar(context, getTranslated('INVALID_CONFIRM_PASSWORD_INPUT'), '', ColorResources.error);
      newPasswordFn.requestFocus();
      return false;
    }

    return true;
  }

  void submitControllerValue(BuildContext context) {
    final oldPassword = oldPasswordC.text.trim();
    final newPassword = newPasswordC.text.trim();
    final confirmPassword = confirmPasswordC.text.trim();
    
    final bool isClear = submissionValidation(context,
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    if(isClear) {
      setChangePassword(context, newPassword: confirmPassword, oldPassword: oldPassword);
    }

    notifyListeners();
  }

  @override
  void setStateChangePasswordStatus(ChangePasswordStatus status) {
    _changePasswordStatus = status;
    notifyListeners();
  }
  //TODO: dicek apakah work atau gak pas profile udah jadi
  @override
  Future<void> setChangePassword(BuildContext context, {
    required String oldPassword,
    required String newPassword,
  }) async {
    setStateChangePasswordStatus(ChangePasswordStatus.loading);
    try {
      await ar.changePassword(
        email: SharedPrefs.getUserEmail(),
        newPassword: newPassword,
        oldPassword: oldPassword,
      );
      ShowSnackbar.snackbar(context, getTranslated('PASSWORD_UPDATED'), '', ColorResources.success);
      NS.pop(context);
      setStateChangePasswordStatus(ChangePasswordStatus.success);
      notifyListeners();
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      NetworkException.handle(context, e.toString());
      setStateChangePasswordStatus(ChangePasswordStatus.error);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      setStateChangePasswordStatus(ChangePasswordStatus.error);
      notifyListeners();
    }
  }
}