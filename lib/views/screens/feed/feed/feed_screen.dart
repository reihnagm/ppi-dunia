import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:ppidunia/providers/profile/profile.dart';
import 'package:ppidunia/providers/banner/banner.dart';

import 'package:ppidunia/utils/color_resources.dart';

import 'package:ppidunia/views/screens/feed/feed/feed_screen_model.dart';
import 'package:ppidunia/views/screens/feed/feed/feed_state.dart';
import 'package:ppidunia/views/screens/inbox/inbox_screen_model.dart';
import 'package:ppidunia/views/screens/feed/widgets/drawer.dart';
import 'package:ppidunia/views/screens/feed/widgets/banner.dart';
import 'package:ppidunia/views/screens/feed/widgets/list.dart';
import 'package:ppidunia/views/screens/feed/widgets/personal_info.dart';
import 'package:ppidunia/views/screens/feed/widgets/search.dart';
import 'package:ppidunia/views/screens/feed/widgets/tag.dart';

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
    
    if(mounted) {
      fsm.getFeeds();
    }
   
    if(mounted) {
      bp.getBanner();
    }

    if(mounted) {
      fsm.getFeedTag();
    }

    if(mounted) {
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
      body: SlidingUpPanel(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        isDraggable: true,
        backdropTapClosesPanel: false,
        panelSnapping: true,
        minHeight: 350.h,
        maxHeight: 520.h,
        color: ColorResources.bgSecondaryColor,
        controller: fsm.panelC,
        panelBuilder: (ScrollController sc) {
          return NotificationListener(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollEndNotification) {
                if(fsm.hasMore) {
                  fsm.loadMoreFeed();
                } 
              } 
              return false;
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              controller: sc,
              slivers: [
                    
                SliverList(
                  delegate: SliverChildListDelegate([
                    
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 3.0, 
                          bottom: 3.0
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_up,
                          color: ColorResources.hintColor,
                          size: 40.0,
                        ),
                      ),
                    ),
              
                    const FeedSearch(),
                    const FeedTag(),
                    const FeedList()
                    
                  ])
                )
                    
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
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
          topRight: Radius.circular(18.0)
        ),
      )
    );
  }

}
