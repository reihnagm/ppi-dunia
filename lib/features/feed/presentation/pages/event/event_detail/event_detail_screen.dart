import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/features/feed/presentation/pages/event/event_detail/event_detail_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/event/join_event/join_event_screen.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/views/basewidgets/image/image_card.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatefulWidget {
  final String idEvent;
  final bool isJoinEvent;
  const EventDetailScreen({super.key, required this.idEvent, required this.isJoinEvent});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late EventDetailScreenModel edsm;

  @override
  void initState() {
    super.initState();

    edsm = context.read<EventDetailScreenModel>();

    if (mounted) {
      edsm.getEventData(idEvent: widget.idEvent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: ColorResources.bgSecondaryColor,
        bottomNavigationBar: widget.isJoinEvent ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: const BoxDecoration(
          color: ColorResources.fillPrimary
        ),
        child: const Text("You have joined this event", 
        textAlign: TextAlign.center,
        style: TextStyle(
            color: ColorResources.white,
            fontSize: Dimensions.fontSizeLarge,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro'
        )),
      ) : Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: const BoxDecoration(
            color: ColorResources.bgSecondaryColor
          ),
          child: CustomButton(
            onTap: () {
              NS.push(context, JoinEventScreen(titleEvent: edsm.eventDetailData.title ?? "", idEvent: edsm.eventDetailData.id ?? "",));
            },
            isBorderRadius: true,
            btnTxt: "Join Event",
          ),
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              backgroundColor: ColorResources.bgSecondaryColor,
              title: const Text("Event Detail",
              style: TextStyle(
              color: ColorResources.blue,
              fontSize: Dimensions.fontSizeLarge,
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro'),
            ),
              leading: CupertinoNavigationBarBackButton(
                color: ColorResources.blue,
                onPressed: () {
                  NS.pop(context);
                },
              ),
            ),
            SliverList(delegate: SliverChildListDelegate([
              Consumer(builder: (context, EventDetailScreenModel edsm, Widget? child) {
                if(edsm.eventDetailStatus == EventDetailStatus.loading){
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
                if(edsm.eventDetailStatus == EventDetailStatus.empty){
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
                if (edsm.eventDetailStatus == EventDetailStatus.error) {
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
                return RefreshIndicator(
                onRefresh: () {
                  return Future.sync(() {
                    edsm.getEventData(idEvent: widget.idEvent);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: imageCard(edsm.eventDetailData.picture ?? "-", 245.0, 15.0),
                      ),
                      const SizedBox(height: 10,),
                      Text(edsm.eventDetailData.title ?? "",
                      maxLines: null,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: ColorResources.white,
                        fontSize: Dimensions.fontSizeLarge,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro'
                      )),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 5,),
                                IconText(text: edsm.eventDetailData.location ?? "-", iconData: Icons.location_pin, color: ColorResources.hintColor,),
                                const SizedBox(height: 5,),
                                IconText(text: '${edsm.eventDetailData.startDate} - ${edsm.eventDetailData.endDate}', iconData: Icons.calendar_month, color: ColorResources.hintColor,),
                                const SizedBox(height: 5,),
                                IconText(text: '${edsm.eventDetailData.start} - ${edsm.eventDetailData.end}', iconData: Icons.access_time_outlined, color: ColorResources.hintColor,),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Text(edsm.eventDetailData.description ?? "",
                      maxLines: null,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: ColorResources.hintColor,
                        fontSize: Dimensions.fontSizeLarge,
                        fontFamily: 'SF Pro'
                      )),
                    ],
                  ),
                ),
                );
              },)
            ]))
          ],
        ),
      ),
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