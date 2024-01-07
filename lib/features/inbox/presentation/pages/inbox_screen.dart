import 'package:flutter/material.dart';
import 'package:ppidunia/common/helpers/date_util.dart';
import 'package:ppidunia/features/inbox/presentation/pages/detail_inbox/detail_inbox_state.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';

import 'package:ppidunia/features/inbox/presentation/pages/inbox_screen_model.dart';
import 'package:ppidunia/features/inbox/presentation/pages/inbox_state.dart';

int index = 0;
String type = "sos";

class InboxScreenState extends State<InboxScreen> {
  late InboxScreenModel ism;

  @override
  void initState() {
    super.initState();

    ism = context.read<InboxScreenModel>();

    if (mounted) {
      ism.getInboxes(type: type);
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
                    ism.getInboxes(type: type);
                  });
                },
                child: NotificationListener(
                  onNotification: (ScrollNotification notification) {
                    if (notification is ScrollEndNotification) {
                      if (notification.metrics.pixels ==
                          notification.metrics.maxScrollExtent) {
                        ism.loadMoreInbox(type: type);
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
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        width: 1.5,
                                        color: ColorResources.white),
                                    color: index == 0
                                        ? Colors.white
                                        : Colors.transparent),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        index = 0;
                                        type = "sos";
                                      });
                                      ism.getInboxes(type: type);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "SOS",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            color: index == 0
                                                ? ColorResources.black
                                                : ColorResources.white),
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
                                    left: 20.0, right: 10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        width: 1.5,
                                        color: ColorResources.white),
                                    color: index == 1
                                        ? Colors.white
                                        : Colors.transparent),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        index = 1;
                                        type = "default";
                                      });
                                      ism.getInboxes(type: type);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Broadcast",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            color: index == 1
                                                ? ColorResources.black
                                                : ColorResources.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12.0)),
                                        color: ism.id[i].read != true
                                            ? ColorResources.grey
                                            : ColorResources.greyPrimary),
                                    child: Material(
                                      color: ColorResources.transparent,
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        onTap: () async {
                                          NS.push(
                                            context,
                                            DetailInbox(
                                              type: type,
                                              title: ism.id[i].title ?? "-",
                                              name: ism.id[i].user!.name ?? "-",
                                              date: DateHelper.formatDateTime(
                                                  ism.id[i].createdAt!),
                                              description:
                                                  ism.id[i].description!,
                                            ),
                                          );
                                          await ism.inboxDetail(
                                            inboxId: ism.id[i].id!,
                                            type: type,
                                          );
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
                                                      SizedBox(
                                                        width: 300.0,
                                                        child: Text(
                                                          ism.id[i].title!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: ColorResources
                                                                  .greyLightPrimary,
                                                              fontSize: Dimensions
                                                                  .fontSizeLarge,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'SF Pro'),
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 300.0,
                                                        child: Text(
                                                          DateHelper
                                                              .formatDateTime(ism
                                                                  .id[i]
                                                                  .createdAt!),
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
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
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
