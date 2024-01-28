import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ppidunia/common/helpers/date_util.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/utils/modals.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/features/profil/presentation/pages/profile_view/profile_view_state.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/basewidgets/image/image_avatar.dart';

class CardHeaderPost extends StatelessWidget {
  final String avatar;
  final String name;
  final String date;
  final String userId;
  final bool isHidden;
  final Function(String) onSelected;
  const CardHeaderPost({super.key, required this.avatar, required this.name, required this.date, required this.userId, required this.onSelected, required this.isHidden});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => NS.push(context, ProfileViewScreen(userId: userId)),
                  child: imageAvatar(avatar, 20)
                ),
                const SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5,),
                    InkWell(
                      onTap: () => NS.push(context, ProfileViewScreen(userId: userId)),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width < 400 ? 195 : 240,
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
                )
              ],
            ),
            
            userId == SharedPrefs.getUserId()
            ? const SizedBox()
            : isHidden ? Container() : 
            PopupMenuButton(
                color: Colors.white,
                iconColor: Colors.white,
                iconSize: 20,
                itemBuilder: (BuildContext
                    buildContext) {
                  return [
                    PopupMenuItem(
                        value: "/report-user",
                        child: Text(
                            "Block content",
                            style: TextStyle(
                                color: Colors
                                    .black,
                                fontSize:
                                    11.sp))),
                    PopupMenuItem(
                        value: "/report-user",
                        child: Text(
                            "Block user",
                            style: TextStyle(
                                color: Colors
                                    .black,
                                fontSize:
                                    11.sp))),
                    PopupMenuItem(
                        value: "/report-user",
                        child: Text(
                            "It's spam",
                            style: TextStyle(
                                color: Colors
                                    .black,
                                fontSize:
                                    11.sp))),
                    PopupMenuItem(
                        value: "/report-user",
                        child: Text(
                            "Nudity or sexual activity",
                            style: TextStyle(
                                color: Colors
                                    .black,
                                fontSize:
                                    11.sp))),
                    PopupMenuItem(
                        value: "/report-user",
                        child: Text(
                            "False Information",
                            style: TextStyle(
                                color: Colors
                                    .black,
                                fontSize:
                                    11.sp)))
                  ];
                },
                onSelected: (route) async {
                  if (route ==
                      "/report-user") {
                    await GeneralModal
                        .reportUser();
                  }
                },
              ),
            userId == SharedPrefs.getUserId()
            ? isHidden ? Container() : 
            PopupMenuButton(
                color: ColorResources.white,
                iconColor: Colors.white,
                iconSize: 20,
                itemBuilder: (BuildContext
                    buildContext) {
                  return [
                    PopupMenuItem(
                      value: "/delete",
                      child: Text(
                        getTranslated(
                            "DELETE"),
                        style: const TextStyle(
                            color: ColorResources.greyDarkPrimary,
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SF Pro'))),
                  ];
                },
                onSelected: onSelected,
              )
            : const SizedBox(),                      
          ],
        )
      ],
    );
  }
}