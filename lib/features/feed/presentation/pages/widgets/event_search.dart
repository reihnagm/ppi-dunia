import 'package:flutter/material.dart';
import 'package:ppidunia/features/feed/presentation/pages/event/event_screen_model.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:provider/provider.dart';

import 'package:ppidunia/common/utils/color_resources.dart';

class EventSearch extends StatelessWidget {
  const EventSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventScreenModel>(
      builder: (BuildContext context, EventScreenModel esm, Widget? child) {
        return Container(
            margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            height: 50.0,
            child: TextField(
              controller: esm.searchC,
              cursorColor: ColorResources.hintColor,
              style: const TextStyle(
                  color: ColorResources.hintColor,
                  fontSize: 20.0,
                  fontFamily: 'SF Pro'),
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.only(top: 12.0, bottom: 12.0),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: ColorResources.transparent),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: ColorResources.transparent),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: ColorResources.transparent),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: ColorResources.transparent),
                  ),
                  hintText: getTranslated("SEARCH"),
                  hintStyle: const TextStyle(
                      color: ColorResources.hintColor,
                      fontSize: 20.0,
                      fontFamily: 'SF Pro'),
                  fillColor: ColorResources.greySearchPrimary,
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 30.0,
                    color: ColorResources.hintColor,
                  )),
            ));
      },
    );
  }
}
