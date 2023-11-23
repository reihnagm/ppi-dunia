import 'package:flutter/material.dart';
import 'package:ppidunia/features/auth/data/repositories/auth.dart';
import 'package:ppidunia/features/auth/presentation/pages/forget_password/second_step_screen/new_password_state.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/common/extensions/snackbar.dart';
import 'package:ppidunia/views/basewidgets/textfield/textfield.dart';

enum ForgetPasswordStatus { idle, loading, success, error }

ForgetPasswordStatus _forgetPasswordStatus = ForgetPasswordStatus.idle;

abstract class ForgetPasswordScreenModelData {
  void setStateForgetPasswordStatus(ForgetPasswordStatus status);
  Future<void> forgetPassword(
    BuildContext context, {
    required String email,
  });
}

class ForgetPasswordScreenModel
    with ChangeNotifier
    implements ForgetPasswordScreenModelData {
  final AuthRepo ar;

  ForgetPasswordScreenModel({
    required this.ar,
  });

  ForgetPasswordStatus get forgetPasswordStatus => _forgetPasswordStatus;

  TextEditingController emailC = TextEditingController();

  FocusNode emailFn = FocusNode();

  bool submissionValidation(BuildContext context, String email) {
    if (email.isEmpty) {
      ShowSnackbar.snackbar(
          context, getTranslated('EMAIL_EMPTY'), '', ColorResources.error);
      emailFn.requestFocus();
      return false;
    } else if (!email.isValidEmail()) {
      ShowSnackbar.snackbar(context, getTranslated('INVALID_FORMAT_EMAIL'), '',
          ColorResources.error);
      emailFn.requestFocus();
      return false;
    }
    return true;
  }

  void submitControllerValue(BuildContext context) {
    final email = emailC.text.trim();

    final bool isClear = submissionValidation(context, email);
    if (isClear) {
      forgetPassword(context, email: email);
    }

    notifyListeners();
  }

  @override
  void setStateForgetPasswordStatus(ForgetPasswordStatus status) {
    _forgetPasswordStatus = status;
    notifyListeners();
  }

  @override
  Future<void> forgetPassword(
    BuildContext context, {
    required String email,
  }) async {
    setStateForgetPasswordStatus(ForgetPasswordStatus.loading);
    try {
      await ar.forgetPassword(
        email: email,
      );
      SharedPrefs.writeForgetEmail(email);
      ShowSnackbar.snackbar(context, getTranslated('VERIFICATION_CODE_SENT'),
          '', ColorResources.success);
      NS.pushDefault(context, const NewPasswordScreen());
      setStateForgetPasswordStatus(ForgetPasswordStatus.success);
      notifyListeners();
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      NetworkException.handle(context, e.toString());
      setStateForgetPasswordStatus(ForgetPasswordStatus.error);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      setStateForgetPasswordStatus(ForgetPasswordStatus.error);
      notifyListeners();
    }
  }
}
