import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/custom_themes.dart';
import 'package:ppidunia/common/utils/dimensions.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(r"[a-zA-Z0-9_]+@[a-zA-Z]+\.(com|net|org)$").hasMatch(this);
  }
}

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String emptyText;
  final bool isPrefixIcon;
  final Widget? prefixIcon;
  final bool isSuffixIcon;
  final Widget? suffixIcon;
  final String? labelText;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final TextInputType textInputType;
  final int maxLines;
  final FocusNode focusNode;
  final FocusNode? nextNode;
  final TextInputAction textInputAction;
  final Color counterColor;
  final bool isPhoneNumber;
  final bool isEmail;
  final bool isPassword;
  final bool isName;
  final bool isAlphabetsAndNumbers;
  final bool isBorder;
  final bool isBorderRadius;
  final bool readOnly;
  final bool isEnabled;
  final int? maxLength;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.isPrefixIcon = false,
    this.prefixIcon,
    this.isSuffixIcon = false,
    this.suffixIcon,
    required this.hintText,
    required this.emptyText,
    this.labelText,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    required this.textInputType,
    this.counterColor = ColorResources.white,
    required this.focusNode,
    this.nextNode,
    required this.textInputAction,
    this.maxLines = 1,
    this.isEmail = false,
    this.isPassword = false,
    this.isName = false,
    this.isAlphabetsAndNumbers = false,
    this.isBorder = true,
    this.isBorderRadius = false,
    this.readOnly = false,
    this.isEnabled = true,
    this.maxLength,
    this.isPhoneNumber = false,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: widget.maxLines,
      focusNode: widget.focusNode,
      keyboardType: widget.textInputType,
      maxLength: widget.maxLength,
      readOnly: widget.readOnly,
      textCapitalization: TextCapitalization.sentences,
      validator: (value) {
        if (value == null || value.isEmpty) {
          widget.focusNode.requestFocus();
          return widget.emptyText;
        }
        return null;
      },
      enableInteractiveSelection: true,
      enabled: widget.isEnabled,
      textInputAction: widget.textInputAction,
      obscureText: widget.isPassword ? obscureText : false,
      style: sfProRegular.copyWith(
        fontSize: Dimensions.fontSizeLarge,
      ),
      onFieldSubmitted: (String v) {
        setState(() {
          widget.textInputAction == TextInputAction.done
              ? FocusScope.of(context).consumeKeyboardToken()
              : FocusScope.of(context).requestFocus(widget.nextNode);
        });
      },
      inputFormatters: widget.isAlphabetsAndNumbers
          ? [
              FilteringTextInputFormatter.singleLineFormatter,
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 ]')),
            ]
          : widget.isName
              ? [
                  UpperCaseTextFormatter(),
                  FilteringTextInputFormatter.singleLineFormatter,
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                ]
              : widget.isEmail
                  ? [
                      FilteringTextInputFormatter.singleLineFormatter,
                    ]
                  : [
                      FilteringTextInputFormatter.singleLineFormatter,
                    ],
      decoration: InputDecoration(
        fillColor: widget.isEnabled
            ? ColorResources.transparent
            : ColorResources.white,
        filled: true,
        isDense: true,
        prefixIcon: widget.isPrefixIcon ? widget.prefixIcon : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: toggle,
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: ColorResources.white,
                  size: 18.0,
                ),
              )
            : widget.isSuffixIcon
                ? widget.suffixIcon
                : null,
        counterText: "",
        counterStyle: sfProRegular.copyWith(
            color: widget.counterColor, fontSize: Dimensions.fontSizeLarge),
        floatingLabelBehavior: widget.floatingLabelBehavior,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        hintText: widget.hintText,
        hintStyle: sfProRegular.copyWith(
          color: Colors.grey,
          fontSize: Dimensions.fontSizeSmall,
          fontWeight: FontWeight.w500,
        ),
        labelText: widget.labelText,
        labelStyle: sfProRegular.copyWith(
          fontSize: Dimensions.paddingSizeLarge,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: ColorResources.white,
              width: 1.0,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: ColorResources.white,
              width: 1.0,
            )),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}
