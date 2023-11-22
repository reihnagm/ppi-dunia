import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

//TODO: kalau ada dependencies yang mau dimock tulis disini
// nanti jalanin "dart run build_runner build atau flutter pub run build_runner build" di terminal
@GenerateMocks([
  BuildContext,
  SharedPreferences,
  Dio,
])
void main() {}
