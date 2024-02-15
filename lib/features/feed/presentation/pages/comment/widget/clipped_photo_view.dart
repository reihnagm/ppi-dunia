
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/helpers/download_util.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_screen_model.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/views/basewidgets/detecttext/detect_text.dart';
import 'package:provider/provider.dart';

class ClippedPhotoViewComment extends StatefulWidget {
  final String image;
  const ClippedPhotoViewComment({super.key, required this.image});

  @override
  State<ClippedPhotoViewComment> createState() => _ClippedPhotoViewCommentState();
}

class _ClippedPhotoViewCommentState extends State<ClippedPhotoViewComment> {
  late CommentScreenModel csm;

  bool isScale = false;
  int zoom = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    csm = context.read<CommentScreenModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentScreenModel>(
      builder: (BuildContext context, CommentScreenModel csm, Widget? child) {
        if (csm.feedDetailStatus == FeedDetailStatus.loading) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .75,
            child: const SpinKitCubeGrid(
              color: ColorResources.greyLightPrimary,
              size: 30.0,
            ),
          );
        }

        if (csm.feedDetailStatus == FeedDetailStatus.error) {
          return SizedBox(
              height: 150.0,
              child: Center(
                child: Text(
                  getTranslated("PLEASE_TRY_AGAIN_LATER"),
                  style: const TextStyle(
                    color: ColorResources.greyLightPrimary,
                    fontSize: Dimensions.fontSizeOverLarge,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro',
                  ),
                ),
              ));
        }

        if (csm.feedDetailStatus == FeedDetailStatus.empty) {
          return SizedBox(
              height: 150.0,
              child: Center(
                child: Text(
                  getTranslated("NO_POST"),
                  style: const TextStyle(
                      color: ColorResources.greyLightPrimary,
                      fontSize: Dimensions.fontSizeOverLarge,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro'),
                ),
              ));
        }
        return AnnotatedRegion(
          value: SystemUiOverlayStyle.light,
          child: SafeArea(
            child: Scaffold(
              body: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: PhotoView(
                      backgroundDecoration: const BoxDecoration(color: ColorResources.blackSport),
                      imageProvider: widget.image == ""
                          ? const AssetImage('assets/images/default/ava.jpg')
                          : Image.network(widget.image, fit: BoxFit.contain).image,
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      maxScale: PhotoViewComputedScale.covered * 3,
                      onTapDown: (context, details, controllerValue) {
                        setState(() {
                          zoom = details.kind!.index;
                        });
                      },
                      scaleStateChangedCallback: (value) {
                        setState(() {
                          isScale = value.isScaleStateZooming;
                          zoom = value.index;
                        });
                      },
                      loadingBuilder: (context, event) => Center(
                        child: SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            value: event == null
                                ? 0
                                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                          ),
                        ),
                      ),
                    ),
                  ),
                  isScale || zoom == 1 ? Container() : Positioned(
                    top: 15.0,
                    left: 15.0,
                    right: 15.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorResources.greyPrimary.withOpacity(0.8),
                          ),
                          child: CupertinoNavigationBarBackButton(
                            color: ColorResources.white,
                            onPressed: () {
                              NS.pop(context);
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorResources.greyPrimary.withOpacity(0.8),
                          ),
                          child: PopupMenuButton(
                            color: ColorResources.white,
                            iconColor: Colors.white,
                            iconSize: 20,
                            itemBuilder: (BuildContext
                                buildContext) {
                              return [
                                const PopupMenuItem(
                                  value: "/save",
                                  child: Text("Save",
                                    style: TextStyle(
                                        color: ColorResources.greyDarkPrimary,
                                        fontSize: Dimensions.fontSizeSmall,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SF Pro'))
                                ),
                              ];
                            },
                            onSelected: (route) async {
                              if (route == "/save") {
                                await DownloadHelper.downloadDoc(context: context, url: widget.image);
                              }
                            },
                          ),
                        )
                      ],
                    )
                  ),
                  isScale || zoom == 1 ? Container() : Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          color: ColorResources.greyPrimary.withOpacity(0.8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(csm.feedDetailData.user!.name,
                                overflow: TextOverflow.visible,
                                style: const TextStyle(
                                  color: ColorResources.white,
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SF Pro')),
                              const SizedBox(height: 10,),
                              DetectText(text: csm.feedDetailData.caption ?? "-"),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: CustomButton(
                                      width: MediaQuery.sizeOf(context).width < 400 ? 100 : 120,
                                      isBorder: false,
                                      btnColor: ColorResources.bgSecondaryColor,
                                      btnTextColor: Colors.white,
                                      sizeBorderRadius: 10.0,
                                      isBorderRadius: true,
                                      height: 30.0,
                                      onTap: () async {
                                        setState(() {
                                        csm.toggleLike(feedId: csm.feedDetailData.uid!, feedLikes: csm.feedDetailData.feedLikes!);
                                        });
                                      },
                                      btnTxt: csm.feedDetailData.feedLikes!.likes.isEmpty ? "0" : csm.feedDetailData.feedLikes!.total.toString(),
                                      isPrefixIcon: true,
                                      prefixIcon: csm.feedDetailData.feedLikes!.likes.where((el) => el.user.uid == SharedPrefs.getUserId()).isEmpty
                                        ? Image.asset(AssetsConst.imageIcLove, width: 18.0)
                                        : Image.asset(AssetsConst.imageIcLoveFill, width: 18.0,),
                                    ),
                                  ),
                                  Flexible(
                                    child: CustomButton(
                                      width: MediaQuery.sizeOf(context).width < 400 ? 100 : 120,
                                      isBorder: false,
                                      btnColor: ColorResources.bgSecondaryColor,
                                      btnTextColor: Colors.white,
                                      sizeBorderRadius: 10.0,
                                      isBorderRadius: true,
                                      height: 30.0,
                                      onTap: () async {
                                        NS.pop(context);
                                      },
                                      btnTxt: csm.feedDetailData.feedComments!.total.toString(),
                                      isPrefixIcon: true,
                                      prefixIcon: csm.feedDetailData.feedComments!.comments.isEmpty
                                      ? Image.asset(AssetsConst.imageIcChat, width: 18.0,)
                                      : Image.asset(AssetsConst.imageIcChatFill, width: 18.0,),
                                    ),
                                  ),
                                  Flexible(
                                    child: CustomButton(
                                      width: MediaQuery.sizeOf(context).width < 400 ? 100 : 120,
                                      isBorder: false,
                                      btnColor: ColorResources.bgSecondaryColor,
                                      btnTextColor: Colors.white,
                                      sizeBorderRadius: 10.0,
                                      isBorderRadius: true,
                                      height: 30.0,
                                      onTap: () async {
                                         await csm.toggleBookmark(feedId: csm.feedDetailData.uid!, feedBookmarks: csm.feedDetailData.feedBookmarks!);
                                      },
                                      btnTxt: "",
                                      isPrefixIcon: true,
                                      prefixIcon: csm.feedDetailData.feedBookmarks!
                                        .bookmarks
                                        .where((el) =>
                                            el.user.uid ==
                                            SharedPrefs.getUserId())
                                        .isEmpty
                                    ? Image.asset(
                                        'assets/images/icons/ic-save.png',
                                        width: 18.0,
                                      )
                                    : Image.asset(
                                        AssetsConst.imageIcSaveFill,
                                        width: 18.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                            ],
                          ),
                        )
                      ],
                    )
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
