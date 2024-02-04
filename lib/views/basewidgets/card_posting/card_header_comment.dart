import 'package:flutter/material.dart';
import 'package:ppidunia/common/helpers/date_util.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/features/profil/presentation/pages/profile_view/profile_view_state.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';

class CardHeaderComment extends StatelessWidget {
  final String name;
  final String date;
  final String userId;
  final Function(String) onSelected;
  const CardHeaderComment({super.key, required this.name, required this.date, required this.userId, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5,),
              InkWell(
                onTap: () => NS.push(context, ProfileViewScreen(userId: userId)),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width < 400 ? 180 : 240,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(name,
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      style: const TextStyle(
                        color: ColorResources.white,
                        fontSize: Dimensions.fontSizeSmall,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro')),
                  ),
                ),
              ),
              Text(
                DateHelper.formatDateTime(date),
                style: const TextStyle( color: ColorResources.greyDarkPrimary,
                  fontSize: Dimensions.fontSizeExtraSmall,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro')),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              userId == SharedPrefs.getUserId()
              ? PopupMenuButton(
                  color: Colors.white,
                  iconColor: Colors.white,
                  iconSize: 20,
                  itemBuilder: (BuildContext buildContext) {
                    return [
                      PopupMenuItem(
                        value: "/delete",
                        child: Text(getTranslated("DELETE"), style: const TextStyle(color: ColorResources.greyDarkPrimary, fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w600, fontFamily: 'SF Pro'))),
                    ];
                  },
                  onSelected: onSelected,
                )
              : const SizedBox(),  
            ],
          ),
        )
      ],
    );
  }
}