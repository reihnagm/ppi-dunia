import 'package:flutter/material.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/views/screens/auth/sign_up/third_step_screen/otp_screen_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/utils/custom_themes.dart';
import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/dimensions.dart';

class ChangeEmailBottomsheetWidget extends StatelessWidget {
  final TextEditingController emailC;
  final Size screenSize; 
  final ScrollController scrollC;

  const ChangeEmailBottomsheetWidget({super.key, required this.screenSize, required this.emailC, required this.scrollC});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorResources.primaryBottomSheet,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: ColorResources.black.withOpacity(0.6), blurRadius: 20.0,)],
      ),
      child: Consumer<OtpScreenModel>(
        builder: (context, viewModel, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => viewModel.submitChangeEmail(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(getTranslated('SUBMIT'),
                        style: sfProRegular.copyWith(
                          color: ColorResources.primaryButton,
                          fontSize: Dimensions.fontSizeLarge,
                        ),
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: emailC,
                  inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter,
                  ],
                  style: sfProRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: ColorResources.fillPrimary.withOpacity(0.5),
                    prefixIcon: const Icon(Icons.email,
                      color: ColorResources.hintColor,
                      size: Dimensions.iconSizeLarge,
                    ),
                    hintText: 'Example: user@mail.com',
                    hintStyle: sfProRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: ColorResources.hintColor,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: ColorResources.transparent)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: ColorResources.transparent)
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(viewModel.changeEmailError,
                    style: sfProRegular.copyWith(
                      color: ColorResources.error,
                    ),
                  ),
                )
              ],
            ),
          );
        }
      ),
      );
    }
  }