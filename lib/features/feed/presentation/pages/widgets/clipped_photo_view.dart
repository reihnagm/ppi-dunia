
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/extensions/snackbar.dart';
import 'package:ppidunia/common/helpers/date_util.dart';
import 'package:ppidunia/common/helpers/download_util.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/features/feed/data/models/feed.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_state.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/views/basewidgets/detecttext/detect_text.dart';
import 'package:provider/provider.dart';

class ClippedPhotoView extends StatefulWidget {
  final String feedId;
  final int index;
  final bool isComment;
  const ClippedPhotoView({super.key, required this.feedId, required this.index, required this.isComment});

  @override
  State<ClippedPhotoView> createState() => _ClippedPhotoViewState();
}

class _ClippedPhotoViewState extends State<ClippedPhotoView> {
  late CommentScreenModel csm;

  bool isScale = false;
  int zoom = 0;
  int indexImage = 0;
  late PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    csm = context.read<CommentScreenModel>();
    indexImage = widget.index;
    pageController = PageController(initialPage: indexImage);
    if (mounted) {
      csm.getFeedDetail(feedId: widget.feedId);
    }
  }
  void onPageChanged(int index) {
    setState(() {
      indexImage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentScreenModel>(
      builder: (BuildContext context, CommentScreenModel c, Widget? child) {
        if (c.feedDetailStatus == FeedDetailStatus.loading) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .75,
            child: const SpinKitCubeGrid(
              color: ColorResources.greyLightPrimary,
              size: 30.0,
            ),
          );
        }

        if (c.feedDetailStatus == FeedDetailStatus.error) {
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

        if (c.feedDetailStatus == FeedDetailStatus.empty) {
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
                        child: PhotoViewGallery.builder(
                          scaleStateChangedCallback: (value) {
                            setState(() {
                              isScale = value.isScaleStateZooming;
                              zoom = value.index;
                            });
                          },
                          onPageChanged: onPageChanged,
                          pageController: pageController,
                          scrollPhysics: const BouncingScrollPhysics(),
                          builder: (BuildContext context, int i) {
                            int i = indexImage;
                            return PhotoViewGalleryPageOptions(
                              minScale: PhotoViewComputedScale.contained * 1,
                              maxScale: PhotoViewComputedScale.covered * 3,
                              onTapDown: (context, details, controllerValue) {
                                setState(() {
                                  zoom = details.kind!.index;
                                });
                              },
                              imageProvider: c.feedDetailData.media![i].path.isEmpty
                              ? const AssetImage('assets/images/default/ava.jpg')
                              : Image.network(c.feedDetailData.media![i].path, fit: BoxFit.contain).image,
                              initialScale: PhotoViewComputedScale.contained * 0.8,
                              heroAttributes: PhotoViewHeroAttributes(tag:c.feedDetailData.media![i].path),
                            );
                          },
                          itemCount: c.feedDetailData.media!.length,
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
                                      child: Text("Save Image",
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
                                      await DownloadHelper.downloadDoc(context: context, url: c.feedDetailData.media![indexImage].path);
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
                                  Text(c.feedDetailData.user!.name,
                                    overflow: TextOverflow.visible,
                                    style: const TextStyle(
                                      color: ColorResources.white,
                                      fontSize: Dimensions.fontSizeLarge,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'SF Pro')),
                                  Text(
                                    DateHelper.formatDateTime(c.feedDetailData.createdAt.toString()),
                                    style: const TextStyle( color: ColorResources.greyDarkPrimary,
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'SF Pro')),
                                  const SizedBox(height: 10,),
                                  DetectText(text: c.feedDetailData.caption.toString()),
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
                                            c.toggleLike(feedId: c.feedDetailData.uid!,feedLikes: c.feedDetailData.feedLikes!);
                                            // c.panelC.open();
                                            });
                                          },
                                          btnTxt: c.feedDetailData.feedLikes!.likes.isEmpty ? "0" : c.feedDetailData.feedLikes!.total.toString(),
                                          isPrefixIcon: true,
                                          prefixIcon: c.feedDetailData.feedLikes!.likes.where((el) => el.user.uid == SharedPrefs.getUserId()).isEmpty
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
                                            !widget.isComment ?
                                            Navigator.push(context, NS.fromLeft(CommentScreen(feedId: c.feedDetailData.uid!))).then((_) => setState(() {
                                              c.getFeedDetail(feedId: widget.feedId);
                                              indexImage;
                                              widget.isComment;
                                            })):  NS.pop(context);
                                          },
                                          btnTxt: c.feedDetailData.feedComments!.total.toString(),
                                          isPrefixIcon: true,
                                          prefixIcon: c.feedDetailData.feedComments!.comments.isEmpty
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
                                             await c.toggleBookmark(
                                              feedId: c.feedDetailData.uid.toString(),
                                              feedBookmarks: c.feedDetailData.feedBookmarks!);
                                            // c.panelC.open();
                                          },
                                          btnTxt: "",
                                          isPrefixIcon: true,
                                          prefixIcon: c.feedDetailData.feedBookmarks!
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
                )
          ),
        );
      }
    );
  }
}
