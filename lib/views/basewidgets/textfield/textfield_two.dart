
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:intl/intl.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/custom_themes.dart';
import 'package:ppidunia/common/utils/dimensions.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(this);
  }
}

class CustomTextFieldV2 extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPrefixIcon; 
  final Widget? prefixIcon;
  final bool isSuffixIcon;
  final Widget? suffixIcon;
  final String? labelText;
  final String? emptyWarning;
  final Widget? label;
  final bool? alignLabelWithHint;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final TextInputType textInputType;
  final int maxLines;
  final Function? onChange;
  final Function? validator;
  final bool? isDatePicker;
  final bool? isProvince;
  final bool? isCity;
  final bool? isBloodType;
  final bool? isPriceInput;
  final bool? isPriceInputBank;
  final FocusNode focusNode;
  final FocusNode? nextNode;
  final TextInputAction textInputAction;
  final Color counterColor;
  final bool isPhoneNumber;
  final bool isEmail;
  final bool isPassword;
  final bool isBorder;
  final bool isBorderRadius;
  final bool readOnly;
  final bool isEnabled;
  final bool isWhiteBackground;
  final int? maxLength;

  const CustomTextFieldV2({
    Key? key, 
    required this.controller,
    required this.emptyWarning,
    this.isPrefixIcon = false,
    this.prefixIcon,
    this.isSuffixIcon = false,
    this.suffixIcon,
    required this.hintText,
    this.alignLabelWithHint = false,
    this.labelText,
    this.label = const SizedBox(),
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    required this.textInputType,
    this.counterColor = ColorResources.white,
    this.onChange,
    this.validator,
    this.isDatePicker,
    this.isPriceInput,
    this.isPriceInputBank,
    this.isCity,
    this.isProvince,
    this.isBloodType = false,
    required this.focusNode,
    this.nextNode,
    required this.textInputAction,
    this.maxLines = 1,
    this.isEmail = false,
    this.isPassword = false,
    this.isBorder = true,
    this.isBorderRadius = false,
    this.readOnly = false,
    this.isEnabled = true,
    this.maxLength,
    this.isPhoneNumber = false,
    this.isWhiteBackground = true,
  }) : super(key: key);

  @override
  State<CustomTextFieldV2> createState() => _CustomTextFieldV2State();
}

class _CustomTextFieldV2State extends State<CustomTextFieldV2> {
  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(context) {
    return Material(
      color: ColorResources.transparent,
      borderRadius: BorderRadius.circular(15.0),
      child: TextFormField(
        controller: widget.controller,
        maxLines: widget.maxLines,
        focusNode: widget.focusNode,
        keyboardType: widget.textInputType,
        maxLength: widget.maxLength,
        readOnly: widget.readOnly,
        onChanged: (val) { 
          widget.onChange!(val);
        },
        onTap: () {
          widget.isDatePicker == true ? showDatePicker() : setState(() {});
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            widget.focusNode.requestFocus();
            return widget.emptyWarning;
          }
          if (widget.isPhoneNumber) {
            if (value.length < 10) {
              widget.focusNode.requestFocus();
              return "Nomor telepon minimal 10 digit.";
            }
          }
          if (widget.hintText == "KTP") {
            if (value.length < 16) {
              widget.focusNode.requestFocus();
              return "KTP minimal 16 digit";
            }
          }
          if (widget.hintText == "NPK") {
            if (value.length < 7) {
              widget.focusNode.requestFocus();
              return "NPK minimal 7 digit";
            }
          }
          if (widget.isPriceInput == true) {
            int valueInt = int.parse(value.replaceAll(',', ''));
            if (valueInt < 500000) {
              widget.controller.text = "500,000";
              widget.focusNode.requestFocus();
              return "Nominal paling rendah adalah 500.000";
            }
            if (valueInt > 5000000) {
              widget.controller.text = "5,000,000";
              widget.focusNode.requestFocus();
              return "Nominal paling tinggi adalah 5.000.000";
            }
          }
          if(widget.isPriceInputBank == true ) {
            int valueInt = int.parse(value.replaceAll(',', ''));
            if (valueInt < 10000000) {
              widget.controller.text = "10,000,000";
              widget.focusNode.requestFocus();
              return "Nominal paling rendah adalah 10,000.000";
            }
            if (valueInt > 100000000) {
              widget.controller.text = "100,000,000";
              widget.focusNode.requestFocus();
              return "Nominal paling tinggi adalah 100.000.000";
            }
          }            
          return null;
        },
        textCapitalization: widget.isEmail == true || widget.isPassword == true 
          ? TextCapitalization.none
          : widget.isBloodType == true
            ? TextCapitalization.characters
            : TextCapitalization.sentences,
        enableInteractiveSelection: true,
        enabled: widget.isEnabled,
        textInputAction: widget.textInputAction,
        obscureText: widget.isPassword 
        ? obscureText 
        : false,
        style: sfProRegular.copyWith(
          fontSize: Dimensions.fontSizeLarge,
          color: ColorResources.black,
        ),
        onFieldSubmitted: (String v) {
          setState(() {
            widget.textInputAction == TextInputAction.done
              ? FocusScope.of(context).consumeKeyboardToken()
              : FocusScope.of(context).requestFocus(widget.nextNode);
          });
        },
        inputFormatters: widget.isPriceInput == true 
          ? [
              LengthLimitingTextInputFormatter(9),
              FilteringTextInputFormatter.singleLineFormatter,
              FilteringTextInputFormatter.digitsOnly,
              DecimalFormatter()
            ]
          : widget.isPriceInputBank == true 
            ? [
                LengthLimitingTextInputFormatter(11),
                FilteringTextInputFormatter.singleLineFormatter,
                FilteringTextInputFormatter.digitsOnly,
                DecimalFormatter()
              ] 
            : widget.hintText == "NPK"
              ? [
                  FilteringTextInputFormatter.singleLineFormatter,
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 ]')),
                  UpperCaseTextFormatter(),
                ]
              : widget.hintText == "Nama"
                ? [
                    FilteringTextInputFormatter.singleLineFormatter,
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                  ]
                : widget.hintText == "NIK"
                  ? [
                      FilteringTextInputFormatter.singleLineFormatter,
                      FilteringTextInputFormatter.digitsOnly,
                    ]
                  : widget.hintText == "E-mail"
                    ? [
                        FilteringTextInputFormatter.singleLineFormatter,
                      ]
                    : [
                        FilteringTextInputFormatter.singleLineFormatter,
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 ]')),
                      ]
          ,
        decoration: InputDecoration(
          alignLabelWithHint: widget.alignLabelWithHint,
          fillColor:  const Color(0xffFBFBFB),
          filled: true,
          isDense: true,
          prefixIcon: widget.isPrefixIcon 
          ? widget.prefixIcon 
          : null,
          suffixIcon: widget.isSuffixIcon
          ? widget.isPassword 
            ? IconButton(
                onPressed: toggle,
                icon: Icon(obscureText
                  ? Icons.visibility_off
                  : Icons.visibility,
                  color: ColorResources.grey,
                  size: 18.0,
                ),
              )
            : widget.suffixIcon
          : null,
          counterStyle: sfProRegular.copyWith(
            color: ColorResources.grey,
            fontSize: Dimensions.fontSizeLarge
          ),
          floatingLabelBehavior: widget.floatingLabelBehavior,
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          hintText: widget.hintText,
          hintStyle: sfProRegular.copyWith(
            color: Colors.grey, 
            fontSize: Dimensions.fontSizeLarge,
            fontWeight: FontWeight.w500,
          ),
          label: widget.label,
          labelStyle: sfProRegular.copyWith(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color(0xffE2E2E2),
              width: 1.0,
            )
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color(0xffE2E2E2),
              width: 1.0,
            )
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: ColorResources.error,
              width: 2.0,
            )
          ),
        ),
      ),
    );
  }


