import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ppidunia/features/feed/presentation/pages/feed/feed_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/feed/feed_state.dart';
import 'package:provider/provider.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:ppidunia/features/profil/presentation/provider/profile.dart';
import 'package:ppidunia/features/banner/presentation/providers/banner.dart';

import 'package:ppidunia/common/utils/color_resources.dart';

import 'package:ppidunia/features/inbox/presentation/pages/inbox_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/widgets/drawer.dart';
import 'package:ppidunia/features/feed/presentation/pages/widgets/banner.dart';
import 'package:ppidunia/features/feed/presentation/pages/widgets/list.dart';
import 'package:ppidunia/features/feed/presentation/pages/widgets/personal_info.dart';
import 'package:ppidunia/features/feed/presentation/pages/widgets/search.dart';
import 'package:ppidunia/features/feed/presentation/pages/widgets/tag.dart';

class FeedScreenState extends State<FeedScreen> {
  GlobalKey<ScaffoldState> gk = GlobalKey<ScaffoldState>();

  late InboxScreenModel ism;
  late FeedScreenModel fsm;
  late ProfileProvider pp;
  late BannerProvider bp;

  @override
  void initState() {
    super.initState();

    fsm = context.read<FeedScreenModel>();
    pp = context.read<ProfileProvider>();
    bp = context.read<BannerProvider>();
    ism = context.read<InboxScreenModel>();

    fsm.panelC = PanelController();
    fsm.countriesC = ScrollController();
    fsm.searchC = TextEditingController();

    fsm.searchC.addListener(() {
      if (fsm.debounce?.isActive ?? false) fsm.debounce!.cancel();
      fsm.debounce = Timer(const Duration(milliseconds: 800), () {
        fsm.onChangeSearch(fsm.searchC.text);
      });
    });

    if (mounted) {
      fsm.getFeeds();
    }

    if (mounted) {
      bp.getBanner();
    }

    if (mounted) {
      fsm.getFeedTag();
    }

    if (mounted) {
      pp.getProfile();
    }
  }

  @override
  void dispose() {
    fsm.debounce?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
        key: gk,
        backgroundColor: ColorResources.bgPrimaryColor,
        drawer: DrawerScreen(
          gk: gk,
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            int deviceMaxHeight =
                int.parse(constraints.maxHeight.toStringAsFixed(0));
            return SlidingUpPanel(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              isDraggable: true,
              backdropTapClosesPanel: false,
              panelSnapping: true,
              minHeight: deviceMaxHeight < 600
                  ? constraints.maxHeight * .38
                  : deviceMaxHeight < 800
                      ? constraints.maxHeight * .45
                      : constraints.maxHeight * .53,
              maxHeight: deviceMaxHeight < 600
                  ? constraints.maxHeight * .76
                  : deviceMaxHeight < 800
                      ? constraints.maxHeight * .81
                      : constraints.maxHeight * .80,
              color: ColorResources.bgSecondaryColor,
              controller: fsm.panelC,
              panelBuilder: (ScrollController sc) {
                return NotificationListener(
                  onNotification: (ScrollNotification notification) {
                    if (notification is ScrollEndNotification) {
                      if (fsm.hasMore) {
                        fsm.loadMoreFeed();
                      }
                    }
                    return false;
                  },
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    controller: sc,
                    slivers: [
                      SliverList(
                          delegate: SliverChildListDelegate([
                        Center(
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 3.0, bottom: 3.0),
                                child: const Icon(
                                  Icons.keyboard_arrow_up,
                                  color: ColorResources.hintColor,
                                  size: 40.0,
                                ),
                              ),
                              // Text(
                              //   '$deviceMaxHeight',
                              //   style: const TextStyle(color: Colors.white),
                              // )
                            ],
                          ),
                        ),
                        const FeedSearch(),
                        const FeedTag(),
                        const FeedList()
                      ]))
                    ],
                  ),
                );
              },
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return RefreshIndicator(
                      onRefresh: () {
                        return Future.sync(() {
                          pp.getProfile();
                          fsm.getFeeds();
                          ism.getReadCount();
                        });
                      },
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        slivers: [
                          FeedPersonalInfo(
                            gk: gk,
                          ),
                          const FeedBanner()
                        ],
                      ),
                    );
                  },
                ),
              ),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
            );
          },
        ));
  }
}
