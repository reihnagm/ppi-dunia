import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';

import 'package:ppidunia/views/basewidgets/dialog/animated/animated.dart';

import 'package:ppidunia/features/inbox/presentation/pages/inbox_screen_model.dart';
import 'package:ppidunia/features/inbox/presentation/pages/inbox_state.dart';

class InboxScreenState extends State<InboxScreen> {
  late InboxScreenModel ism;

  @override
  void initState() {
    super.initState();

    ism = context.read<InboxScreenModel>();

    if (mounted) {
      ism.getInboxes();
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
    return Scaffold(
        backgroundColor: ColorResources.bgSecondaryColor,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return RefreshIndicator(
                onRefresh: () {
                  return Future.sync(() {
                    ism.getInboxes();
                  });
                },
                child: NotificationListener(
                  onNotification: (ScrollNotification notification) {
                    if (notification is ScrollEndNotification) {
                      if (notification.metrics.pixels ==
                          notification.metrics.maxScrollExtent) {
                        ism.loadMoreInbox();
                      }
                    }
                    return false;
                  },
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      const SliverAppBar(
                        backgroundColor: ColorResources.transparent,
                        title: Text(
                          "Inbox",
                          style: TextStyle(
                              color: ColorResources.greyLightPrimary,
                              fontSize: Dimensions.fontSizeOverLarge,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SF Pro'),
                        ),
                        automaticallyImplyLeading: false,
                        centerTitle: true,
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Container(
                                margin:
                                    EdgeInsets.only(left: 20.0, right: 10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        width: 1.5,
                                        color: ColorResources.white),
                                    color: ColorResources.transparent),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {},
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Broadcast",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            color: ColorResources.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 13.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                          width: 1.5,
                                          color: ColorResources.white),
                                      color: ColorResources.transparent),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {},
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "SOS",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize:
                                                  Dimensions.fontSizeDefault,
                                              color: ColorResources.white),
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        )
                      ])),
                      Consumer<InboxScreenModel>(
                        builder: (BuildContext context, InboxScreenModel ism,
                            Widget? child) {
                          if (ism.inboxStatus == InboxStatus.loading) {
                            return const SliverFillRemaining(
                              hasScrollBody: false,
                              child: SpinKitCubeGrid(
                                color: ColorResources.greyLightPrimary,
                                size: 30.0,
                              ),
                            );
                          }

                          if (ism.inboxStatus == InboxStatus.error) {
                            return SliverFillRemaining(
                                hasScrollBody: false,
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

                          if (ism.inboxStatus == InboxStatus.empty) {
                            return SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: Text(
                                    getTranslated("NO_INBOX"),
                                    style: const TextStyle(
                                        color: ColorResources.greyLightPrimary,
                                        fontSize: Dimensions.fontSizeOverLarge,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SF Pro'),
                                  ),
                                ));
                          }
                          return SliverPadding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            sliver: SliverList.builder(
                              itemBuilder: (BuildContext context, int i) {
                                return Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                        color: ColorResources.greyPrimary),
                                    child: Material(
                                      color: ColorResources.transparent,
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        onTap: () async {
                                          showAnimatedDialog(
                                              context,
                                              Dialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const SizedBox(
                                                            height: 20.0),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              ism.id[i].user!
                                                                  .name!,
                                                              style: const TextStyle(
                                                                  color: ColorResources
                                                                      .greyDarkPrimary,
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeLarge,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      'SF Pro'),
                                                            ),
                                                            const SizedBox(
                                                                height: 10.0),
                                                            Text(
                                                              ism.id[i].user!
                                                                  .email!,
                                                              style: const TextStyle(
                                                                  color: ColorResources
                                                                      .greyDarkPrimary,
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeLarge,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      'SF Pro'),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 30.0),
                                                        // Container(
                                                        //   margin:
                                                        //       const EdgeInsets
                                                        //           .only(
                                                        //           left: 15.0,
                                                        //           right: 15.0),
                                                        //   child: Row(
                                                        //     mainAxisAlignment:
                                                        //         MainAxisAlignment
                                                        //             .end,
                                                        //     mainAxisSize:
                                                        //         MainAxisSize
                                                        //             .max,
                                                        //     children: [
                                                        //       InkWell(
                                                        //         onTap:
                                                        //             () async {
                                                        //           if (Platform
                                                        //               .isAndroid) {
                                                        //             Uri uri = Uri
                                                        //                 .parse(
                                                        //                     "google.navigation:q=${ism.id[i].lat},${ism.id[i].lng}&mode=d");
                                                        //             if (await canLaunchUrl(
                                                        //                 uri)) {
                                                        //               await launchUrl(
                                                        //                   uri);
                                                        //             } else {
                                                        //               throw 'Could not launch ${uri.toString()}';
                                                        //             }
                                                        //           } else {
                                                        //             String
                                                        //                 urlAppleMaps =
                                                        //                 'https://maps.apple.com/?q=${ism.id[i].lat},${ism.id[i].lng}';
                                                        //             String url =
                                                        //                 'comgooglemaps://?saddr=&daddr=${ism.id[i].lat},${ism.id[i].lng}&directionsmode=driving';
                                                        //             if (await canLaunchUrl(
                                                        //                 Uri.parse(
                                                        //                     url))) {
                                                        //               await launchUrl(
                                                        //                   Uri.parse(
                                                        //                       url));
                                                        //             } else if (await canLaunchUrl(
                                                        //                 Uri.parse(
                                                        //                     urlAppleMaps))) {
                                                        //               await launchUrl(
                                                        //                   Uri.parse(
                                                        //                       urlAppleMaps));
                                                        //             } else {
                                                        //               throw 'Could not launch $url';
                                                        //             }
                                                        //           }
                                                        //         },
                                                        //         child: Padding(
                                                        //           padding:
                                                        //               const EdgeInsets
                                                        //                   .all(
                                                        //                   8.0),
                                                        //           child: Text(
                                                        //             getTranslated(
                                                        //                 "LOOK_ON_THE_MAP"),
                                                        //             style: const TextStyle(
                                                        //                 color: ColorResources
                                                        //                     .greyDarkPrimary,
                                                        //                 fontSize:
                                                        //                     Dimensions
                                                        //                         .fontSizeLarge,
                                                        //                 fontWeight:
                                                        //                     FontWeight
                                                        //                         .w400,
                                                        //                 fontFamily:
                                                        //                     'SF Pro'),
                                                        //           ),
                                                        //         ),
                                                        //       ),
                                                        //     ],
                                                        //   ),
                                                        // )
                                                      ],
                                                    ),
                                                  )));

                                          await ism.inboxDetail(
                                              inboxId: ism.id[i].id!);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        ism.id[i].title!,
                                                        style: TextStyle(
                                                            color: ColorResources
                                                                .greyLightPrimary,
                                                            fontSize: Dimensions
                                                                .fontSizeLarge,
                                                            fontWeight: ism
                                                                        .id[i]
                                                                        .read !=
                                                                    true
                                                                ? FontWeight
                                                                    .bold
                                                                : null,
                                                            fontFamily:
                                                                'SF Pro'),
                                                      ),
                                                      Text(
                                                        ism.id[i].createdAt!,
                                                        style: TextStyle(
                                                            color: ColorResources
                                                                .greyLightPrimary,
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            fontWeight: ism
                                                                        .id[i]
                                                                        .read !=
                                                                    true
                                                                ? FontWeight
                                                                    .bold
                                                                : null,
                                                            fontFamily:
                                                                'SF Pro'),
                                                      ),
                                                      const SizedBox(
                                                          height: 10.0),
                                                      SizedBox(
                                                        width: 300.0,
                                                        child: Text(
                                                          ism.id[i]
                                                              .description!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.start,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              color: ColorResources
                                                                  .greyLightPrimary,
                                                              fontSize: Dimensions
                                                                  .fontSizeDefault,
                                                              fontWeight: ism
                                                                          .id[i]
                                                                          .read !=
                                                                      true
                                                                  ? FontWeight
                                                                      .bold
                                                                  : null,
                                                              fontFamily:
                                                                  'SF Pro'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              },
                              itemCount: ism.id.length,
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ));
          },
        ));
  }
}
