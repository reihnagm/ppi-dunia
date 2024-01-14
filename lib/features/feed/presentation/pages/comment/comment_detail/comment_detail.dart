import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/extensions/snackbar.dart';
import 'package:ppidunia/common/helpers/date_util.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/utils/modals.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/features/feed/data/models/reply.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_detail/comment_detail_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_screen_model.dart';
import 'package:ppidunia/features/profil/presentation/pages/profile_view/profile_view_state.dart';
import 'package:ppidunia/features/profil/presentation/provider/profile.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:provider/provider.dart';

class CommentDetail extends StatefulWidget {
  final String feedId;
  const CommentDetail({
    Key? key,
    required this.feedId,
  }) : super(key: key);

  @override
  State<CommentDetail> createState() => _CommentDetailState();
}

class _CommentDetailState extends State<CommentDetail> {
  late CommentDetailModel cdm;

  @override
  void initState() {
    super.initState();

    cdm = context.read<CommentDetailModel>();

    cdm.sc = ScrollController();
    cdm.replyC = TextEditingController();

    if (mounted) {
      cdm.getReplyDetail(feedId: widget.feedId);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Comment ID ${widget.feedId}");
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
                        CommentDetailModel c, Widget? child) {
                      if (c.replyStatus == ReplyStatus.loading) {
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
                      if (c.replyStatus == CommentStatus.empty) {
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
                      if (c.replyStatus == CommentStatus.error) {
                        return Container();
                      }
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(2),
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
                                    vertical: 10.0,
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
                                                // onTap: () {
                                                //   NS.push(
                                                //     context,
                                                //     ProfileViewScreen(
                                                //       userId: widget.uid,
                                                //     ),
                                                //   );
                                                // },
                                                child: CachedNetworkImage(
                                                  imageUrl: c.replyDetailData.user!.avatar,
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
                                                    // onTap: () {
                                                    //   NS.push(
                                                    //       context,
                                                    //       ProfileViewScreen(
                                                    //           userId: widget.uid));
                                                    // },
                                                    child: Text(c.replyDetailData.user!.name,
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
                                                      DateHelper.formatDateTime(c.replyDetailData.createdAt!),
                                                      style: const TextStyle(
                                                          color: ColorResources
                                                              .greyDarkPrimary,
                                                          fontSize: Dimensions
                                                              .fontSizeExtraSmall,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              'SF Pro')),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                            padding: const EdgeInsets.only(
                                                right: 25.0,
                                                left: 25.0,
                                                bottom: 10.0,),
                                            child: Text("${c.replyDetailData.caption}",
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
                              itemCount: c.replyDetailData.feedReplies!.total,
                              itemBuilder: (_, z) {
                                Reply reply = c.replyDetailData.feedReplies!.replies[z];
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              NS.push(
                                                context,
                                                ProfileViewScreen(
                                                  userId: reply.user.uid,
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
                                                  width: double.infinity,
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
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  NS.push(
                                                                    context,
                                                                    ProfileViewScreen(
                                                                      userId: reply.user.uid,
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
                                                          Text(
                                                          DateHelper
                                                              .formatDateTime(reply.createdAt),
                                                          style: const TextStyle(
                                                              color: ColorResources
                                                                  .greyDarkPrimary,
                                                              fontSize:
                                                                  Dimensions
                                                                      .fontSizeExtraSmall,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'SF Pro')),
                                                            ],
                                                          ),
                                                          reply.user.uid ==
                                                                SharedPrefs.getUserId()
                                                            ? PopupMenuButton(
                                                                color: Colors.white,
                                                                iconColor: Colors.white,
                                                                iconSize: 20,
                                                                itemBuilder:
                                                                    (BuildContext buildContext) {
                                                                  return [
                                                                    PopupMenuItem(
                                                                        value: "/delete",
                                                                        child: Text(
                                                                            getTranslated("DELETE"),
                                                                            style: const TextStyle(
                                                                                color: ColorResources
                                                                                    .greyDarkPrimary,
                                                                                fontSize: Dimensions
                                                                                    .fontSizeDefault,
                                                                                fontWeight:
                                                                                    FontWeight.w600,
                                                                                fontFamily:
                                                                                    'SF Pro'))),
                                                                  ];
                                                                },
                                                                onSelected: (String route) async {
                                                                  GeneralModal.showConfirmModals(
                                                                          image: AssetsConst
                                                                              .imageIcPopUpDelete,
                                                                          msg:
                                                                              "Are you sure want to delete ?",
                                                                          onPressed: () async {
                                                                            if (route ==
                                                                                "/delete") {
                                                                              // await pp.delete(feedId: pp.feeds[i].uid);
                                                                              // await csm.deleteReply(feedId: widget.feedId, deleteId: reply.uid);
                                                                            }
                                                                            NS.pop(context);
                                                                            ShowSnackbar.snackbar(
                                                                                context,
                                                                                "Successfully delete a reply",
                                                                                '',
                                                                                ColorResources
                                                                                    .success);
                                                                    },
                                                                  );
                                                                },
                                                              )
                                                            : const SizedBox(),
                                                        ],
                                                      ),
                                                      reply.user.uid ==
                                                                    SharedPrefs.getUserId() ? Container() :const SizedBox(height: 10,),
                                                            Text(
                                                            reply.reply,
                                                            overflow: TextOverflow
                                                                .visible,
                                                                softWrap: true,
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
                                              ])),
                                        ],
                                      ),
                                    ],
                                  ),
                                );}),
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
                          controller: cdm.replyC,
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
                              // await cdm.postReply(
                              //     feedId: widget.feedId,
                              //     commentId: widget.commentId);
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
