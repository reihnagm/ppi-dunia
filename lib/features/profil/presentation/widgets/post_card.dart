import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/helpers/download_util.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_state.dart';
import 'package:ppidunia/features/feed/presentation/pages/widgets/clipped_photo_view.dart';
import 'package:ppidunia/features/feed/presentation/pages/widgets/video.dart';
import 'package:ppidunia/features/profil/presentation/provider/profile.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/basewidgets/image/image_card.dart';
import 'package:provider/provider.dart';

Widget postCard({
  required ProfileProvider pp,
}) {
  return Consumer<ProfileProvider>(
    builder: (BuildContext context, ProfileProvider pp, Widget? child) {
      if (pp.feedStatus == FeedStatus.loading) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .75,
          child: const SpinKitCubeGrid(
            color: ColorResources.greyLightPrimary,
            size: 30.0,
          ),
        );
      }

      if (pp.feedStatus == FeedStatus.error) {
        return SizedBox(
            height: 150.0,
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

      if (pp.feedStatus == FeedStatus.empty) {
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          shrinkWrap: true,
          itemCount: pp.feeds.length,
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
                      NS.push(context, CommentScreen(feedId: pp.feeds[i].uid));
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
                                  imageUrl: pp.feeds[i].user.avatar,
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
                                      backgroundImage:
                                          AssetImage(AssetsConst.imageLogoPpi),
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 28,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              child: Text(pp.feeds[i].user.name,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color:
                                                          ColorResources.white,
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
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'SF Pro')),
                                            const SizedBox(width: 5.0),
                                            Text(pp.feeds[i].createdAt,
                                                style: const TextStyle(
                                                    color: ColorResources
                                                        .greyDarkPrimary,
                                                    fontSize: Dimensions
                                                        .fontSizeExtraSmall,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'SF Pro')),
                                          ],
                                        ),
                                        pp.feeds[i].user.uid ==
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
                                                                fontSize: Dimensions
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
                                                    await pp.delete(
                                                        feedId:
                                                            pp.feeds[i].uid);
                                                  }
                                                },
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      pp.feeds[i].caption,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 4,
                                      style: const TextStyle(
                                          color: ColorResources.hintColor,
                                          fontSize:
                                              Dimensions.fontSizeOverLarge,
                                          fontFamily: 'SF Pro'),
                                    ),
                                    const SizedBox(height: 8.0),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        if (pp.feeds[i].feedType == "image")
                          if (pp.feeds[i].media.length == 1)
                            InkWell(
                              onTap: () => NS.push(
                                context,
                                ClippedPhotoView(
                                  image: pp.feeds[i].media[0].path,
                                ),
                              ),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 20.0),
                                  child: imageCard(
                                      pp.feeds[i].media[0].path, 180.0, 12.0)),
                            ),
                        if (pp.feeds[i].media.length > 1)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: CarouselSlider.builder(
                                  options: CarouselOptions(
                                    autoPlay: false,
                                    height: 180.0,
                                    enlargeCenterPage: true,
                                    viewportFraction: 1.0,
                                    enlargeStrategy:
                                        CenterPageEnlargeStrategy.scale,
                                    initialPage: pp.currentIndex,
                                    onPageChanged: (int i,
                                        CarouselPageChangedReason reason) {
                                      pp.onChangeCurrentMultipleImg(i);
                                    },
                                  ),
                                  itemCount: pp.feeds[i].media.length,
                                  itemBuilder:
                                      (BuildContext context, int x, int z) {
                                    return InkWell(
                                      onTap: () => NS.push(
                                        context,
                                        ClippedPhotoView(
                                          image: pp.feeds[i].media[x].path,
                                        ),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: pp.feeds[i].media[x].path,
                                        imageBuilder: (BuildContext context,
                                            ImageProvider imageProvider) {
                                          return Container(
                                            decoration: BoxDecoration(
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
                          ),
                        if (pp.feeds[i].media.length > 1)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: pp.feeds[i].media.map((z) {
                                int index = pp.feeds[i].media.indexOf(z);
                                return Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: pp.currentIndexMultipleImg == index
                                        ? ColorResources.bluePrimary
                                        : ColorResources.dimGrey,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        if (pp.feeds[i].feedType == "video")
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 10.0),
                              child: VideoPlay(
                                  dataSource: pp.feeds[i].media[0].path)),
                        if (pp.feeds[i].feedType == "document")
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 150.0,
                                      child: Text(
                                          pp.feeds[i].media[0].path
                                              .split('/')
                                              .last,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: ColorResources.white,
                                              fontSize:
                                                  Dimensions.fontSizeDefault,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'SF Pro')),
                                    ),
                                    const SizedBox(height: 6.0),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text("${getTranslated("FILE_SIZE")} :",
                                            style: const TextStyle(
                                                color: ColorResources.white,
                                                fontSize:
                                                    Dimensions.fontSizeDefault,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'SF Pro')),
                                        const SizedBox(width: 8.0),
                                        Text(
                                            pp.feeds[i].media[0].size
                                                .toString(),
                                            style: const TextStyle(
                                                color: ColorResources.white,
                                                fontSize:
                                                    Dimensions.fontSizeDefault,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'SF Pro')),
                                      ],
                                    )
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.download),
                                  onPressed: () async {
                                    await DownloadHelper.downloadDoc(
                                        context: context,
                                        url: pp.feeds[i].media[0].path);
                                  },
                                  color: ColorResources.white,
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
                                          await pp.toggleLike(
                                              feedId: pp.feeds[i].uid,
                                              feedLikes: pp.feeds[i].feedLikes);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: pp.feeds[i].feedLikes.likes
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
                                                  feedId: pp.feeds[i].uid));
                                        },
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                pp.feeds[i].feedComments
                                                        .comments.isEmpty
                                                    ? Image.asset(
                                                        AssetsConst.imageIcChat,
                                                        width: 18.0,
                                                      )
                                                    : Image.asset(
                                                        AssetsConst
                                                            .imageIcChatFill,
                                                        width: 18.0,
                                                      ),
                                                pp.feeds[i].feedComments
                                                        .comments.isEmpty
                                                    ? const SizedBox()
                                                    : const SizedBox(
                                                        width: 12.0),
                                                pp.feeds[i].feedComments
                                                        .comments.isEmpty
                                                    ? const SizedBox()
                                                    : Text(
                                                        pp.feeds[i].feedComments
                                                            .comments.length
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                ColorResources
                                                                    .white,
                                                            fontSize: Dimensions
                                                                .fontSizeDefault,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                          await pp.toggleBookmark(
                                              feedId: pp.feeds[i].uid,
                                              feedBookmarks:
                                                  pp.feeds[i].feedBookmarks);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: pp.feeds[i].feedBookmarks
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
