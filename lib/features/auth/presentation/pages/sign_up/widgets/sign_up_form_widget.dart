import 'package:flutter/material.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/widgets/checkbox_agreement_widget.dart';
import 'package:ppidunia/views/basewidgets/textfield/textfield.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/first_step_screen/sign_up_screen_model.dart';

class SignUpFormWidget extends StatelessWidget {
  const SignUpFormWidget({
    super.key,
    required this.viewModel,
  });

  final SignUpScreenModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 8,
                child: CustomTextField(
                  labelText: getTranslated('FIRST_NAME'),
                  isName: true,
                  controller: viewModel.firstNameC,
                  hintText: getTranslated('FIRST_NAME_HINT'),
                  emptyText: getTranslated('FIRST_NAME_EMPTY'),
                  textInputType: TextInputType.name,
                  focusNode: viewModel.firstNameFn,
                  nextNode: viewModel.lastNameFn,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const Flexible(child: SizedBox()),
              Expanded(
                flex: 8,
                child: CustomTextField(
                  labelText: getTranslated('LAST_NAME'),
                  isName: true,
                  controller: viewModel.lastNameC,
                  hintText: getTranslated('LAST_NAME_HINT'),
                  emptyText: getTranslated('LAST_NAME_EMPTY'),
                  textInputType: TextInputType.name,
                  focusNode: viewModel.lastNameFn,
                  nextNode: viewModel.emailFn,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Hero(
              tag: 'email-pw',
              child: Material(
                type: MaterialType.transparency,
                child: Wrap(
                  children: [
                    CustomTextField(
                      labelText: 'Email',
                      isEmail: true,
                      controller: viewModel.emailC,
                      hintText: getTranslated('EMAIL_HINT'),
                      emptyText: getTranslated('EMAIL_EMPTY'),
                      textInputType: TextInputType.emailAddress,
                      focusNode: viewModel.emailFn,
                      nextNode: viewModel.passwordFn,
                      textInputAction: TextInputAction.next,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: CustomTextField(
                        labelText: getTranslated('PASSWORD'),
                        isPassword: true,
                        controller: viewModel.passwordC,
                        hintText: getTranslated('PASSWORD_HINT'),
                        emptyText: getTranslated('PASSWORD_EMPTY'),
                        textInputType: TextInputType.text,
                        focusNode: viewModel.passwordFn,
                        nextNode: viewModel.confirmPasswordFn,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CustomTextField(
            labelText: getTranslated('CONFIRM_PASSWORD'),
            isPassword: true,
            controller: viewModel.confirmPasswordC,
            hintText: getTranslated('CONFIRM_PASSWORD_HINT'),
            emptyText: getTranslated('CONFIRM_PASSWORD_EMPTY'),
            textInputType: TextInputType.text,
            focusNode: viewModel.confirmPasswordFn,
            textInputAction: TextInputAction.done,
          ),
          const CheckboxAgreement(),
        ],
      ),
    );
  }
}
