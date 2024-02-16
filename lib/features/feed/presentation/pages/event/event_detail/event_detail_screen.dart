import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/features/feed/data/models/event_detail.dart';
import 'package:ppidunia/features/feed/presentation/pages/event/event_detail/event_detail_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/event/join_event/join_event_screen.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/views/basewidgets/image/image_card.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatefulWidget {
  final String idEvent;
  const EventDetailScreen({super.key, required this.idEvent});

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
        body: Consumer(builder: (context, EventDetailScreenModel ed, Widget? child) {
          final joined = ed.eventDetailData.joined ?? false;
          final isExpired = ed.eventDetailData.isExpired ?? false;
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
          return Stack(
            clipBehavior: Clip.none,
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                shrinkWrap: true,
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
                      RefreshIndicator(
                      onRefresh: () {
                        return Future.sync(() {
                          edsm.getEventData(idEvent: widget.idEvent);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16,top: 16, bottom: 80),
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
                                      IconText(text: edsm.eventDetailData.location ?? "-", iconData: Icons.location_pin, color: ColorResources.hintColor, size: Dimensions.fontSizeSmall,),
                                      const SizedBox(height: 5,),
                                      IconText(text: '${edsm.eventDetailData.startDate} - ${edsm.eventDetailData.endDate}', iconData: Icons.calendar_month, color: ColorResources.hintColor, size: Dimensions.fontSizeSmall,),
                                      const SizedBox(height: 5,),
                                      IconText(text: '${edsm.eventDetailData.start} - ${edsm.eventDetailData.end}', iconData: Icons.access_time_outlined, color: ColorResources.hintColor, size: Dimensions.fontSizeSmall,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            joined == false ?
                            Text(edsm.eventDetailData.description ?? "",
                            maxLines: null,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: ColorResources.hintColor,
                              fontSize: Dimensions.fontSizeLarge,
                              fontFamily: 'SF Pro'
                            )): ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: ed.eventDetailData.users!.length,
                              itemBuilder: (context, i) {
                                JoinedUserData user = ed.eventDetailData.users![i];
                                return Container(
                                  width: double.infinity,
                                  height: 250.0,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                    color: ColorResources.greyPrimary),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Participant Details :", 
                                        style: TextStyle(
                                        color: ColorResources.white,
                                        fontSize: Dimensions.fontSizeLarge,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SF Pro'
                                      ),),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text("Name", 
                                        style: TextStyle(
                                        color: ColorResources.white,
                                        fontSize: Dimensions.fontSizeLarge,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SF Pro'
                                      ),),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      IconText(text: '${user.firstName} ${user.lastName}', iconData: Icons.person_2, color: ColorResources.hintColor, size: Dimensions.fontSizeLarge,),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text("Email", 
                                        style: TextStyle(
                                        color: ColorResources.white,
                                        fontSize: Dimensions.fontSizeLarge,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SF Pro'
                                      ),),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      IconText(text: user.email, iconData: Icons.email, color: ColorResources.hintColor, size: Dimensions.fontSizeLarge,),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text("Number Phone", 
                                        style: TextStyle(
                                        color: ColorResources.white,
                                        fontSize: Dimensions.fontSizeLarge,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SF Pro'
                                      ),),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      IconText(text: user.phone, iconData: Icons.phone, color: ColorResources.hintColor, size: Dimensions.fontSizeLarge,),
                                    ],
                                  ),
                                );
                              },
                            ),

                          ],
                        ),
                      ),
                      )
                  ]))
                ],
              ),
              JoinButton(joined: joined, isExpired: isExpired, edsm: edsm),
            ],
          );
        },)
      ),
    );
  }
}

class JoinButton extends StatelessWidget {
  const JoinButton({
    super.key,
    required this.joined,
    required this.isExpired,
    required this.edsm,
  });

  final bool joined;
  final bool isExpired;
  final EventDetailScreenModel edsm;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: joined || isExpired ? Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: const BoxDecoration(
        color: ColorResources.fillPrimary
      ),
      child: Text(joined ? "You have joined this event" : "This event has ended", 
      textAlign: TextAlign.center,
      style: const TextStyle(
          color: ColorResources.white,
          fontSize: Dimensions.fontSizeLarge,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro'
      )),
    )  : Container(
        width: double.infinity,
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
    );
  }
}

class IconText extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Color color;
  final double size;
  const IconText({
    super.key, required this.text, required this.iconData, required this.color, required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconData,size: size, color: color,),
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
              fontSize: size,
              fontFamily: 'SF Pro'
            )),
          ),
        ),
      ],
    );
  }
}