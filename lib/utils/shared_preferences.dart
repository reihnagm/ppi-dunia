import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ppidunia/data/models/auth/user.dart';
import 'package:ppidunia/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  
  static SharedPreferences? _instance;
  
  static Future initSharedPreferences() async {
    _instance = await SharedPreferences.getInstance();
  }

  static void clear() {
    _instance!.clear();
  }

  static bool isSkipOnboarding() {
    return _instance!.getBool("onboarding") == null ? false : true;
  }
  static void setOnboarding(bool value) {
    _instance!.setBool('onboarding', value);
  }

  static double getLat() {
    return _instance!.getDouble('lat') ?? 0.0;
  }
  static double getLng() {
    return _instance!.getDouble('lng') ?? 0.0;
  }
  static void writeLatLng(double lat, double lng){
    _instance!.setDouble("lat", lat);
    _instance!.setDouble("lng", lng);
  }
  static String? getRegFistName() {
    return _instance!.getString('reg_firstname');
  }
  static String? getRegLastName() {
    return _instance!.getString('reg_lastname');
  }
  static String getRegEmail() {
    return _instance!.getString('reg_email') ?? "-";
  }
  static void writeRegEmail(String? value) {
    _instance!.setString('reg_email', value ?? "-");
  }
  static String? getRegPassword() {
    return _instance!.getString('reg_password');
  }
  static String? getRegCountryId() {
    return _instance!.getString('reg_country_id');
  }
  static String getCurrentNameAddress() {
    return _instance!.getString("currentNameAddress") ?? "Lokasi tidak ditemukan";
  }
  static void writeRegCountryId(String? value) {
    _instance!.setString('reg_country_id', value ?? "19021987-fa82-4de8-82aa-ad6f8d55977f");
  }
  static void writeCurrentAddress(String address){
    _instance!.setString("currentNameAddress", address);
  }
  static void writeRegisterData({required Data authData, required String password}) {
    _instance!.setString("reg_userid", authData.user?.id ?? "-");
    _instance!.setString("reg_firstname", authData.user?.firstName ?? "-");
    _instance!.setString("reg_lastname", authData.user?.lastName ?? "-");
    _instance!.setString("reg_email", authData.user?.email ?? "-");
    _instance!.setString("reg_password", password);
  }
  static Object getRegisterObject() {
    Object data = {
      "user_id": _instance!.get("reg_userid"),
      "country_id": _instance!.get("reg_country_id"),
      "first_name": _instance!.getString("reg_firstname"),
      "last_name": _instance!.getString("reg_lastname"),
      "email": _instance!.getString("reg_email"),
      "password": _instance!.getString("reg_password"),
    };
    return data;
  }
  static void deleteIfUserRegistered() {
    _instance!.remove("reg_userid");
    _instance!.remove("reg_firstname");
    _instance!.remove("reg_lastname");
    _instance!.remove("reg_email");
    _instance!.remove("reg_password");
    _instance!.remove("reg_country_id");
  }

  static String getLanguageCode() {
    return _instance!.getString(AppConstants.languageCode) ?? 'en';
  }
  static String getCountryCode() {
    return _instance!.getString(AppConstants.countryCode) ?? 'US';
  }
  static void saveLanguagePrefs(Locale locale) {
    _instance!.setString(AppConstants.languageCode, locale.languageCode);
    _instance!.setString(AppConstants.countryCode, locale.countryCode!);
  }
  
  static String getForgetEmail() {
    return _instance!.getString('forget_email')!;
  }
  static void writeForgetEmail(String email) {
    _instance!.setString("forget_email", email);
  }
  static void removeForgets() {
    _instance!.remove('forget_email');
  }
  static String getEmailOTP() {
    return _instance!.getString('email_otp') ?? "-";
  }
  static void writeEmailOTP(String? email) {
    _instance!.setString('email_otp', email ?? "-");
  }
  static void removeEmailOTP() {
    _instance!.remove('email_otp');
  }
  static void writeChangeEmailData(String email) {
    _instance!.setString("email_otp", email);
    _instance!.setString("reg_email", email);
  }
  static bool isLoggedIn() {
    return _instance!.containsKey("token");
  }
  static String getUserToken() {
    return _instance!.getString("token") ?? "-";
  }
  static void writeAuthData(Data authData) {
    _instance!.setString("auth", json.encode({
      "token": authData.token,
      "refreshToken": authData.refreshToken,
      "id": authData.user!.id,
      "first_name": authData.user!.firstName,
      "last_name": authData.user!.lastName,
      "email": authData.user!.email,
      "role": authData.user!.role,
    }));
  }
  static void writeAuthToken() {
    Map<String, dynamic> prefs = json.decode(_instance!.getString("auth")!);
    _instance!.setString("token", prefs["token"]);
    _instance!.setString("refreshToken", prefs["refreshToken"]);
  }

  static String getUserlastName() {
    Map<String, dynamic> prefs = json.decode(_instance!.getString("user")!);
    return prefs["first_name"] ?? "-";
  }
  static String getUserLastName() {
    Map<String, dynamic> prefs = json.decode(_instance!.getString("user")!);
    return prefs["last_name"] ?? "-";
  }
  static String getUserEmail() {
    Map<String, dynamic> prefs = json.decode(_instance!.getString("auth")!);
    return prefs["email"] ?? "-";
  }
  static String getUserId() {
    Map<String, dynamic> prefs = json.decode(_instance!.getString("auth")!);
    return prefs["id"] ?? "-";
  }
  static bool? getUserFulfilledDataStatus() {
    Map<String, dynamic> prefs = json.decode(_instance!.getString("user")!);
    return prefs["fulfilled_data"] ?? "-";
  }
  //TODO: tunggu api profile.
  // static void writeUserData(UserData user) {
  //   _instance!.setString("user", json.encode({
  //       "id": user.id,
  //       "email": user.email,
  //       "email_activated": user.emailActivated,
  //       "first_name": user.firstName,
  //       "last_name": user.lastName,
  //       "role": user.role,
  //   }));
  // }

  static void deleteData() {
    _instance!.remove("auth");
    _instance!.remove("user");
    _instance!.remove("token");
    _instance!.remove("refreshToken");
    deleteIfUserRegistered();
    removeEmailOTP();
    removeForgets();
  }

}