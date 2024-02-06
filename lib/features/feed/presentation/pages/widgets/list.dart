import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ppidunia/common/extensions/snackbar.dart';
import 'package:ppidunia/common/helpers/date_util.dart';
import 'package:ppidunia/common/helpers/download_util.dart';
import 'package:ppidunia/common/utils/modals.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_state.dart';
import 'package:ppidunia/features/feed/presentation/pages/feed/feed_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/widgets/clipped_photo_view.dart';
import 'package:ppidunia/features/feed/provider/forum_download.dart';
import 'package:ppidunia/views/basewidgets/card_posting/card_header_posting.dart';
import 'package:ppidunia/views/basewidgets/detecttext/detect_text.dart';
import 'package:ppidunia/views/basewidgets/image/image_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';


import 'package:cached_network_image/cached_network_image.dart';

import 'package:ppidunia/services/navigation.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/consts/assets_const.dart';

import 'package:ppidunia/features/feed/presentation/pages/widgets/video.dart';

class FeedList extends StatefulWidget {
  const FeedList({
    super.key,
  });

  @override
  State<FeedList> createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
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

        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
            shrinkWrap: true,
            itemCount: fsm.feeds.length,
            itemBuilder: (BuildContext context, int i) {
              return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      color: ColorResources.greyPrimary),
                  child: Material(
                    color: ColorResources.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.0),
                      onTap: () {
                        Navigator.push(context, NS.fromLeft(CommentScreen(feedId: fsm.feeds[i].uid))).then((_) => setState(() {
                          fsm.getFeeds();
                        }));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                              left: 15.0,
                              top: 15.0,
                              right: 10.0
                            ),
                            child: CardHeaderPost(avatar: fsm.feeds[i].user.avatar, name: fsm.feeds[i].user.name, date: fsm.feeds[i].createdAt,feedId: fsm.feeds[i].uid, onSelected: (String route) async { 
                              GeneralModal.showConfirmModals(
                                image: AssetsConst.imageIcPopUpDelete,
                                msg: "Are you sure want to delete ?",
                              onPressed: () async {
                                  if (route == "/delete") {
                                    await fsm.delete(feedId: fsm.feeds[i].uid);
                                  }
                                  Future.delayed(Duration.zero, () {
                                    NS.pop(context);
                                    ShowSnackbar.snackbar(context, "Successfully delete a comments", '', ColorResources.success);
                                  });
                                },
                              );
                            }, userId: fsm.feeds[i].user.uid, isHidden: false,)
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 25.0, left: 25.0, bottom: 10.0, top: 5),
                            child: DetectText(text: fsm.feeds[i].caption),
                          ),
                          if (fsm.feeds[i].feedType == "image")
                            if (fsm.feeds[i].media.length == 1)
                            fsm.feeds[i].media.isNotEmpty ?
                              InkWell(
                                onTap: () => NS.push(
                                  context,
                                  ClippedPhotoView(
                                    image: fsm.feeds[i].media[0].path,
                                  ),
                                ),
                                child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 25.0,
                                        right: 25.0,
                                        top: 5.0,
                                        bottom: 20),
                                    child: imageCard(fsm.feeds[i].media[0].path,
                                        200.0, 10.0)),
                              ) : Container(),
                          if (fsm.feeds[i].media.length > 1)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: CarouselSlider.builder(
                                  options: CarouselOptions(
                                    autoPlay: false,
                                    height: 200.0,
                                    enlargeCenterPage: true,
                                    viewportFraction: 1.0,
                                    enlargeStrategy:
                                        CenterPageEnlargeStrategy.scale,
                                    initialPage: fsm.currentIndex,
                                    onPageChanged: (int i,
                                        CarouselPageChangedReason reason) {
                                      fsm.onChangeCurrentMultipleImg(i);
                                    },
                                  ),
                                  itemCount: fsm.feeds[i].media.length,
                                  itemBuilder:
                                      (BuildContext context, int x, int z) {
                                    return InkWell(
                                      onTap: () => NS.push(
                                        context,
                                        ClippedPhotoView(
                                          image: fsm.feeds[i].media[x].path,
                                        ),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: fsm.feeds[i].media[x].path,
                                        imageBuilder: (BuildContext context,
                                            ImageProvider imageProvider) {
                                          return Container(
                                            width: double.infinity,
                                            height: 180.0,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    fit: BoxFit.cover,
                                                    image: imageProvider)),
                                          );
                                        },
                                        placeholder:
                                            (BuildContext context, String val) {
                                          return Container(
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        AssetsConst
                                                            .imageDefault))),
                                          );
                                        },
                                        errorWidget: (BuildContext context,
                                            String text, dynamic _) {
                                          return Container(
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        AssetsConst
                                                            .imageDefault))),
                                          );
                                        },
                                      ),
                                    );
                                  }),
                            ),
                          if (fsm.feeds[i].media.length > 1)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: fsm.feeds[i].media.map((z) {
                                  int index = fsm.feeds[i].media.indexOf(z);
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          fsm.currentIndexMultipleImg == index
                                              ? ColorResources.bluePrimary
                                              : ColorResources.dimGrey,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          if (fsm.feeds[i].feedType == "video")
                            fsm.feeds[i].media.isNotEmpty ?
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                                child: VideoPlay(
                                dataSource: fsm.feeds[i].media[0].path
                              )
                            ) : Container(),
                          if (fsm.feeds[i].feedType == "document")
                            fsm.feeds[i].media.isNotEmpty ?
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 10.0),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 12.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: ColorResources.greyDarkPrimary),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 150.0,
                                        child: Text(
                                            fsm.feeds[i].media[0].path
                                                .split('/')
                                                .last,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: ColorResources.white,
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'SF Pro')),
                                      ),
                                      const SizedBox(height: 6.0),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                              "${getTranslated("FILE_SIZE")} :",
                                              style: const TextStyle(
                                                  color: ColorResources.white,
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'SF Pro')),
                                          const SizedBox(width: 8.0),
                                          Text(
                                              fsm.feeds[i].media[0].size
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: ColorResources.white,
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'SF Pro')),
                                        ],
                                      )
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.download),
                                    onPressed: () async {
                                      await DownloadHelper.downloadDoc(context: context, url: fsm.feeds[i].media[0].path);
                                    },
                                    color: ColorResources.white,
                                  )
                                ],
                              ),
                            ) : Container(),
                          Container(
                            height: 35.0,
                            decoration: const BoxDecoration(
                                color: ColorResources.black,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12.0),
                                    bottomRight: Radius.circular(12.0))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Material(
                                        color: ColorResources.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          onTap: () async {
                                            await fsm.toggleLike(
                                              feedId: fsm.feeds[i].uid,
                                              feedLikes: fsm.feeds[i].feedLikes);
                                              fsm.panelC.open();
                                          },
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  fsm.feeds[i].feedLikes.likes
                                                          .where((el) =>
                                                              el.user.uid ==
                                                              SharedPrefs
                                                                  .getUserId())
                                                          .isEmpty
                                                      ? Image.asset(
                                                          AssetsConst
                                                              .imageIcLove,
                                                          width: 18.0,
                                                        )
                                                      : Image.asset(
                                                          AssetsConst
                                                              .imageIcLoveFill,
                                                          width: 18.0,
                                                        ),
                                                  fsm.feeds[i].feedLikes.likes
                                                          .isEmpty
                                                      ? const SizedBox()
                                                      : const SizedBox(
                                                          width: 12.0),
                                                  fsm.feeds[i].feedLikes.likes
                                                          .isEmpty
                                                      ? const SizedBox()
                                                      : Text(
                                                          fsm.feeds[i].feedLikes
                                                              .total
                                                              .toString(),
                                                          style: const TextStyle(
                                                              color:
                                                                  ColorResources
                                                                      .white,
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'SF Pro'),
                                                        )
                                                ],
                                              )),
                                        ),
                                      ),
                                      const SizedBox(width: 15.0),
                                      Material(
                                        color: ColorResources.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          onTap: () {
                                            Navigator.push(context, NS.fromLeft(CommentScreen(feedId: fsm.feeds[i].uid))).then((_) => setState(() {
                                              fsm.getFeeds();
                                            }));
                                          },
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  fsm.feeds[i].feedComments
                                                          .comments.isEmpty
                                                      ? Image.asset(
                                                          AssetsConst
                                                              .imageIcChat,
                                                          width: 18.0,
                                                        )
                                                      : Image.asset(
                                                          AssetsConst
                                                              .imageIcChatFill,
                                                          width: 18.0,
                                                        ),
                                                  fsm.feeds[i].feedComments
                                                          .comments.isEmpty
                                                      ? const SizedBox()
                                                      : const SizedBox(
                                                          width: 12.0),
                                                  fsm.feeds[i].feedComments
                                                          .comments.isEmpty
                                                      ? const SizedBox()
                                                      : Text(fsm.feeds[i].feedComments.total.toString(),
                                                          style: const TextStyle(
                                                              color:
                                                                  ColorResources
                                                                      .white,
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'SF Pro'),
                                                        )
                                                ],
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Material(
                                        color: ColorResources.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          onTap: () async {
                                            await fsm.toggleBookmark(
                                                feedId: fsm.feeds[i].uid,
                                                feedBookmarks:
                                                    fsm.feeds[i].feedBookmarks);
                                            fsm.panelC.open();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: fsm.feeds[i].feedBookmarks
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
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
            });
      },
    );
  }
}