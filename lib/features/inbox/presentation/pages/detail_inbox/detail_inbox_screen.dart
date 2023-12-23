import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/features/inbox/presentation/pages/detail_inbox/detail_inbox_state.dart';
import 'package:ppidunia/features/inbox/presentation/pages/inbox_screen_model.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:provider/provider.dart';

class DetailInboxScreenState extends State<DetailInbox> {
  late InboxScreenModel ism;

  @override
  void initState() {
    super.initState();

    ism = context.read<InboxScreenModel>();

    if (mounted) {
      ism.getInboxes(type: widget.type);
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: ColorResources.bgSecondaryColor,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              backgroundColor: ColorResources.bgSecondaryColor,
              title: Text(
                widget.type == "sos"
                    ? widget.title.toUpperCase()
                    : "Broadcast".toUpperCase(),
                style: const TextStyle(
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
            SliverList(
                delegate: SliverChildListDelegate([
              Consumer<InboxScreenModel>(builder:
                  (BuildContext context, InboxScreenModel pp, Widget? child) {
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              widget.type == "sos"
                                  ? widget.name.toUpperCase()
                                  : widget.title.toUpperCase(),
                              style: const TextStyle(
                                color: ColorResources.white,
                                fontSize: Dimensions.fontSizeDefault,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SF Pro',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Text(
                            widget.date,
                            style: const TextStyle(
                              color: ColorResources.white,
                              fontSize: Dimensions.fontSizeDefault,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SF Pro',
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      Divider(
                        height: 50,
                        color: widget.type == "sos"
                            ? ColorResources.redHealth
                            : ColorResources.blue,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.description,
                          style: const TextStyle(
                            color: ColorResources.white,
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SF Pro',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
            ]))
          ],
        ),
      ),
    );
  }
}