void showDatePicker() {
  BottomPicker.date(
    title: getTranslated("DATE_OF_BIRTH"),
    titleStyle: sfProRegular.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: Dimensions.fontSizeDefault,
      color: ColorResources.primary
    ),
    onSubmit: (dynamic date) {
      setState(() {
        widget.controller.text = DateFormat('dd-MM-yyyy').format(date);
      });
    },
    pickerTextStyle: sfProRegular.copyWith(
      fontSize: Dimensions.fontSizeExtraLarge,
      color: ColorResources.black,
    ),
    height: 400.0,
    dismissable: true,
    initialDateTime: DateTime.now(),
    minDateTime: DateTime(1950, 1 , 1),
    maxDateTime: DateTime.now(),
    dateOrder: DatePickerDateOrder.dmy,
    backgroundColor: ColorResources.white,
    displayButtonIcon: false,
    buttonText: "Submit",
    buttonTextStyle: sfProRegular.copyWith(
      color: ColorResources.white,
      fontSize: Dimensions.fontSizeDefault
    ),
  buttonSingleColor: ColorResources.primary,
  ).show(context);
}
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class DecimalFormatter extends TextInputFormatter {
  final int decimalDigits;

  DecimalFormatter({this.decimalDigits = 2}) : assert(decimalDigits >= 0);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, 
    TextEditingValue newValue,) {

      String newText;

      if (decimalDigits == 0) {
        newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');
      }
      else {
        newText = newValue.text.replaceAll(RegExp('[^0-9.]'), '');
      }

      if(newText.contains('.')) {
        //in case if user's first input is "."
        if (newText.trim() == '.') {
          return newValue.copyWith(
            text: '0.',
            selection: const TextSelection.collapsed(offset: 2),
          );
        }
        //in case if user tries to input multiple "."s or tries to input 
        //more than the decimal place
        else if (
          (newText.split(".").length > 2) 
          || (newText.split(".")[1].length > decimalDigits)
        ) {
          return oldValue;
        }
        else {
          return newValue;
        }
      }

      //in case if input is empty or zero
      if (newText.trim() == '' || newText.trim() == '0') {
        return newValue.copyWith(text: '');
      } 
      else if (int.parse(newText) < 1) {
        return newValue.copyWith(text: '');
      }

      double newDouble = double.parse(newText);
      var selectionIndexFromTheRight =
        newValue.text.length - newValue.selection.end;

      String newString = NumberFormat("#,##0.##").format(newDouble);

      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    }
}