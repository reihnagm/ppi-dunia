import 'package:flutter/material.dart';
import 'package:ppidunia/views/basewidgets/credits/credits_widget.dart';

class AuthColumnWidget extends StatelessWidget {
  const AuthColumnWidget({
    super.key,
    required this.screenSize, required this.top, required this.content, required this.bottom,
    this.contentHeight = 0.45,
  });

  final Size screenSize;
  final double contentHeight;
  final Widget top;
  final Widget content;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 45.0),
            child: Column(
              children: [
                CreditsWidget(screenSize: screenSize),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: top,
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenSize.height * contentHeight,
            child: content,
          ),
          bottom,
        ],
      ),
    );
  }
}