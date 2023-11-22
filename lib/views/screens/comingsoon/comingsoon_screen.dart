import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/custom_themes.dart';
import 'package:ppidunia/utils/dimensions.dart';
import 'package:ppidunia/views/basewidgets/background/grey.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/views/screens/comingsoon/comingsoon_screen_model.dart';
import 'package:ppidunia/views/screens/comingsoon/comingsoon_state.dart';

class ComingSoonScreenState extends State<ComingSoonScreen> {
  late ComingSoonScreenModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = context.read<ComingSoonScreenModel>();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI(context);
  }

  Widget buildUI(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: GreyBackgroundWidget(
          screenSize: screenSize,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: Image.asset("assets/images/avatar/avatar-comingsoon.png",
                      height: 300,
                      width: 300,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Text(widget.isMaintenance == true ? 'Maintenance' : 'Coming Soon',
                    style: sfProRegular.copyWith(
                      color: ColorResources.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.fontSizeTitle,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Text(widget.isMaintenance == true 
                      ? getTranslated('MAINTENANCE')
                      : getTranslated('UNDER_DEVELOPMENT'),
                      style: sfProRegular.copyWith(
                        color: ColorResources.white.withOpacity(0.6),
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  widget.isNavbarItem == true
                  ? const SizedBox.shrink()
                  : Padding(
                    padding: const EdgeInsets.only(top: 75.0),
                    child: CustomButton(
                        onTap: () {
                          NS.pop(context);
                        }, 
                        btnTxt: getTranslated('BACK'),
                        isBorderRadius: true,
                      ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}