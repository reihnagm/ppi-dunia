import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/extensions/snackbar.dart';
import 'package:ppidunia/common/helpers/date_util.dart';
import 'package:ppidunia/common/utils/modals.dart';
import 'package:ppidunia/features/feed/data/models/detail.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_detail/comment_detail.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_state.dart';
import 'package:ppidunia/features/feed/presentation/pages/widgets/clipped_photo_view.dart';
import 'package:ppidunia/features/profil/presentation/pages/profile_view/profile_view_state.dart';
import 'package:ppidunia/features/profil/presentation/provider/profile.dart';
import 'package:ppidunia/views/basewidgets/card_posting/card_header_comment.dart';
import 'package:ppidunia/views/basewidgets/card_posting/card_header_posting.dart';
import 'package:ppidunia/views/basewidgets/detecttext/detect_text.dart';
import 'package:ppidunia/views/basewidgets/image/image_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/services/navigation.dart';

import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/common/utils/color_resources.dart';

import 'package:ppidunia/features/feed/presentation/pages/widgets/video.dart';

class CommentScreenState extends State<CommentScreen> {
  late CommentScreenModel csm;

  @override
  void initState() {
    super.initState();

    csm = context.read<CommentScreenModel>();

    csm.sc = ScrollController();
    csm.commentC = TextEditingController();

    if (mounted) {
      csm.getFeedDetail(feedId: widget.feedId);
    }

    if (mounted) {
      csm.carouselC = CarouselController();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    DateTime? loginClickTime;

    bool isRedundentClick(DateTime currentTime) {
      if (loginClickTime == null) {
        loginClickTime = currentTime;
        return false;
      }
      if (currentTime.difference(loginClickTime!).inSeconds < 2) {
        return true;
      }
      loginClickTime = currentTime;
      return false;
    }

    return Scaffold(
        backgroundColor: ColorResources.bgSecondaryColor,
        bottomNavigationBar: SizedBox(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              color: ColorResources.bgSecondaryColor
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [

                  CachedNetworkImage(
                    imageUrl: context.read<ProfileProvider>().pd.avatar!,
                    imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                      return CircleAvatar(
                        backgroundImage: imageProvider,
                        maxRadius: 20.0,
                      );
                    },
                    placeholder: (BuildContext context, String url) {
                      return const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/default/ava.jpg'),
                        maxRadius: 20.0,
                      );
                    },
                    errorWidget: (BuildContext context, String url, dynamic error) {
                      return const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/default/ava.jpg'),
                        maxRadius: 20.0,
                      );
                    },
                  ),
                  
                  const SizedBox(width: 15.0),

                  Flexible(
                    child: TextField(
                    controller: csm.commentC,
                    cursorColor: ColorResources.greyLight,
                    maxLines: 5,
                    minLines: 1,
                    style: const TextStyle(
                      color: ColorResources.white,
                      fontSize: Dimensions.fontSizeExtraLarge,
                      fontFamily: 'SF Pro'
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0.0, 
                        horizontal: 16.0
                      ),
                      fillColor: const Color(0xFF2E2E2E),
                      filled: true,
                      hintText: getTranslated("WRITE_COMMENT"),
                      hintStyle: const TextStyle(
                        color: ColorResources.greyLight,
                        fontSize: Dimensions.fontSizeDefault,
                        fontFamily: 'SF Pro'
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(
                          width: 1.0, 
                          color: ColorResources.greyLight
                        )
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(
                          width: 1.0, 
                          color: ColorResources.greyLight
                        )
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(
                          width: 1.0, 
                          color: ColorResources.greyLight
                        )
                      ),
                        errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(
                            width: 1.0,
                            color: ColorResources.greyLight
                          )
                        )
                      ),
                    )
                  ),
                  
                  const SizedBox(width: 15.0),

