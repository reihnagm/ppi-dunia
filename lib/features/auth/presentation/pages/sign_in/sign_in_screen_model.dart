import 'package:flutter/material.dart';
import 'package:ppidunia/features/auth/data/models/user.dart';
import 'package:ppidunia/features/auth/data/repositories/auth.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/common/extensions/snackbar.dart';
import 'package:ppidunia/views/basewidgets/textfield/textfield.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/third_step_screen/otp_state.dart';
import 'package:ppidunia/features/dashboard/presentation/pages/dashboard_state.dart';

enum LoginStatus { idle, loading, success, error }

LoginStatus _loginStatus = LoginStatus.idle;

abstract class SignInScreenModelData {
  void setStateLoginStatus(LoginStatus status);
  Future<void> login(BuildContext context,
      {required String email, required String password});
}

class SignInScreenModel with ChangeNotifier implements SignInScreenModelData {
  final AuthRepo ar;

  SignInScreenModel({
    required this.ar,
  });

  LoginStatus get loginStatus => _loginStatus;

  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  FocusNode emailFn = FocusNode();
  FocusNode passwordFn = FocusNode();

  void resetSignIn() {
    emailC.clear();
    passwordC.clear();
    notifyListeners();
  }

  bool submissionValidation(
      BuildContext context, String email, String password) {
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
    } else if (password.isEmpty) {
      ShowSnackbar.snackbar(
          context, getTranslated('PASSWORD_EMPTY'), '', ColorResources.error);
      passwordFn.requestFocus();
      return false;
    }
    return true;
  }

  void submitControllerValue(BuildContext context) {
    final email = emailC.text.trim();
    final password = passwordC.text.trim();

    final bool isClear = submissionValidation(context, email, password);
    if (isClear) {
      login(context, email: email, password: password);
    }

    notifyListeners();
  }

  @override
  void setStateLoginStatus(LoginStatus status) {
    _loginStatus = status;
    notifyListeners();
  }

  @override
  Future<void> login(BuildContext context,
      {required String email, required String password}) async {
    setStateLoginStatus(LoginStatus.loading);
    try {
      UserModel um = await ar.login(email: email, password: password);
      Data authData = um.data!;
      SharedPrefs.writeAuthData(authData);
      SharedPrefs.writeEmailOTP(authData.user?.email);
      if (authData.user?.emailActivated == true) {
        SharedPrefs.removeEmailOTP();
        SharedPrefs.deleteIfUserRegistered();
        SharedPrefs.writeAuthToken();
        NS.pushReplacementDefault(context, const DashboardScreen());
        setStateLoginStatus(LoginStatus.success);
      } else {
        SharedPrefs.writeRegEmail(authData.user?.email);
        NS.pushReplacementDefault(context, const OtpScreen());
        setStateLoginStatus(LoginStatus.idle);
      }
      resetSignIn();
      setStateLoginStatus(LoginStatus.idle);
      notifyListeners();
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      NetworkException.handle(context, e.toString());
      setStateLoginStatus(LoginStatus.error);
      notifyListeners();
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      setStateLoginStatus(LoginStatus.error);
      notifyListeners();
    }
  }
}
