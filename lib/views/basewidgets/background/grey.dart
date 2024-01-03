import 'package:flutter/material.dart';
import 'package:ppidunia/common/consts/assets_const.dart';

class GreyBackgroundWidget extends StatelessWidget {
  const GreyBackgroundWidget({
    super.key,
    required this.screenSize,
    required this.child,
  });

  final Size screenSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenSize.height,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetsConst.imageBackgroundPlain),
          fit: BoxFit.fill,
        ),
      ),
      child: child,
    );
  }
}