                  IconButton(
                    onPressed: () async {
                      if (isRedundentClick(DateTime.now())) {
                        //ShowSnackbar.snackbar(context, "Hold on, processing", '', ColorResources.error);
                        return;
                      }
                      await csm.post(feedId: widget.feedId);
                    },
                    icon: const Icon(
                      Icons.send,
                      color: ColorResources.greyLight,
                    )
                  )

                ],
              ),
            )
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return RefreshIndicator(
              onRefresh: () {
                return Future.sync(() {
                  csm.getFeedDetail(feedId: widget.feedId);
                });
              },
              child: NotificationListener(
                onNotification: (ScrollNotification notification) {
                  if (notification is ScrollEndNotification) {
                    if (notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                      if (csm.hasMore) {
                        csm.loadMoreComment(feedId: widget.feedId);
                      }
                    }
                  }
                  return false;
                },
                child: CustomScrollView(
                  controller: csm.sc,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverAppBar(
                      backgroundColor: ColorResources.transparent,
                      leading: CupertinoNavigationBarBackButton(
                        color: ColorResources.blue,
                        onPressed: () {
                          NS.pop(context);
                        },
                      ),
                      centerTitle: true,
                      title: const SizedBox()
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(bottom: 85.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          Consumer<CommentScreenModel>(
                            builder: (BuildContext context, CommentScreenModel c, Widget? child) {
                              if (c.feedDetailStatus ==
                                  FeedDetailStatus.loading) {
                                return Container();
                              }
                              if (c.feedDetailStatus ==
                                  FeedDetailStatus.empty) {
                                return Container();
                              }
                              if (c.feedDetailStatus ==
                                  FeedDetailStatus.error) {
                                return Container();
                              }
                              return Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      color: ColorResources.greyPrimary),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(
                                          left: 20.0,
                                          top: 15.0,
                                          right: 20.0
                                        ),
                                        child: CardHeaderPost(
                                          avatar: c.feedDetailData.user!.avatar, 
                                          name: c.feedDetailData.user!.name, 
                                          date: c.feedDetailData.createdAt!, 
                                          onSelected: (String route){}, 
                                          userId: c.feedDetailData.user!.uid, 
                                          isHidden: true,
                                        )
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 25.0,
                                            left: 25.0,
                                            bottom: 10.0,
                                            top: 5),
                                        child: DetectText(
                                            text: c.feedDetailData.caption!),
                                      ),
                                      if (c.feedDetailData.feedType == "image")
                                        if (c.feedDetailData.media!.length == 1)
                                          InkWell(
                                            onTap: () => NS.push(
                                              context,
                                              ClippedPhotoView(
                                                image: c.feedDetailData
                                                    .media![0].path,
                                              ),
                                            ),
                                            child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 25.0,
                                                    right: 25.0,
                                                    top: 5.0,
                                                    bottom: 20),
                                                child: imageCard(
                                                    c.feedDetailData.media![0]
                                                        .path,
                                                    180.0,
                                                    12.0)),
                                          ),
                                      if (c.feedDetailData.media!.length > 1)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0),
                                          child: CarouselSlider.builder(
                                              carouselController: c.carouselC,
                                              options: CarouselOptions(
                                                autoPlay: false,
                                                height: 180.0,
                                                enlargeCenterPage: true,
                                                viewportFraction: 1.0,
                                                enlargeStrategy:
                                                    CenterPageEnlargeStrategy
                                                        .scale,
                                                initialPage: c.currentIndex,
                                                onPageChanged: (int i,
                                                    CarouselPageChangedReason
                                                        reason) {
                                                  c.onChangeCurrentMultipleImg(
                                                      i);
                                                },
                                              ),
                                              itemCount: c
                                                  .feedDetailData.media!.length,
                                              itemBuilder:
                                                  (BuildContext context, int i,
                                                      int z) {
                                                return InkWell(
                                                  onTap: () => NS.push(
                                                    context,
                                                    ClippedPhotoView(
                                                      image: c.feedDetailData
                                                          .media![i].path,
                                                    ),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl: c.feedDetailData
                                                        .media![i].path,
                                                    imageBuilder:
                                                        (BuildContext context,
                                                            ImageProvider
                                                                imageProvider) {
                                                      return Container(
                                                        width: double.infinity,
                                                        height: 180.0,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            image: DecorationImage(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                fit: BoxFit
                                                                    .cover,
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
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: AssetImage(
                                                                    AssetsConst
                                                                        .imageDefault))),
                                                      );
                                                    },
                                                    errorWidget: (BuildContext context, String text, dynamic _) {
                                                      return Container(
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                alignment: Alignment.centerLeft,
                                                                fit: BoxFit.cover,
                                                                image: AssetImage(AssetsConst.imageDefault))),
                                                      );
                                                    },
                                                  ),
                                                );
                                              }),
                                        ),
                                      if (c.feedDetailData.media!.length > 1)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0,
                                            vertical: 10.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: c.feedDetailData.media!
                                                .map((i) {
                                              int index = c
                                                  .feedDetailData.media!
                                                  .indexOf(i);
                                              return Container(
                                                width: 8.0,
                                                height: 8.0,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 2.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: c.currentIndexMultipleImg ==
                                                          index
                                                      ? ColorResources
                                                          .bluePrimary
                                                      : ColorResources.dimGrey,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      if (c.feedDetailData.feedType == "video")
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0,
                                            vertical: 10.0,
                                          ),
                                          child: VideoPlay(
                                              dataSource: c.feedDetailData
                                                  .media![0].path),
                                        ),
                                      if (c.feedDetailData.feedType ==
                                          "document")
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14.0, vertical: 10.0),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 14.0, vertical: 12.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              color: ColorResources
                                                  .greyDarkPrimary),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
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
                                                        c.feedDetailData
                                                            .media![0].path
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
                                                                .fontSizeDefault,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                                  .fontSizeDefault,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'SF Pro')),
                                                      const SizedBox(
                                                          width: 8.0),
                                                      Text(
                                                          c.feedDetailData
                                                              .media![0].size
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
                                                                  'SF Pro')),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              IconButton(
                                                icon:
                                                    const Icon(Icons.download),
                                                onPressed: () async {
                                                  await c.downloadDoc(
                                                      context,
                                                      c.feedDetailData.media![0]
                                                          .path);
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
                                                bottomLeft:
                                                    Radius.circular(12.0),
                                                bottomRight:
                                                    Radius.circular(12.0))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 16.0, right: 16.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Material(
                                                    color: ColorResources
                                                        .transparent,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      onTap: () async {
                                                        await c.toggleLike(
                                                            feedId: c
                                                                .feedDetailData
                                                                .uid!,
                                                            feedLikes: c
                                                                .feedDetailData
                                                                .feedLikes!);
                                                      },
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              c
                                                                      .feedDetailData
                                                                      .feedLikes!
                                                                      .likes
                                                                      .where((el) =>
                                                                          el.user
                                                                              .uid ==
                                                                          SharedPrefs
                                                                              .getUserId())
                                                                      .isEmpty
                                                                  ? Image.asset(
                                                                      AssetsConst
                                                                          .imageIcLove,
                                                                      width:
                                                                          18.0,
                                                                    )
                                                                  : Image.asset(
                                                                      AssetsConst
                                                                          .imageIcLoveFill,
                                                                      width:
                                                                          18.0,
                                                                    ),
                                                              c
                                                                      .feedDetailData
                                                                      .feedLikes!
                                                                      .likes
                                                                      .isEmpty
                                                                  ? const SizedBox()
                                                                  : const SizedBox(
                                                                      width:
                                                                          12.0),
                                                              c
                                                                      .feedDetailData
                                                                      .feedLikes!
                                                                      .likes
                                                                      .isEmpty
                                                                  ? const SizedBox()
                                                                  : Text(c.feedDetailData.feedLikes!.total.toString(),
                                                                      style: const TextStyle(
                                                                          color: ColorResources
                                                                              .white,
                                                                          fontSize: Dimensions
                                                                              .fontSizeDefault,
                                                                          fontWeight: FontWeight
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
                                                    color: ColorResources
                                                        .transparent,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      onTap: () {},
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              c
                                                                      .feedDetailData
                                                                      .feedComments!
                                                                      .comments
                                                                      .isEmpty
                                                                  ? Image.asset(
                                                                      AssetsConst
                                                                          .imageIcChat,
                                                                      width:
                                                                          18.0,
                                                                    )
                                                                  : Image.asset(
                                                                      AssetsConst
                                                                          .imageIcChatFill,
                                                                      width:
                                                                          18.0,
                                                                    ),
                                                              c
                                                                      .feedDetailData
                                                                      .feedComments!
                                                                      .comments
                                                                      .isEmpty
                                                                  ? const SizedBox()
                                                                  : const SizedBox(
                                                                      width:
                                                                          12.0),
                                                              c
                                                                      .feedDetailData
                                                                      .feedComments!
                                                                      .comments
                                                                      .isEmpty
                                                                  ? const SizedBox()
                                                                  : Text(
                                                                      c
                                                                          .feedDetailData
                                                                          .feedComments!
                                                                          .total
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          color: ColorResources
                                                                              .white,
                                                                          fontSize: Dimensions
                                                                              .fontSizeDefault,
                                                                          fontWeight: FontWeight
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
                                                    color: ColorResources
                                                        .transparent,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      onTap: () async {
                                                        await c.toggleBookmark(
                                                            feedId: c
                                                                .feedDetailData
                                                                .uid!,
                                                            feedBookmarks: c
                                                                .feedDetailData
                                                                .feedBookmarks!);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: c
                                                                .feedDetailData
                                                                .feedBookmarks!
                                                                .bookmarks
                                                                .where((el) =>
                                                                    el.user
                                                                        .uid ==
                                                                    SharedPrefs
                                                                        .getUserId())
                                                                .isEmpty
                                                            ? Image.asset(
                                                                'assets/images/icons/ic-save.png',
                                                                width: 18.0,
                                                              )
                                                            : Image.asset(
                                                                AssetsConst
                                                                    .imageIcSaveFill,
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
                                  )
                              );
                            },
                          ),
                          Consumer<CommentScreenModel>(
                            builder: (BuildContext context,
                                CommentScreenModel c, Widget? child) {
                              if (c.commentStatus == CommentStatus.loading) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .75,
                                  child: const Center(
                                    child: SpinKitCubeGrid(
                                      color: ColorResources.greyLightPrimary,
                                      size: 30.0,
                                    ),
                                  ),
                                );
                              }
                              if (c.commentStatus == CommentStatus.empty) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .75,
                                  child: Center(
                                    child: Text(getTranslated("NO_COMMENT"),
                                        style: const TextStyle(
                                            color: ColorResources.white,
                                            fontSize: Dimensions.fontSizeLarge,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'SF Pro')),
                                  ),
                                );
                              }
                              if (c.commentStatus == CommentStatus.error) {
                                return Container();
                              }

                              return ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int i) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        left: 10.0, right: 25.0),
                                    child: const SizedBox(),
                                  );
                                },
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: c.comments.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(
                                        top: 20.0,
                                        left: 25.0,
                                        right: 16.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  NS.push(
                                                    context,
                                                    ProfileViewScreen(
                                                      userId: c
                                                          .comments[i].user.uid,
                                                    ),
                                                  );
                                                },
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      c.comments[i].user.avatar,
                                                  imageBuilder:
                                                      (BuildContext context,
                                                          ImageProvider<Object>
                                                              imageProvider) {
                                                    return CircleAvatar(
                                                      radius: 20.0,
                                                      backgroundImage:
                                                          imageProvider,
                                                    );
                                                  },
                                                  placeholder:
                                                      (BuildContext context,
                                                          String url) {
                                                    return const CircleAvatar(
                                                      radius: 20.0,
                                                      backgroundColor:
                                                          Color(0xFF637687),
                                                    );
                                                  },
                                                  errorWidget:
                                                      (BuildContext context,
                                                          String url,
                                                          dynamic error) {
                                                    return const CircleAvatar(
                                                      radius: 20.0,
                                                      backgroundColor:
                                                          Color(0xFF637687),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 12.0),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(context, NS.fromLeft(CommentDetail(feedId: widget.feedId, commentId: c.comments[i].uid,))).then((_) => setState(() {
                                                          csm.getFeedDetail(feedId: widget.feedId);
                                                        }));
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding: const EdgeInsets.only(
                                                          left: 15.0,
                                                          top: 5.0,
                                                          right: 15.0,
                                                          bottom: 20.0
                                                        ),
                                                        decoration: const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        12.0)),
                                                            color: ColorResources
                                                                .greyPrimary),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            CardHeaderComment(
                                                              name: c.comments[i].user.name, 
                                                              date: c.comments[i].createdAt, 
                                                              userId: c.comments[i].user.uid, 
                                                              onSelected: (String route) async {
                                                                GeneralModal.showConfirmModals(
                                                                  image: AssetsConst.imageIcPopUpDelete,
                                                                  msg: "Are you sure want to delete ?",
                                                                  onPressed: () async {
                                                                    if (route == "/delete") {
                                                                      await csm.deleteComment(feedId: widget.feedId, deleteId: c.comments[i].uid);
                                                                    }
                                                                    Future.delayed(Duration.zero, () {
                                                                      NS.pop(context);
                                                                      ShowSnackbar.snackbar(context, "Successfully delete a comments", '', ColorResources.success);
                                                                    });
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                            c.comments[i].user.uid == SharedPrefs.getUserId()
                                                            ? Container()
                                                            : const SizedBox(
                                                                height: 10,
                                                              ),
                                                            DetectText(text: c.comments[i].comment),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(context, NS.fromLeft(CommentDetail(feedId: widget.feedId, commentId: c.comments[i].uid,))).then((_) => setState(() {
                                                          csm.getFeedDetail(feedId: widget.feedId);
                                                        }));
                                                      },
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          "Balas (${c.comments[i].commentReplies.total})",
                                                          style: const TextStyle(
                                                              fontSize: Dimensions
                                                                  .fontSizeDefault,
                                                              color:
                                                                  Colors.white),
                                                          textAlign:
                                                              TextAlign.end,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          ListView.builder(
                                              padding: const EdgeInsets.symmetric(horizontal: 40),
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: c.comments[i].commentReplies.replies.length < 2
                                                  ? c.comments[i].commentReplies.replies.length
                                                  : 2,
                                              itemBuilder: (_, z) {
                                                Reply reply = c.comments[i]
                                                    .commentReplies.replies[z];
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.push(context, NS.fromLeft(CommentDetail(feedId: widget.feedId, commentId: c.comments[i].uid,))).then((_) => setState(() {
                                                      csm.getFeedDetail(feedId: widget.feedId);
                                                    }));
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CachedNetworkImage(
                                                              imageUrl: reply
                                                                  .user.avatar,
                                                              imageBuilder: (BuildContext
                                                                      context,
                                                                  ImageProvider<
                                                                          Object>
                                                                      imageProvider) {
                                                                return CircleAvatar(
                                                                  radius: 10.0,
                                                                  backgroundImage:
                                                                      imageProvider,
                                                                );
                                                              },
                                                              placeholder:
                                                                  (BuildContext
                                                                          context,
                                                                      String
                                                                          url) {
                                                                return const CircleAvatar(
                                                                  radius: 10.0,
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xFF637687),
                                                                );
                                                              },
                                                              errorWidget:
                                                                  (BuildContext
                                                                          context,
                                                                      String
                                                                          url,
                                                                      dynamic
                                                                          error) {
                                                                return const CircleAvatar(
                                                                  radius: 10.0,
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xFF637687),
                                                                );
                                                              },
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: MediaQuery.of(context).size.width < 400 ? 195 : 250,
                                                                        child: FittedBox(
                                                                          fit: BoxFit.scaleDown,
                                                                          alignment: Alignment.centerLeft,
                                                                          child: Text(
                                                                            reply.user.name,
                                                                            maxLines: 1,
                                                                            style: const TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                      DateHelper.formatDateTime(
                                                                          reply
                                                                              .createdAt),
                                                                      style: const TextStyle(
                                                                          color: ColorResources
                                                                              .greyDarkPrimary,
                                                                          fontSize: Dimensions
                                                                              .fontSizeExtraSmall,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontFamily:
                                                                              'SF Pro')),
                                                                  DetectText(
                                                                      text: reply
                                                                          .reply),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              })
                                        ],
                                      ));
                                },
                              );
                            },
                          )
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
