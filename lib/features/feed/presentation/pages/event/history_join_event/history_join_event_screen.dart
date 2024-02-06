import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/features/feed/presentation/pages/event/event_detail/event_detail_screen.dart';
import 'package:ppidunia/features/feed/presentation/pages/event/event_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/widgets/event_search.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/views/basewidgets/image/image_card.dart';
import 'package:provider/provider.dart';

class HistoryJoinEventScreen extends StatefulWidget {
  const HistoryJoinEventScreen({super.key});

  @override
  State<HistoryJoinEventScreen> createState() => _HistoryJoinEventScreenState();
}

class _HistoryJoinEventScreenState extends State<HistoryJoinEventScreen> {
  late EventScreenModel esm;

  @override
  void initState() {
    super.initState();

    esm = context.read<EventScreenModel>();

    esm.searchC = TextEditingController();

    esm.searchC.addListener(() {
      if (esm.debounce?.isActive ?? false) esm.debounce!.cancel();
      esm.debounce = Timer(const Duration(milliseconds: 500), () {
        esm.onChangeSearch(esm.searchC.text);
      });
    });

    if (mounted) {
      esm.getEventJoined();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.bgSecondaryColor,
      body: LayoutBuilder(builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: () {
            return Future.sync(() {
              esm.getEventJoined();
            });
          },
          child: NotificationListener(
            // onNotification: (ScrollNotification notification) {
            //   if (notification is ScrollEndNotification) {
            //     if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
            //       if (esm.hasMore) {
            //         esm.loadMoreEvent();
            //       }
            //     }
            //   }
            //   return false;
            // },
            child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverAppBar(
                      backgroundColor: ColorResources.transparent,
                      title: const Text(
                        "Your Event Joined",
                        style: TextStyle(
                            color: ColorResources.greyLightPrimary,
                            fontSize: Dimensions.fontSizeOverLarge,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SF Pro'),
                      ),
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      leading: CupertinoNavigationBarBackButton(
                        color: ColorResources.greyLightPrimary,
                        onPressed: () {
                          NS.pop(context);
                        },
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Consumer<EventScreenModel>(builder: (BuildContext context, EventScreenModel esm, Widget? child) {
                          if(esm.eventStatus == EventStatus.loading){
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
                          if(esm.eventStatus == EventStatus.empty){
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * .75,
                              child: Center(
                                child: Text(getTranslated("NO_EVENT"),
                                    style: const TextStyle(
                                        color: ColorResources.white,
                                        fontSize: Dimensions.fontSizeLarge,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SF Pro')),
                              ),
                            );
                          }
                          if (esm.eventStatus == EventStatus.error) {
                            return SizedBox(
                            height: MediaQuery.of(context).size.height * .75,
                            child: Center(
                              child: Text(
                                getTranslated("PLEASE_TRY_AGAIN_LATER"),
                                style: const TextStyle(
                                    color: ColorResources.greyLightPrimary,
                                    fontSize: Dimensions.fontSizeDefault,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SF Pro'),
                              ),
                            ));
                          }
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                            shrinkWrap: true,
                            itemCount: esm.eventJoined.length,
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
                                    onTap: () {
                                      NS.push(context, 
                                      EventDetailScreen(
                                        idEvent:  esm.eventJoined[i].id ?? "-", isJoinEvent: true,
                                      ));
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          child: InkWell(
                                          onTap: (){
                                            NS.push(context, 
                                            EventDetailScreen(
                                              idEvent:  esm.eventJoined[i].id ?? "-", isJoinEvent: true,
                                            ));
                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  NS.push(context, 
                                                  EventDetailScreen(
                                                    idEvent:  esm.eventJoined[i].id ?? "-", isJoinEvent: true,
                                                  ));
                                                },
                                                child: imageCard(esm.eventJoined[i].picture ?? "-", 245.0, 15.0)),
                                              const SizedBox(height: 10,),
                                              Text(esm.eventJoined[i].title ?? "",
                                              maxLines: null,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                color: ColorResources.white,
                                                fontSize: Dimensions.fontSizeLarge,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'SF Pro'
                                              )),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Expanded(
                                                    flex: 5,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 10),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          const SizedBox(height: 5,),
                                                          IconText(text: esm.eventJoined[i].location ?? "-", iconData: Icons.location_pin, color: ColorResources.hintColor,),
                                                          // const SizedBox(height: 5,),
                                                          // IconText(text: '${esm.eventJoined[i].startDate} - ${esm.eventJoined[i].endDate}', iconData: Icons.calendar_month, color: ColorResources.hintColor,),
                                                          const SizedBox(height: 5,),
                                                          IconText(text: '${esm.eventJoined[i].start} - ${esm.eventJoined[i].end}', iconData: Icons.access_time_outlined, color: ColorResources.hintColor,),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        NS.push(context, 
                                                        EventDetailScreen(
                                                          idEvent:  esm.eventJoined[i].id ?? "-", isJoinEvent: true,
                                                        ));
                                                      },
                                                      child: Image.asset(
                                                        AssetsConst.imageIcNext,
                                                        width: 40.0,
                                                        height: 40.0,
                                                        fit: BoxFit.scaleDown,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          );
                        })
                    ]))
                ],
              )
            ),
        );
      },)
    );
  }
}

class IconText extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Color color;
  const IconText({
    super.key, required this.text, required this.iconData, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconData,size: 12, color: color,),
        const SizedBox(width: 5,),
        Text(text,
        maxLines: 1,
        overflow: TextOverflow.visible,
        style: TextStyle(
          color: color,
          fontSize: Dimensions.fontSizeSmall,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro'
        )),
      ],
    );
  }
}