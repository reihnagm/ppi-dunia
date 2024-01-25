import 'package:cached_network_image/cached_network_image.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
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
import 'package:ppidunia/views/basewidgets/detecttext/detect_text.dart';
import 'package:ppidunia/views/webview/webview.dart';
import 'package:provider/provider.dart';

class CommentDetail extends StatefulWidget {
  final String commentId;
  final String? feedId;
  const CommentDetail({
    Key? key,
    required this.commentId,
    this.feedId,
  }) : super(key: key);

  @override
  State<CommentDetail> createState() => _CommentDetailState();
}

class _CommentDetailState extends State<CommentDetail> {
  Dio? dioClient;
  late CommentDetailModel cdm;
  late ProfileProvider pp;
  late CommentScreenModel csm;

  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();

  @override
  void initState() {
    super.initState();

    cdm = context.read<CommentDetailModel>();
    pp = context.read<ProfileProvider>();
    csm = context.read<CommentScreenModel>();

    cdm.sc = ScrollController();
    cdm.replyC = TextEditingController();

    if (mounted) {
      cdm.getReplyDetail(commentId: widget.commentId);
    }

    if (mounted) {
      csm.getFeedDetail(feedId: widget.feedId ?? "");
    }

    if (mounted) {
      pp.getUserMention();
    }
  }

