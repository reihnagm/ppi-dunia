import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/custom_themes.dart';
import 'package:ppidunia/views/basewidgets/checkbox/custom_checkbox.dart';
import 'package:ppidunia/views/screens/legality/privacy_policy/privacy_policy_state.dart';
import 'package:ppidunia/views/screens/legality/terms_of_use/terms_of_use_state.dart';
import 'package:provider/provider.dart';
import 'package:ppidunia/views/screens/auth/sign_up/first_step_screen/sign_up_screen_model.dart';

class CheckboxAgreement extends StatelessWidget {
  const CheckboxAgreement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpScreenModel>(
      builder: (context, model, _) {
        return Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: CustomCheckbox(
            checkboxValue: model.isAgree,
            onChanged: model.toggleAgreement,
            widget: RichText(
              softWrap: true,
              text: TextSpan(
                children: [
                  TextSpan(text: getTranslated("REGISTER_AGREEMENT_1")),
                  TextSpan(text: ' '+getTranslated("TERM_OF_USE"),
                    style: sfProRegular.copyWith(
                      color: ColorResources.primaryButton,
                    ),
                    recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      NS.pushDefault(context, const TermsOfUseScreen());
                    },
                  ),
                  TextSpan(text: ' '+getTranslated("REGISTER_AGREEMENT_2")),
                  TextSpan(text: ' '+getTranslated("OUR_PRIVACY_POLICY")+".",
                    style: sfProRegular.copyWith(
                      color: ColorResources.primaryButton,
                    ),
                    recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      NS.pushDefault(context, const PrivacyPolicyScreen());
                    },
                  ),
                ]
              ),
            ),
          ),
        );
      }
    );
  }
}