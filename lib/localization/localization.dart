import 'package:flutter/material.dart';
import 'package:ppidunia/common/consts/api_const.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';

class LocalizationProvider extends ChangeNotifier {

  LocalizationProvider() {
    _loadCurrentLanguage();
    _checkLanguage();
  }

  Locale _locale = const Locale('en', 'US');
  final bool _isLtr = true;
  late int _languageIndex;

  bool _isIndonesian = false;
  bool get isIndonesian => _isIndonesian;

  bool _isEnglish = false;
  bool get isIEnglish => _isEnglish;

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  int get languageIndex => _languageIndex;

  void setLanguage(Locale locale) {
    if(locale.languageCode == 'en'){
      _locale = const Locale('en', 'US');
    }else {
      _locale = const Locale('id', 'ID');
    }
    for (var language in ApiConsts.languages) {
      if(language.languageCode == _locale.languageCode) {
        _languageIndex = ApiConsts.languages.indexOf(language);
      }
    }
    _saveLanguage(_locale);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void _loadCurrentLanguage() async {
    _locale = Locale(SharedPrefs.getLanguageCode(), SharedPrefs.getCountryCode());
    for (var language in ApiConsts.languages) {
      if(language.languageCode == _locale.languageCode) {
        _languageIndex = ApiConsts.languages.indexOf(language);
      }
    }
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void _checkLanguage() {
    if(SharedPrefs.getLanguageCode() == "id") {
      _isIndonesian = true;
      _isEnglish = false;
    } else {
      _isEnglish = true;
      _isIndonesian = false;
    }
    Future.delayed(Duration.zero, () => notifyListeners());
  }
  
  void toggleLanguage() {
    _isIndonesian = !_isIndonesian;
    if(_isIndonesian) {
      _isIndonesian = true;
      _isEnglish = false;
      setLanguage(Locale(
        ApiConsts.languages[0].languageCode!,
        ApiConsts.languages[0].countryCode,
      ));
    } else {
      _isIndonesian = false;
      _isEnglish = true;
      setLanguage(Locale(
        ApiConsts.languages[1].languageCode!,
        ApiConsts.languages[1].countryCode,
      ));
    }
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void _saveLanguage(Locale locale) async {
    SharedPrefs.saveLanguagePrefs(locale);
  }
}