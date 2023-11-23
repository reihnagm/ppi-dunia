import 'package:flutter/material.dart';

class HexToColorHelper {
  static Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
    return Color(int.parse('0x$alphaChannel$hexString'));
  }
}
