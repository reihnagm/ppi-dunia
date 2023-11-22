import 'package:flutter/material.dart';
import 'package:ppidunia/data/models/maintenance/demo.dart';
import 'package:ppidunia/data/models/maintenance/maintenance.dart';
import 'package:ppidunia/data/repository/maintenance/maintenance.dart';
import 'package:ppidunia/utils/exceptions.dart';
import 'package:ppidunia/utils/shared_preferences.dart';
import 'package:ppidunia/views/screens/auth/sign_in/sign_in_state.dart';
import 'package:ppidunia/views/screens/comingsoon/comingsoon_state.dart';
import 'package:ppidunia/views/screens/dashboard/dashboard_state.dart';
import 'package:ppidunia/views/screens/onboarding/onboarding_state.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/screens/update/update_state.dart';

enum DemoStatus { loading, loaded, error, idle }
DemoStatus _demoStatus = DemoStatus.idle;
bool? _isDemo;

enum MaintenanceStatus { loading, loaded, error, idle }
MaintenanceStatus _maintenanceStatus = MaintenanceStatus.idle;
bool? _isMaintenance;

abstract class SplashScreenModelData {
  Future<void> getMaintenanceStatus(BuildContext context);
  void setStateMaintenanceStatus(MaintenanceStatus status);
  Future<void> getDemoStatus(BuildContext context);
  void setStateDemoStatus(DemoStatus status);
}

class SplashScreenModel with ChangeNotifier implements SplashScreenModelData {
  final MaintenanceRepo mr;
  SplashScreenModel({
    required this.mr,
  });
  
  DemoStatus get demoStatus => _demoStatus;
  bool? get isDemo => _isDemo;
  
  bool? get isMaintenance => _isMaintenance;
  MaintenanceStatus get maintenanceStatus => _maintenanceStatus;

  late List<String> _languageList;
  final int _languageIndex = 0;

  List<String> get languageList => _languageList;
  int get languageIndex => _languageIndex;
  
  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'com.inovatif78.ppidunia',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  final NewVersionPlus _newVersion = NewVersionPlus(
    androidId: 'com.inovatif78.ppidunia',
    iOSId: 'com.inovatif78.ppidunia'
  );

  Future<void> initPackageInfo() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    packageInfo = info;
    notifyListeners();
  }

  Future<void> getData(BuildContext context) async {
    Future.delayed(Duration.zero, () async {
      VersionStatus? vs = await _newVersion.getVersionStatus();
      if(vs!.canUpdate) {
        NS.pushReplacement(context, const UpdateScreen());
      } 
    });
    //TODO: tunggu apinya
    // Future.wait([
    //   getMaintenanceStatus(context),
    //   getDemoStatus(context),
    // ]);
  }

  Future<bool> _initConfig() {
    _languageList = ['English', 'Indonesia'];
    Future.delayed(Duration.zero, () => notifyListeners());
    return Future.value(true);
  }

  bool isSkipOnboarding() {
    return SharedPrefs.isSkipOnboarding();
  }
  
  void dispatchOnboarding(bool onboarding) {
    SharedPrefs.setOnboarding(onboarding);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void navigateScreen(BuildContext context) {
    Future.delayed(Duration.zero, () {
      _initConfig().then((_) {
        if (isMaintenance == true){
          NS.pushReplacement(
            context,
            const ComingSoonScreen(isMaintenance: true, isNavbarItem: true),
          );
        } else if (isSkipOnboarding()) {
          if (SharedPrefs.isLoggedIn()) {
            NS.pushReplacement(context, const DashboardScreen());
          } else {
            NS.pushReplacementDefault(context, const SignInScreen());
          }
        } else {
          NS.pushReplacementDefault(context, const OnboardingScreen());
        }
      });
    });
  }

  @override
  void setStateDemoStatus(DemoStatus demoStatus) {
    _demoStatus = demoStatus;
    Future.delayed(Duration.zero, () =>  notifyListeners());
  }

  @override
  Future<void> getDemoStatus(BuildContext context) async {
    setStateDemoStatus(DemoStatus.loading);
    try {
      DemoModel? mm = await mr.getDemoStatus(context);
      _isDemo = mm?.data?.showDemo;
      debugPrint('isDemo = $isDemo');
      setStateDemoStatus(DemoStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      // CustomDialog.showUnexpectedError(context, errorCode: 'MR02');
      NetworkException.handle(context, e.toString());
      setStateDemoStatus(DemoStatus.error);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      // CustomDialog.showUnexpectedError(context, errorCode: 'MP01');
      setStateDemoStatus(DemoStatus.error);
    }
  }

  @override
  void setStateMaintenanceStatus(MaintenanceStatus maintenanceStatus) {
    _maintenanceStatus = maintenanceStatus;
    Future.delayed(Duration.zero, () =>  notifyListeners());
  }

  @override
  Future<void> getMaintenanceStatus(BuildContext context) async {
    setStateMaintenanceStatus(MaintenanceStatus.loading);
    try {
      MaintenanceModel? mm = await mr.getMaintenanceStatus(context);
      _isMaintenance = mm?.data?.maintenance;
      debugPrint(isMaintenance.toString());
      setStateMaintenanceStatus(MaintenanceStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      NetworkException.handle(context, e.toString());
      // CustomDialog.showUnexpectedError(context, errorCode: 'MR01');
      setStateMaintenanceStatus(MaintenanceStatus.error);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      // CustomDialog.showUnexpectedError(context, errorCode: 'SP01');
      setStateMaintenanceStatus(MaintenanceStatus.error);
    }
  }

}