  @override
  void dispose() {
    super.dispose();
    pp.clearMention();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? loginClickTime;

    bool isRedundentClick(DateTime currentTime) {
      if (loginClickTime == null) {
        loginClickTime = currentTime;
        print("first click");
        return false;
      }
      print('diff is ${currentTime.difference(loginClickTime!).inSeconds}');
      if (currentTime.difference(loginClickTime!).inSeconds < 10) {
        // set this difference time in seconds
        return true;
      }

      loginClickTime = currentTime;
      return false;
    }

    debugPrint("Feed ID : ${widget.feedId}");
    debugPrint("Comment ID : ${widget.commentId}");
    return Scaffold(
      backgroundColor: ColorResources.bgSecondaryColor,
      bottomNavigationBar: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: const EdgeInsets.all(12.0),
                decoration:
                    const BoxDecoration(color: ColorResources.bgSecondaryColor),
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
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
                        errorWidget:
                            (BuildContext context, String url, dynamic error) {
                          return const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/default/ava.jpg'),
                            maxRadius: 20.0,
                          );
                        },
                      ),
                      const SizedBox(width: 15.0),
                      Flexible(
                          child: FlutterMentions(
                              key: key,
                              onMarkupChanged: (value) {
                                debugPrint(value);
                              },
                              suggestionPosition: SuggestionPosition.Top,
                              onMentionAdd: (Map<String, dynamic> data) {
                                pp.setMention(
                                  id: data['id'],
                                );
                              },
                              onSuggestionVisibleChanged: (data) {
                                debugPrint(data.toString());
                                // if (data == false) {
                                //   pp.clearMention();
                                // }
                              },
                              // maxLines: 0,rRR
                              appendSpaceOnAdd: true,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
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
                                        color: ColorResources.greyLight)),
                              ),
                              mentions: [
                            Mention(
                                trigger: '@',
                                style: const TextStyle(
                                  color: Colors.blue,
                                ),
                                data: pp.usermentiondata,
                                disableMarkup: true,
                                matchAll: true,
                                suggestionBuilder: (Map<String, dynamic> data) {
                                  return Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        data['photo'] == "-" ||
                                                data['photo'] == "" ||
                                                data['photo'] == null
                                            ? const CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'assets/images/default/ava.jpg'),
                                              )
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                data['photo'],
                                              )),
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                                '@${data['display'].toString().replaceAll(' ', '')}'),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ])),
                      const SizedBox(width: 15.0),
                      IconButton(
                          onPressed: () async {
                            if (isRedundentClick(DateTime.now())) {
                              ShowSnackbar.snackbar(
                                  context,
                                  "Hold on, processing",
                                  '',
                                  ColorResources.redHealth);
                              return;
                            }
                            final notifier = context.read<ProfileProvider>();

                            var seen = <String>{};
                            List<String> uniquelist = notifier.mentionData
                                .where((mention) => seen.add(mention))
                                .toSet()
                                .toList();

                            await cdm.postReplyMention(
                                feedId: widget.feedId,
                                commentId: widget.commentId,
                                reply: key.currentState!.controller!.text,
                                receivers: uniquelist);

                            key.currentState!.controller!.text = "";
                            pp.clearMention();
                          },
                          icon: const Icon(
                            Icons.send,
                            color: ColorResources.greyLight,
                          ))
                    ],
                  ),
                ))
          ],
        ),
      ),
      body: Consumer(
        builder: (
          BuildContext context,
          ProfileProvider pp,
          Widget? child,
        ) {
          return RefreshIndicator(
            onRefresh: () {
              return Future.sync(() {
                cdm.getReplyDetail(commentId: widget.commentId);
                pp.getUserMention();
              });
            },
            child: NotificationListener(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollEndNotification) {
                  if (notification.metrics.pixels ==
                      notification.metrics.maxScrollExtent) {
                    if (cdm.hasMore) {
                      cdm.loadMoreReply(commentId: widget.commentId);
                    }
                  }
                }
                return false;
              },
              child: CustomScrollView(
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
                                                    imageUrl: c.replyDetailData
                                                        .user!.avatar,
                                                    imageBuilder: (BuildContext
                                                            context,
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
                                                        backgroundImage:
                                                            AssetImage(AssetsConst
                                                                .imageDefaultAva),
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      // onTap: () {
                                                      //   NS.push(
                                                      //       context,
                                                      //       ProfileViewScreen(
                                                      //           userId: widget.uid));
                                                      // },
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            c.replyDetailData
                                                                .user!.name,
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
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    'SF Pro')),
                                                      ),
                                                    ),
                                                    Text(
                                                        DateHelper
                                                            .formatDateTime(c
                                                                .replyDetailData
                                                                .createdAt!),
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
                                            bottom: 10.0,
                                          ),
                                          child: DetectText(
                                              text:
                                                  '${c.replyDetailData.caption}'),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                shrinkWrap: true,
                                itemCount: c.replyDetailData.feedReplies!.total,
                                itemBuilder: (_, z) {
                                  Reply reply =
                                      c.replyDetailData.feedReplies!.replies[z];
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    decoration: const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    12.0)),
                                                        color: ColorResources
                                                            .greyPrimary),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    NS.push(
                                                                      context,
                                                                      ProfileViewScreen(
                                                                        userId: reply
                                                                            .user
                                                                            .uid,
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      SizedBox(
                                                                    width: MediaQuery.sizeOf(context).width <
                                                                            400
                                                                        ? 180
                                                                        : 240,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child: Text(
                                                                          reply
                                                                              .user
                                                                              .name,
                                                                          maxLines:
                                                                              2,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          style: const TextStyle(
                                                                              color: ColorResources.white,
                                                                              fontSize: Dimensions.fontSizeSmall,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontFamily: 'SF Pro')),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                        5.0),
                                                                Text(
                                                                    DateHelper
                                                                        .formatDateTime(reply
                                                                            .createdAt),
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
                                                                    SharedPrefs
                                                                        .getUserId()
                                                                ? PopupMenuButton(
                                                                    color: Colors
                                                                        .white,
                                                                    iconColor:
                                                                        Colors
                                                                            .white,
                                                                    iconSize:
                                                                        20,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                            buildContext) {
                                                                      return [
                                                                        PopupMenuItem(
                                                                            value:
                                                                                "/delete",
                                                                            child:
                                                                                Text(getTranslated("DELETE"), style: const TextStyle(color: ColorResources.greyDarkPrimary, fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w600, fontFamily: 'SF Pro'))),
                                                                      ];
                                                                    },
                                                                    onSelected:
                                                                        (String
                                                                            route) async {
                                                                      GeneralModal
                                                                          .showConfirmModals(
                                                                        image: AssetsConst
                                                                            .imageIcPopUpDelete,
                                                                        msg:
                                                                            "Are you sure want to delete ?",
                                                                        onPressed:
                                                                            () async {
                                                                          if (route ==
                                                                              "/delete") {
                                                                            await cdm.deleteReply(
                                                                                commentId: widget.commentId,
                                                                                deleteId: reply.uid);
                                                                          }
                                                                          NS.pop(
                                                                              context);
                                                                          ShowSnackbar.snackbar(
                                                                              context,
                                                                              "Successfully delete a comments",
                                                                              '',
                                                                              ColorResources.success);
                                                                        },
                                                                      );
                                                                    },
                                                                  )
                                                                : const SizedBox(),
                                                          ],
                                                        ),
                                                        reply.user.uid ==
                                                                SharedPrefs
                                                                    .getUserId()
                                                            ? Container()
                                                            : const SizedBox(
                                                                height: 10,
                                                              ),
                                                        Wrap(
                                                          children: List.generate(
                                                              reply.feedMention
                                                                  .length,
                                                              (index) {
                                                            return DetectableText(
                                                              onTap: (p0) { 
                                                                if(p0.contains(RegExp('@[a-zA-Z0-9_.]+?(?![a-zA-Z0-9_.])'))){
                                                                  NS.push(context, ProfileViewScreen(userId: reply.feedMention[index].id));
                                                                }else{
                                                                  NS.push(context, NS.push(context, WebViewScreen(url: p0, title: "PPI-DUNIA")));
                                                                }
                                                              },
                                                              text:
                                                                  '${reply.feedMention[index].name} ${reply.reply}',
                                                              trimLines: 3,
                                                              trimLength: 100,
                                                              trimExpandedText:
                                                                  ' Show Less',
                                                              trimCollapsedText:
                                                                  'Read More',
                                                              detectionRegExp:
                                                                  RegExp(
                                                                      '@[a-zA-Z0-9_.]+?(?![a-zA-Z0-9_.])'),
                                                              detectedStyle:
                                                                  const TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              basicStyle: const TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      ColorResources
                                                                          .white),
                                                              moreStyle: const TextStyle(
                                                                  fontSize: 16,
                                                                  color:
                                                                      ColorResources
                                                                          .blue),
                                                              lessStyle: const TextStyle(
                                                                  fontSize: 16,
                                                                  color:
                                                                      ColorResources
                                                                          .blue),
                                                            );
                                                          }),
                                                        ),
                                                        // DetectText(
                                                        //     text: reply.reply),
                                                      ],
                                                    ),
                                                  ),
                                                  reply.user.uid !=
                                                          SharedPrefs
                                                              .getUserId()
                                                      ? InkWell(
                                                          onTap: () {
                                                            // SharedPrefs.setUserUidReply(reply.user.uid);
                                                            pp.clearMention();
                                                            pp.setMention(
                                                              id: reply
                                                                  .user.uid,
                                                            );
                                                            setState(() {
                                                              key
                                                                      .currentState!
                                                                      .controller!
                                                                      .text =
                                                                  '@${reply.user.name.replaceAll(' ', '')} ';
                                                            });
                                                          },
                                                          child: const Text(
                                                              "Balas",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)))
                                                      : Container(),
                                                ])),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ],
                        );
                      })
                    ])),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
