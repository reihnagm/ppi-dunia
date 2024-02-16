import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/custom_themes.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/features/feed/presentation/pages/event/event_detail/event_detail_screen.dart';
import 'package:ppidunia/features/feed/presentation/pages/event/history_join_event/history_join_event_model.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/basewidgets/image/image_card.dart';
import 'package:provider/provider.dart';

class HistoryJoinEventScreen extends StatefulWidget {
  const HistoryJoinEventScreen({super.key});

  @override
  State<HistoryJoinEventScreen> createState() => _HistoryJoinEventScreenState();
}

class _HistoryJoinEventScreenState extends State<HistoryJoinEventScreen> {
  late JoinedEventScreenModel hesm;

  Future<void> getData() async {
    if(!mounted) return;
      await hesm.getEventJoined();
  }

  @override
  void initState() {
    super.initState();

      hesm = context.read<JoinedEventScreenModel>();

      Future.microtask(() {
        getData();
      });
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.bgSecondaryColor,
      body: RefreshIndicator(
          onRefresh: () {
            return Future.sync(() {
              hesm.getEventJoined();
            });
          },
          child: NotificationListener(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollEndNotification) {
                if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                  if (hesm.hasMore) {
                    hesm.loadMoreEvent();
                  }
                }
              }
              return false;
            },
            child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverAppBar(
                    backgroundColor: ColorResources.transparent,
                    title: const Text("My Event Join",
                      style: TextStyle(
                        color: ColorResources.greyLightPrimary,
                        fontSize: Dimensions.fontSizeOverLarge,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro'
                      ),
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
                        Consumer<JoinedEventScreenModel>(
                          builder: (BuildContext context, JoinedEventScreenModel hesm, Widget? child) {
                          if(hesm.eventJoinStatus == JoinedEventStatus.loading){
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
                          if(hesm.eventJoinStatus == JoinedEventStatus.empty){
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * .75,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AssetsConst.imageIcNoEvent,
                                    width: 250.0,
                                    height: 250.0,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(getTranslated("NO_EVENT"),
                                      style: const TextStyle(
                                          color: ColorResources.white,
                                          fontSize: Dimensions.fontSizeLarge,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'SF Pro')),
                                ],
                              ),
                            );
                          }
                          if (hesm.eventJoinStatus == JoinedEventStatus.error) {
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
                            itemCount: hesm.eventJoined.length,
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
                                        idEvent:  hesm.eventJoined[i].id!,
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
                                              idEvent:  hesm.eventJoined[i].id!
                                            ));
                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Stack(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      NS.push(context, 
                                                      EventDetailScreen(
                                                        idEvent:  hesm.eventJoined[i].id ?? "-", 
                                                      ));
                                                    },
                                                    child: imageCard(hesm.eventJoined[i].picture ?? "-", 245.0, 15.0)),
                                                  hesm.eventJoined[i].isExpired! ?
                                                  Positioned(
                                                    left: 0.0,
                                                    right: 0.0,
                                                    bottom: 0.0,
                                                    top: 0.0,
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15.0),
                                                        color: ColorResources.black.withOpacity(0.7)
                                                      ),
                                                      child: Text("This event has ended",
                                                      style: sfProRegular.copyWith(
                                                        color: ColorResources.white,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: Dimensions.fontSizeExtraLarge,
                                                      )),
                                                    )
                                                  ) : Container(),
                                                ],
                                              ),
                                              const SizedBox(height: 10,),
                                              Text(hesm.eventJoined[i].title ?? "",
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
                                                          IconText(text: '${hesm.eventJoined[i].location}', iconData: Icons.location_pin, color: ColorResources.hintColor,),
                                                          const SizedBox(height: 5,),
                                                          IconText(text: '${hesm.eventJoined[i].startDate} - ${hesm.eventJoined[i].endDate}', iconData: Icons.calendar_month, color: ColorResources.hintColor,),
                                                          const SizedBox(height: 5,),
                                                          IconText(text: '${hesm.eventJoined[i].start} - ${hesm.eventJoined[i].end}', iconData: Icons.access_time_outlined, color: ColorResources.hintColor,),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        NS.push(context, 
                                                        EventDetailScreen(
                                                          idEvent:  hesm.eventJoined[i].id!,
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
                    ])
                  )
                ],
              ),
          ),
        )
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
        Expanded(
          flex: 3,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(text,
            maxLines: 1,
            overflow: TextOverflow.visible,
            style: TextStyle(
              color: color,
              fontSize: Dimensions.fontSizeSmall,
              fontFamily: 'SF Pro'
            )),
          ),
        ),
      ],
    );
  }
}