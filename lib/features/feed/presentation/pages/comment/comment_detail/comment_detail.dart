import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ppidunia/common/helpers/date_util.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/features/feed/data/models/detail.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_screen_model.dart';
import 'package:ppidunia/features/profil/presentation/pages/profile_view/profile_view_state.dart';
import 'package:ppidunia/features/profil/presentation/provider/profile.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:provider/provider.dart';

class CommentDetail extends StatefulWidget {
  final String feedId;
  final String comment_id;
  final String name;
  final String avatarUser;
  final String date;
  final String comment;
  final int index;
  const CommentDetail({
    Key? key,
    required this.avatarUser,
    required this.name,
    required this.date,
    required this.comment,
    required this.feedId,
    required this.index,
    required this.comment_id,
  }) : super(key: key);

  @override
  State<CommentDetail> createState() => _CommentDetailState();
}

class _CommentDetailState extends State<CommentDetail> {
  late CommentScreenModel csm;

  @override
  void initState() {
    super.initState();

    csm = context.read<CommentScreenModel>();

    csm.sc = ScrollController();
    csm.replyC = TextEditingController();

    if (mounted) {
      csm.getFeedDetail(feedId: widget.feedId);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.comment_id);
    debugPrint(widget.feedId);
    return Scaffold(
      backgroundColor: ColorResources.bgSecondaryColor,
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            CustomScrollView(
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
                    title: const SizedBox()),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 85.0),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate([
                    Consumer(builder: (BuildContext context,
                        CommentScreenModel c, Widget? child) {
                      if (c.commentStatus == CommentStatus.loading) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * .75,
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
                          height: MediaQuery.of(context).size.height * .75,
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
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              color: ColorResources.greyPrimary,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      color: ColorResources.greyPrimary),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              flex: 7,
                                              child: InkWell(
                                                onTap: () {
                                                  NS.push(
                                                    context,
                                                    ProfileViewScreen(
                                                      userId: c.feedDetailData
                                                          .user!.uid,
                                                    ),
                                                  );
                                                },
                                                child: CachedNetworkImage(
                                                  imageUrl: widget.avatarUser,
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
                                            ),
                                            Expanded(
                                              flex: 28,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      NS.push(
                                                          context,
                                                          ProfileViewScreen(
                                                              userId: c
                                                                  .feedDetailData
                                                                  .user!
                                                                  .uid));
                                                    },
                                                    child: Text(widget.name,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            color:
                                                                ColorResources
                                                                    .white,
                                                            fontSize: Dimensions
                                                                .fontSizeLarge,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                'SF Pro')),
                                                  ),
                                                  Text(
                                                      DateHelper.formatDateTime(
                                                          widget.date),
                                                      style: const TextStyle(
                                                          color: ColorResources
                                                              .greyDarkPrimary,
                                                          fontSize: Dimensions
                                                              .fontSizeExtraSmall,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              'SF Pro')),
                                                  Text(
                                                    widget.comment,
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: ColorResources
                                                            .hintColor,
                                                        fontSize: Dimensions
                                                            .fontSizeLarge,
                                                        fontFamily: 'SF Pro'),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shrinkWrap: true,
                              itemCount: c.comments[widget.index].commentReplies
                                  .replies.length,
                              itemBuilder: (_, z) {
                                Reply reply = c.comments[widget.index]
                                    .commentReplies.replies[z];
                                return Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(
                                      top: 8.0, left: 25.0, right: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              NS.push(
                                                context,
                                                ProfileViewScreen(
                                                  userId: c
                                                      .comments[widget.index]
                                                      .user
                                                      .uid,
                                                ),
                                              );
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: reply.user.avatar,
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
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  decoration:
                                                      const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          12.0)),
                                                          color: ColorResources
                                                              .greyPrimary),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          NS.push(
                                                            context,
                                                            ProfileViewScreen(
                                                              userId: c
                                                                  .comments[
                                                                      widget
                                                                          .index]
                                                                  .user
                                                                  .uid,
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                            reply.user.name,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
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
                                                      const SizedBox(
                                                          height: 5.0),
                                                      Text(
                                                        reply.reply,
                                                        maxLines: 4,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            color:
                                                                ColorResources
                                                                    .hintColor,
                                                            fontSize: Dimensions
                                                                .fontSizeLarge,
                                                            fontFamily:
                                                                'SF Pro'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]))
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              })
                        ],
                      );
                    })
                  ])),
                )
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                        color: ColorResources.bgSecondaryColor),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CachedNetworkImage(
                          imageUrl: context.read<ProfileProvider>().pd.avatar!,
                          imageBuilder: (BuildContext context,
                              ImageProvider imageProvider) {
                            return CircleAvatar(
                              backgroundImage: imageProvider,
                              maxRadius: 20.0,
                            );
                          },
                          placeholder: (BuildContext context, String url) {
                            return const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/default/ava.jpg'),
                              maxRadius: 20.0,
                            );
                          },
                          errorWidget: (BuildContext context, String url,
                              dynamic error) {
                            return const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/default/ava.jpg'),
                              maxRadius: 20.0,
                            );
                          },
                        ),
                        const SizedBox(width: 15.0),
                        Flexible(
                            child: TextField(
                          controller: csm.replyC,
                          cursorColor: ColorResources.greyLight,
                          maxLines: null,
                          style: const TextStyle(
                              color: ColorResources.white,
                              fontSize: Dimensions.fontSizeExtraLarge,
                              fontFamily: 'SF Pro'),
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 16.0),
                              fillColor: const Color(0xFF2E2E2E),
                              filled: true,
                              hintText: getTranslated("WRITE_COMMENT"),
                              hintStyle: const TextStyle(
                                  color: ColorResources.greyLight,
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontFamily: 'SF Pro'),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      width: 1.0,
                                      color: ColorResources.greyLight)),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      width: 1.0,
                                      color: ColorResources.greyLight)),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      width: 1.0,
                                      color: ColorResources.greyLight)),
                              errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      width: 1.0,
                                      color: ColorResources.greyLight))),
                        )),
                        const SizedBox(width: 15.0),
                        IconButton(
                            onPressed: () async {
                              await csm.postReply(
                                  feedId: widget.feedId,
                                  commentId: widget.comment_id);
                            },
                            icon: const Icon(
                              Icons.send,
                              color: ColorResources.greyLight,
                            ))
                      ],
                    )))
          ],
        );
      }),
    );
  }
}
