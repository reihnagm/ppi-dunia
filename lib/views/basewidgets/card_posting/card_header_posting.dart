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

class CardHeaderPost extends StatefulWidget {
  final String avatar;
  final String name;
  final String date;
  final String userId;
  final String? feedId;
  final bool isHidden;
  final Function(String) onSelected;
  const CardHeaderPost({super.key, required this.avatar, required this.name, required this.date, required this.userId, required this.onSelected, required this.isHidden, this.feedId});

  @override
  State<CardHeaderPost> createState() => _CardHeaderPostState();
}

class _CardHeaderPostState extends State<CardHeaderPost> {
  @override
  Widget build(BuildContext context) {
    String content = "";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () => NS.push(context, ProfileViewScreen(userId: widget.userId)),
            child: imageAvatar(widget.avatar, 20)
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 5,),
              InkWell(
                onTap: () => NS.push(context, ProfileViewScreen(userId: widget.userId)),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(widget.name,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                      color: ColorResources.white,
                      fontSize: Dimensions.fontSizeSmall,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro')),
                ),
              ),
              Text(
                DateHelper.formatDateTime(widget.date),
                style: const TextStyle( color: ColorResources.greyDarkPrimary,
                  fontSize: Dimensions.fontSizeExtraSmall,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro')),
            ],
          ),
        ),
        widget.userId == SharedPrefs.getUserId()
    ? const SizedBox()
    : widget.isHidden ? Container() : 
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
                "It's racist",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 11.sp
                )),
                onTap: () async {
                  setState(() {
                    content = "Racist";
                  });
                  await GeneralModal.reportUser(content: content, feedId: widget.feedId ?? "");
                },
            ),
            PopupMenuItem(
                value: "/report-user",
                child: Text(
                "It's spam",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 11.sp
                )),
                onTap: () async {
                  setState(() {
                    content = "Spam";
                  });
                  await GeneralModal.reportUser(content: content, feedId: widget.feedId ?? "");
                },
            ),
            PopupMenuItem(
                value: "/report-user",
                child: Text(
                "Nudity or sexual activity",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 11.sp
                )),
                onTap: () async {
                  setState(() {
                    content = "Nudity";
                  });
                  await GeneralModal.reportUser(content: content, feedId: widget.feedId ?? "");
                },
            ),
            PopupMenuItem(
                value: "/report-user",
                child: Text(
                "False Information",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 11.sp
                )),
                onTap: () async {
                  setState(() {
                    content = "Hoax";
                  });
                  await GeneralModal.reportUser(content: content, feedId: widget.feedId ?? "");
                },
            )
          ];
        },
      ),
      widget.userId == SharedPrefs.getUserId()
      ? widget.isHidden ? Container() : 
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
          onSelected: widget.onSelected,
        )
      : const SizedBox()
      ],
    );
  }
}