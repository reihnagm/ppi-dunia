import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/features/profil/presentation/widgets/post_card.dart';
import 'package:ppidunia/features/profil/presentation/widgets/profile_card.dart';
import 'package:ppidunia/features/profil/presentation/widgets/search.dart';
import 'package:provider/provider.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/services/navigation.dart';

import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/utils/color_resources.dart';

import 'package:ppidunia/features/profil/presentation/provider/profile.dart';

import 'package:ppidunia/features/profil/presentation/pages/profile_state.dart';

class ProfileScreenState extends State<ProfileScreen> {
  late ProfileProvider pp;

  @override
  void initState() {
    super.initState();

    pp = context.read<ProfileProvider>();

    pp.searchC = TextEditingController();

    pp.searchC.addListener(() {
      if (pp.debounce?.isActive ?? false) pp.debounce!.cancel();
      pp.debounce = Timer(const Duration(milliseconds: 500), () {
        pp.onChangeSearch(pp.searchC.text);
      });
    });

    if (mounted) {
      pp.getFeeds();
    }

    if (mounted) {
      pp.getProfile();
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
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: ColorResources.bgSecondaryColor,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return RefreshIndicator(
              onRefresh: () {
                return Future.sync(() {
                  pp.getProfile();
                });
              },
              child: NotificationListener(
                onNotification: (ScrollNotification notification) {
                  if (notification is ScrollEndNotification) {
                    if (notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                      if (pp.hasMore) {
                        pp.loadMoreFeed();
                      }
                    }
                  }
                  return false;
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverAppBar(
                      backgroundColor: ColorResources.transparent,
                      title: Text(
                        getTranslated("PROFILE"),
                        style: const TextStyle(
                            color: ColorResources.blue,
                            fontSize: Dimensions.fontSizeLarge,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SF Pro'),
                      ),
                      centerTitle: false,
                      actions: [
                        pp.file != null
                            ? Container(
                                margin: const EdgeInsets.only(
                                    top: 17.0, right: 18.0),
                                child: InkWell(
                                  onTap: () async {
                                    await pp.uploadProfile();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Upload',
                                      style: TextStyle(
                                          color: ColorResources.blue,
                                          fontSize: Dimensions.fontSizeLarge,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'SF Pro'),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                      leading: CupertinoNavigationBarBackButton(
                        color: ColorResources.blue,
                        onPressed: () {
                          NS.pop(context);
                        },
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      context.read<ProfileProvider>().pd.role == "user"
                          ? profileCard(context: context, pp: pp)
                          : const SizedBox(),
                      searchBar(pp: pp),
                      postCard(pp: pp),
                    ]))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
