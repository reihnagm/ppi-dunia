// ignore: file_names
import 'package:flutter/material.dart';
import 'package:ppidunia/common/utils/color_resources.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final Color? color, bgColor;
  final String? hint;
  // ignore: prefer_typing_uninitialized_variables
  final onChange;

  // ignore: use_key_in_widget_constructors
  const SearchBar(
      {this.controller, this.onChange, this.color, this.bgColor, this.hint});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            height: 35.0,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0), color: bgColor),
            child: TextField(
              style: const TextStyle(
                fontSize: 13.0,
                color: ColorResources.black,
                fontWeight: FontWeight.w400,
              ),
              controller: controller,
              onChanged: (value) => onChange(value),
              cursorHeight: 18,
              cursorColor: color,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  size: 20.0,
                  color: color,
                ),
                focusColor: color,
                hoverColor: color,
                fillColor: color,
                contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: const Color(0xFF9D9D9D).withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
              ),
            )),
      ],
    );
  }
}
