import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/custom_themes.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/features/feed/presentation/pages/event/event_detail/event_detail_screen.dart';
import 'package:ppidunia/features/feed/presentation/pages/event/event_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/event/history_join_event/history_join_event_screen.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/views/basewidgets/image/image_card.dart';
import 'package:provider/provider.dart';

class EventSccreen extends StatefulWidget {
  const EventSccreen({super.key});

  @override
  State<EventSccreen> createState() => _EventSccreenState();
}

class _EventSccreenState extends State<EventSccreen> {
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
      esm.getEvent();
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
              esm.getEvent();
            });
          },
          child: NotificationListener(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollEndNotification) {
                if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                  if (esm.hasMore) {
                    esm.loadMoreEvent();
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
                      title: const Text(
                        "Event",
                        style: TextStyle(
                            color: ColorResources.greyLightPrimary,
                            fontSize: Dimensions.fontSizeOverLarge,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SF Pro'),
                      ),
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      actions: [
                        IconButton(
                          onPressed: () {
                            NS.push(context, const HistoryJoinEventScreen());
                          }, 
                          icon: const Icon(Icons.event_available, size: 30,color: Colors.white,))
                      ],
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
                            itemCount: esm.event.length,
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
                                        idEvent:  esm.event[i].id ?? "-", 
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
                                              idEvent:  esm.event[i].id ?? "-", 
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
                                                        idEvent:  esm.event[i].id ?? "-", 
                                                      ));
                                                    },
                                                    child: imageCard(esm.event[i].picture ?? "-", 245.0, 15.0)),
                                                  esm.event[i].isExpired! ?
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
                                              Text(esm.event[i].title ?? "",
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
                                                  Flexible(
                                                    flex: 5,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 10),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          const SizedBox(height: 5,),
                                                          IconText(text: esm.event[i].location ?? "-", iconData: Icons.location_pin, color: ColorResources.hintColor,),
                                                          const SizedBox(height: 5,),
                                                          IconText(text: '${esm.event[i].startDate} - ${esm.event[i].endDate}', iconData: Icons.calendar_month, color: ColorResources.hintColor,),
                                                          const SizedBox(height: 5,),
                                                          IconText(text: '${esm.event[i].start} - ${esm.event[i].end}', iconData: Icons.access_time_outlined, color: ColorResources.hintColor,),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: InkWell(
                                                      onTap: () {
                                                        NS.push(context, 
                                                        EventDetailScreen(
                                                          idEvent:  esm.event[i].id ?? "-",
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