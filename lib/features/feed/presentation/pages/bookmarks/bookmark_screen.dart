import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/utils/color_resources.dart';

import 'package:ppidunia/features/feed/presentation/pages/widgets/bookmark_list.dart';
import 'package:ppidunia/features/feed/presentation/pages/widgets/bookmark_search.dart';
import 'package:ppidunia/features/feed/presentation/pages/bookmarks/bookmark_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/bookmarks/bookmark_state.dart';

class BookmarkScreenState extends State<BookmarkScreen> {
  late BookmarkScreenModel bsm;

  @override
  void initState() {
    super.initState();

    bsm = context.read<BookmarkScreenModel>();

    bsm.searchC = TextEditingController();

    bsm.searchC.addListener(() {
      if (bsm.debounce?.isActive ?? false) bsm.debounce!.cancel();
      bsm.debounce = Timer(const Duration(milliseconds: 500), () {
        bsm.onChangeSearch(bsm.searchC.text);
      });
    });

    if (mounted) {
      bsm.getFeeds();
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
                  bsm.getFeeds();
                });
              },
              child: NotificationListener(
                onNotification: (ScrollNotification notification) {
                  if (notification is ScrollEndNotification) {
                    if (notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                      if (bsm.hasMore) {
                        bsm.loadMoreFeed();
                      }
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
                        "Bookmark",
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
                        delegate: SliverChildListDelegate(
                            [const BookmarkSearch(), const BookmarkList()]))
                  ],
                ),
              ),
            );
            //
          },
        ));
  }
}
