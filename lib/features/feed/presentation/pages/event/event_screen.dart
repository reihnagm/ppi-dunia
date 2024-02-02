import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/features/feed/presentation/pages/event/event_screen_model.dart';
import 'package:ppidunia/localization/language_constraints.dart';
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

    if (mounted) {
      esm.getEvent();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.bgPrimaryColor,
      body: LayoutBuilder(builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: () {
            return Future.sync(() {
              esm.getEvent();
            });
          },
          child: NotificationListener(
            // onNotification: (ScrollNotification notification) {
            //   if (notification is ScrollEndNotification) {
            //     if (notification.metrics.pixels ==
            //         notification.metrics.maxScrollExtent) {
            //       if (esm.hasMore) {
            //         bsm.loadMoreFeed();
            //       }
            //     }
            //   }
            //   return false;
            // },
            child: CustomScrollView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverAppBar(
                      backgroundColor: ColorResources.transparent,
                      title: Text(
                        "Event",
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
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(2),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: const Column(
                              children: [
                                Text("Event", style: TextStyle(
                                  color: Colors.white
                                ),)
                              ],
                            ),
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