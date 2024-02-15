
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/extensions/snackbar.dart';
import 'package:ppidunia/common/helpers/date_util.dart';
import 'package:ppidunia/common/helpers/download_util.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_state.dart';
import 'package:ppidunia/features/feed/presentation/pages/feed/feed_screen_model.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/views/basewidgets/detecttext/detect_text.dart';
import 'package:provider/provider.dart';

class ClippedPhotoView extends StatefulWidget {
  final String image;
  final int index;
  const ClippedPhotoView({super.key, required this.image,required this.index});

  @override
  State<ClippedPhotoView> createState() => _ClippedPhotoViewState();
}

class _ClippedPhotoViewState extends State<ClippedPhotoView> {
  late FeedScreenModel fsm;

  bool isScale = false;
  int zoom = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fsm = context.read<FeedScreenModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedScreenModel>(
      builder: (BuildContext context, FeedScreenModel fsm, Widget? child) {
        if (fsm.feedStatus == FeedStatus.loading) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .75,
            child: const SpinKitCubeGrid(
              color: ColorResources.greyLightPrimary,
              size: 30.0,
            ),
          );
        }

        if (fsm.feedStatus == FeedStatus.error) {
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

        if (fsm.feedStatus == FeedStatus.empty) {
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          width: double.infinity,
                          color: ColorResources.greyPrimary.withOpacity(0.8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(fsm.feeds[widget.index].user.name,
                                overflow: TextOverflow.visible,
                                style: const TextStyle(
                                  color: ColorResources.white,
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SF Pro')),
                              Text(
                                DateHelper.formatDateTime(fsm.feeds[widget.index].createdAt),
                                style: const TextStyle( color: ColorResources.greyDarkPrimary,
                                  fontSize: Dimensions.fontSizeExtraSmall,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SF Pro')),
                              const SizedBox(height: 10,),
                              DetectText(text: fsm.feeds[widget.index].caption),
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
                                        fsm.toggleLike(feedId: fsm.feeds[widget.index].uid,feedLikes: fsm.feeds[widget.index].feedLikes);
                                        fsm.panelC.open();
                                        });
                                      },
                                      btnTxt: fsm.feeds[widget.index].feedLikes.likes.isEmpty ? "0" : fsm.feeds[widget.index].feedLikes.total.toString(),
                                      isPrefixIcon: true,
                                      prefixIcon: fsm.feeds[widget.index].feedLikes.likes.where((el) => el.user.uid == SharedPrefs.getUserId()).isEmpty
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
                                        Navigator.push(context, NS.fromLeft(CommentScreen(feedId: fsm.feeds[widget.index].uid))).then((_) => setState(() {
                                          fsm.getFeeds();
                                        }));
                                      },
                                      btnTxt: fsm.feeds[widget.index].feedComments.total.toString(),
                                      isPrefixIcon: true,
                                      prefixIcon: fsm.feeds[widget.index].feedComments.comments.isEmpty
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
                                         await fsm.toggleBookmark(
                                          feedId: fsm.feeds[widget.index].uid,
                                          feedBookmarks: fsm.feeds[widget.index].feedBookmarks);
                                        fsm.panelC.open();
                                      },
                                      btnTxt: "",
                                      isPrefixIcon: true,
                                      prefixIcon: fsm.feeds[widget.index].feedBookmarks
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
