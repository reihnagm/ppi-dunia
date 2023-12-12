import 'package:flutter/material.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/features/profil/presentation/provider/profile.dart';

Widget searchBar({
  required ProfileProvider pp,
}) {
  return Container(
    margin: const EdgeInsets.only(left: 12.0, right: 12.0),
    height: 50.0,
    child: TextField(
      controller: pp.searchC,
      cursorColor: ColorResources.hintColor,
      style: const TextStyle(
          color: ColorResources.hintColor,
          fontSize: 20.0,
          fontFamily: 'SF Pro'),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(top: 12.0, bottom: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(color: ColorResources.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(color: ColorResources.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(color: ColorResources.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(color: ColorResources.transparent),
        ),
        hintText: "Search",
        hintStyle: TextStyle(
            color: ColorResources.hintColor,
            fontSize: 20.0,
            fontFamily: 'SF Pro'),
        fillColor: ColorResources.greySearchPrimary,
        filled: true,
        prefixIcon: Icon(
          Icons.search,
          size: 30.0,
          color: ColorResources.hintColor,
        ),
      ),
    ),
  );
}
