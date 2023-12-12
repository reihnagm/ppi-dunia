import 'package:flutter/material.dart';
import 'package:ppidunia/features/auth/data/repositories/auth.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/second_step_screen/study_abroad_status_state.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/common/extensions/snackbar.dart';
import 'package:ppidunia/views/basewidgets/textfield/textfield.dart';

enum RegisterStatus { idle, loading, success, error }

RegisterStatus _registerStatus = RegisterStatus.idle;

abstract class SignUpScreenModelData {
  void setStateRegisterStatus(RegisterStatus status);
  Future<void> register(
    BuildContext context, {
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });
}

class SignUpScreenModel with ChangeNotifier implements SignUpScreenModelData {
  final AuthRepo ar;

  SignUpScreenModel({
    required this.ar,
  });

  RegisterStatus get registerStatus => _registerStatus;

  TextEditingController firstNameC = TextEditingController();
  TextEditingController lastNameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();

  FocusNode firstNameFn = FocusNode();
  FocusNode lastNameFn = FocusNode();
  FocusNode emailFn = FocusNode();
  FocusNode passwordFn = FocusNode();
  FocusNode confirmPasswordFn = FocusNode();

  void resetControllerValue() {
    firstNameC.clear();
    lastNameC.clear();
    emailC.clear();
    passwordC.clear();
    confirmPasswordC.clear();
  }

  bool submissionValidation(
    BuildContext context,
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) {
    if (firstName.isEmpty) {
      ShowSnackbar.snackbar(
          context, getTranslated('FIRST_NAME_EMPTY'), '', ColorResources.error);
      firstNameFn.requestFocus();
      return false;
    } else if (lastName.isEmpty) {
      ShowSnackbar.snackbar(
          context, getTranslated('LAST_NAME_EMPTY'), '', ColorResources.error);
      lastNameFn.requestFocus();
      return false;
    } else if (email.isEmpty) {
      ShowSnackbar.snackbar(
          context, getTranslated('EMAIL_EMPTY'), '', ColorResources.error);
      emailFn.requestFocus();
      return false;
    } else if (!email.isValidEmail()) {
      ShowSnackbar.snackbar(context, getTranslated('INVALID_FORMAT_EMAIL'), '',
          ColorResources.error);
      emailFn.requestFocus();
      return false;
    } else if (password.isEmpty) {
      ShowSnackbar.snackbar(
          context, getTranslated('PASSWORD_EMPTY'), '', ColorResources.error);
      passwordFn.requestFocus();
      return false;
    } else if (confirmPassword.isEmpty) {
      ShowSnackbar.snackbar(context, getTranslated('CONFIRM_PASSWORD_EMPTY'),
          '', ColorResources.error);
      confirmPasswordFn.requestFocus();
      return false;
    } else if (password != confirmPassword) {
      ShowSnackbar.snackbar(context, getTranslated('INVALID_PASSWORD_INPUT'),
          '', ColorResources.error);
      passwordFn.requestFocus();
      return false;
    } else if (confirmPassword != password) {
      ShowSnackbar.snackbar(
          context,
          getTranslated('INVALID_CONFIRM_PASSWORD_INPUT'),
          '',
          ColorResources.error);
      confirmPasswordFn.requestFocus();
      return false;
    }
    return true;
  }

  void submitControllerValue(BuildContext context) {
    final firstName = firstNameC.text.trim();
    final lastName = lastNameC.text.trim();
    final email = emailC.text.trim();
    final password = passwordC.text.trim();
    final confirmPassword = confirmPasswordC.text.trim();

    final isClear = submissionValidation(
        context, firstName, lastName, email, password, confirmPassword);
    if (isAgree && isClear) {
      register(context,
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName);
    }
    notifyListeners();
  }

  bool isAgree = false;

  void toggleAgreement(bool? value) {
    isAgree = value ?? false;
    notifyListeners();
  }

  void resetAgreement() {
    isAgree = false;
    notifyListeners();
  }

  @override
  void setStateRegisterStatus(RegisterStatus status) {
    _registerStatus = status;
    notifyListeners();
  }

  @override
  Future<void> register(BuildContext context,
      {required String email,
      required String password,
      required String firstName,
      required String lastName}) async {
    setStateRegisterStatus(RegisterStatus.loading);
    try {
      SharedPrefs.writeEmailOTP(email);
      SharedPrefs.writeRegisterData(
        password: password,
        firstName: firstName,
        lastName: lastName,
        email: email,
      );
      NS.pushDefault(context, const StudyAbroadStatusScreen());
      setStateRegisterStatus(RegisterStatus.success);
      notifyListeners();
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      NetworkException.handle(context, e.toString());
      setStateRegisterStatus(RegisterStatus.error);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      setStateRegisterStatus(RegisterStatus.error);
      notifyListeners();
    }
  }
}
