import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/services/navigation.dart';

import 'package:ppidunia/common/helpers/download_util.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/common/consts/assets_const.dart';

import 'package:ppidunia/features/feed/presentation/pages/bookmarks/bookmark_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/widgets/video.dart';

class BookmarkList extends StatelessWidget {
  const BookmarkList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkScreenModel>(
      builder: (BuildContext context, BookmarkScreenModel bsm, Widget? child) {
        if (bsm.bookmarkStatus == BookmarkStatus.loading) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .75,
            child: const SpinKitCubeGrid(
              color: ColorResources.greyLightPrimary,
              size: 30.0,
            ),
          );
        }

        if (bsm.bookmarkStatus == BookmarkStatus.error) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * .75,
              child: Center(
                child: Text(
                  getTranslated("PLEASE_TRY_AGAIN_LATER"),
                  style: const TextStyle(
                      color: ColorResources.greyLightPrimary,
                      fontSize: Dimensions.fontSizeOverLarge,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro'),
                ),
              ));
        }

        if (bsm.bookmarkStatus == BookmarkStatus.empty) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * .75,
              child: Center(
                child: Text(
                  getTranslated("NO_BOOKMARK"),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
            shrinkWrap: true,
            itemCount: bsm.feeds.length,
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
                        NS.push(
                            context, CommentScreen(feedId: bsm.feeds[i].uid));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: CachedNetworkImage(
                                    imageUrl: bsm.feeds[i].user.avatar,
                                    imageBuilder: (BuildContext context,
                                        ImageProvider<Object> imageProvider) {
                                      return CircleAvatar(
                                        radius: 25.0,
                                        backgroundImage: imageProvider,
                                      );
                                    },
                                    placeholder:
                                        (BuildContext context, String url) {
                                      return const CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: Color(0xFF637687),
                                      );
                                    },
                                    errorWidget: (BuildContext context,
                                        String url, dynamic error) {
                                      return const CircleAvatar(
                                        radius: 25.0,
                                        backgroundImage: AssetImage(
                                            AssetsConst.imageLogoPpi),
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 28,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              SizedBox(
                                                width: 110.0,
                                                child: Text(
                                                    bsm.feeds[i].user.name,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: ColorResources
                                                            .white,
                                                        fontSize: Dimensions
                                                            .fontSizeLarge,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: 'SF Pro')),
                                              ),
                                              const SizedBox(width: 10.0),
                                              const Text("•",
                                                  style: TextStyle(
                                                      color: ColorResources
                                                          .greyDarkPrimary,
                                                      fontSize: Dimensions
                                                          .fontSizeDefault,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'SF Pro')),
                                              const SizedBox(width: 5.0),
                                              Text(bsm.feeds[i].createdAt,
                                                  style: const TextStyle(
                                                      color: ColorResources
                                                          .greyDarkPrimary,
                                                      fontSize: Dimensions
                                                          .fontSizeExtraSmall,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'SF Pro')),
                                            ],
                                          ),
                                          bsm.feeds[i].user.uid ==
                                                  SharedPrefs.getUserId()
                                              ? PopupMenuButton(
                                                  color: ColorResources.white,
                                                  itemBuilder: (BuildContext
                                                      buildContext) {
                                                    return [
                                                      PopupMenuItem(
                                                          value: "/delete",
                                                          child: Text(
                                                              getTranslated(
                                                                  "DELETE"),
                                                              style: const TextStyle(
                                                                  color: ColorResources
                                                                      .greyDarkPrimary,
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeDefault,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontFamily:
                                                                      'SF Pro'))),
                                                    ];
                                                  },
                                                  onSelected:
                                                      (String route) async {
                                                    if (route == "/delete") {
                                                      await bsm.delete(
                                                          feedId:
                                                              bsm.feeds[i].uid);
                                                    }
                                                  },
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        bsm.feeds[i].caption,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 4,
                                        style: const TextStyle(
                                            color: ColorResources.hintColor,
                                            fontSize:
                                                Dimensions.fontSizeOverLarge,
                                            fontFamily: 'SF Pro'),
                                      ),
                                      const SizedBox(height: 8.0),
                                      if (bsm.feeds[i].feedType == "image")
                                        if (bsm.feeds[i].media.length == 1)
                                          CachedNetworkImage(
                                            imageUrl:
                                                bsm.feeds[i].media[0].path,
                                            imageBuilder: (BuildContext context,
                                                ImageProvider imageProvider) {
                                              return Container(
                                                width: double.infinity,
                                                height: 180.0,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        fit: BoxFit.scaleDown,
                                                        image: imageProvider)),
                                              );
                                            },
                                            placeholder: (BuildContext context,
                                                String val) {
                                              return Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[200]!,
                                                child: Card(
                                                  margin: EdgeInsets.zero,
                                                  color: ColorResources.white,
                                                  elevation: 4.0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0)),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.0),
                                                        color: ColorResources
                                                            .white),
                                                  ),
                                                ),
                                              );
                                            },
                                            errorWidget: (BuildContext context,
                                                String text, dynamic _) {
                                              return Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[200]!,
                                                child: Card(
                                                  margin: EdgeInsets.zero,
                                                  color: ColorResources.white,
                                                  elevation: 4.0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0)),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.0),
                                                        color: ColorResources
                                                            .white),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                      if (bsm.feeds[i].media.length > 1)
                                        CarouselSlider.builder(
                                            options: CarouselOptions(
                                              autoPlay: false,
                                              height: 180.0,
                                              enlargeCenterPage: true,
                                              viewportFraction: 1.0,
                                              enlargeStrategy:
                                                  CenterPageEnlargeStrategy
                                                      .scale,
                                              initialPage: bsm.currentIndex,
                                              onPageChanged: (int i,
                                                  CarouselPageChangedReason
                                                      reason) {
                                                bsm.onChangeCurrentMultipleImg(
                                                    i);
                                              },
                                            ),
                                            itemCount:
                                                bsm.feeds[i].media.length,
                                            itemBuilder: (BuildContext context,
                                                int i, int z) {
                                              return CachedNetworkImage(
                                                imageUrl:
                                                    bsm.feeds[i].media[i].path,
                                                imageBuilder:
                                                    (BuildContext context,
                                                        ImageProvider
                                                            imageProvider) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            fit: BoxFit.contain,
                                                            image:
                                                                imageProvider)),
                                                  );
                                                },
                                                placeholder:
                                                    (BuildContext context,
                                                        String val) {
                                                  return Container(
                                                    decoration: const BoxDecoration(
                                                        image: DecorationImage(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            fit: BoxFit.contain,
                                                            image: AssetImage(
                                                                AssetsConst
                                                                    .imageDefault))),
                                                  );
                                                },
                                                errorWidget:
                                                    (BuildContext context,
                                                        String text,
                                                        dynamic _) {
                                                  return Container(
                                                    decoration: const BoxDecoration(
                                                        image: DecorationImage(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            fit: BoxFit.contain,
                                                            image: AssetImage(
                                                                AssetsConst
                                                                    .imageDefault))),
                                                  );
                                                },
                                              );
                                            }),
                                      if (bsm.feeds[i].media.length > 1)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: bsm.feeds[i].media.map((z) {
                                            int index =
                                                bsm.feeds[i].media.indexOf(z);
                                            return Container(
                                              width: 8.0,
                                              height: 8.0,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 2.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    bsm.currentIndexMultipleImg ==
                                                            index
                                                        ? ColorResources
                                                            .bluePrimary
                                                        : ColorResources
                                                            .dimGrey,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      if (bsm.feeds[i].feedType == "video")
                                        VideoPlay(
                                            dataSource:
                                                bsm.feeds[i].media[0].path),
                                      if (bsm.feeds[i].feedType == "document")
                                        Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.only(
                                              top: 15.0,
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                color: ColorResources
                                                    .greyDarkPrimary),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width: 150.0,
                                                      child: Text(
                                                          bsm.feeds[i].media[0]
                                                              .path
                                                              .split('/')
                                                              .last,
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              color:
                                                                  ColorResources
                                                                      .white,
                                                              fontSize: Dimensions
                                                                  .fontSizeLarge,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'SF Pro')),
                                                    ),
                                                    const SizedBox(height: 6.0),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                            "${getTranslated("FILE_SIZE")} :",
                                                            style: const TextStyle(
                                                                color:
                                                                    ColorResources
                                                                        .white,
                                                                fontSize: Dimensions
                                                                    .fontSizeLarge,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    'SF Pro')),
                                                        const SizedBox(
                                                            width: 8.0),
                                                        Text(
                                                            bsm.feeds[i].media[0].size
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color:
                                                                    ColorResources
                                                                        .white,
                                                                fontSize: Dimensions
                                                                    .fontSizeLarge,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    'SF Pro')),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.download),
                                                  onPressed: () async {
                                                    await DownloadHelper
                                                        .downloadDoc(
                                                            context: context,
                                                            url: bsm.feeds[i]
                                                                .media[0].path);
                                                  },
                                                  color: ColorResources.white,
                                                )
                                              ],
                                            )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
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
                                            await bsm.toggleLike(
                                                feedId: bsm.feeds[i].uid,
                                                feedLikes:
                                                    bsm.feeds[i].feedLikes);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: bsm.feeds[i].feedLikes.likes
                                                    .where((el) =>
                                                        el.user.uid ==
                                                        SharedPrefs.getUserId())
                                                    .isEmpty
                                                ? Image.asset(
                                                    AssetsConst.imageIcLove,
                                                    width: 18.0,
                                                  )
                                                : Image.asset(
                                                    AssetsConst.imageIcLoveFill,
                                                    width: 18.0,
                                                  ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15.0),
                                      Material(
                                        color: ColorResources.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          onTap: () {
                                            NS.push(
                                                context,
                                                CommentScreen(
                                                    feedId: bsm.feeds[i].uid));
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
                                                  bsm.feeds[i].feedComments
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
                                                  bsm.feeds[i].feedComments
                                                          .comments.isEmpty
                                                      ? const SizedBox()
                                                      : const SizedBox(
                                                          width: 12.0),
                                                  bsm.feeds[i].feedComments
                                                          .comments.isEmpty
                                                      ? const SizedBox()
                                                      : Text(
                                                          bsm
                                                              .feeds[i]
                                                              .feedComments
                                                              .comments
                                                              .length
                                                              .toString(),
                                                          style: const TextStyle(
                                                              color:
                                                                  ColorResources
                                                                      .white,
                                                              fontSize: Dimensions
                                                                  .fontSizeDefault,
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
                                            await bsm.toggleBookmark(
                                                feedId: bsm.feeds[i].uid,
                                                feedBookmarks:
                                                    bsm.feeds[i].feedBookmarks);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: bsm.feeds[i].feedBookmarks
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
