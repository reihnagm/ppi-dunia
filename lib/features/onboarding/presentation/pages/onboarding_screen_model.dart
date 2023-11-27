import 'package:flutter/material.dart';

class OnboardingScreenModel with ChangeNotifier {
  bool _isChangeContent = true;
  bool get isChangeContent => _isChangeContent;

  void setChangeContent() {
    Future.delayed(const Duration(seconds: 4), () {
      _isChangeContent = !_isChangeContent;
      notifyListeners();
    });
  }
}
