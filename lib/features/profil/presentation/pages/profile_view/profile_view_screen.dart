import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/features/profil/presentation/pages/profile_view/profile_view_state.dart';
import 'package:ppidunia/features/profil/presentation/provider/profile.dart';
import 'package:ppidunia/features/profil/presentation/widgets/post_card.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:provider/provider.dart';

class ProfileViewScreenState extends State<ProfileViewScreen> {
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
      pp.getFeedsUser(userId: widget.userId);
    }

    if (mounted) {
      pp.getProfileUser(userId: widget.userId);
    }

    // print(widget.userId);
    // print(context.read<ProfileProvider>().pdd.fullname);
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
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              backgroundColor: ColorResources.bgSecondaryColor,
              title: context.watch<ProfileProvider>().profileStatus ==
                      ProfileStatus.loading
                  ? const CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Color(0xFF637687),
                    )
                  : context.watch<ProfileProvider>().profileStatus ==
                          ProfileStatus.error
                      ? const CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Color(0xFF637687),
                        )
                      : Text(
                          getTranslated("PROFILE"),
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
              Consumer<ProfileProvider>(builder:
                  (BuildContext context, ProfileProvider pp, Widget? child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 12.0, right: 12.0),
                      width: 380,
                      height: 100,
                      decoration: const ShapeDecoration(
                        color: ColorResources.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(4, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          width: 380,
                          height: 150,
                          decoration: const ShapeDecoration(
                            color: ColorResources.greyDarkPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(4, 4),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          left: 30,
                          bottom: 100,
                          child: context
                                      .watch<ProfileProvider>()
                                      .profileStatus ==
                                  ProfileStatus.loading
                              ? const CircleAvatar(
                                  radius: 40.0,
                                  backgroundColor: Color(0xFF637687),
                                )
                              : context
                                          .watch<ProfileProvider>()
                                          .profileStatus ==
                                      ProfileStatus.error
                                  ? const CircleAvatar(
                                      radius: 40.0,
                                      backgroundColor: Color(0xFF637687),
                                    )
                                  : Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: context
                                                  .read<ProfileProvider>()
                                                  .pdd
                                                  .avatar ??
                                              "-",
                                          imageBuilder: (BuildContext context,
                                              ImageProvider<Object>
                                                  imageProvider) {
                                            return CircleAvatar(
                                              radius: 40.0,
                                              backgroundImage: imageProvider,
                                            );
                                          },
                                          placeholder: (BuildContext context,
                                              String url) {
                                            return const CircleAvatar(
                                              radius: 40.0,
                                              backgroundColor:
                                                  Color(0xFF637687),
                                            );
                                          },
                                          errorWidget: (BuildContext context,
                                              String url, dynamic error) {
                                            return const CircleAvatar(
                                              radius: 40.0,
                                              backgroundImage: AssetImage(
                                                'assets/images/default/ava.jpg',
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                        ),
                        Positioned(
                          left: 30,
                          bottom: 50,
                          child: SizedBox(
                            width: 200,
                            child: Text(
                              context.read<ProfileProvider>().pdd.fullname ??
                                  "-",
                              style: const TextStyle(
                                color: ColorResources.white,
                                fontSize: Dimensions.fontSizeExtraLarge,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SF Pro',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 30,
                          bottom: 20,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                context
                                        .read<ProfileProvider>()
                                        .pdd
                                        .country
                                        ?.name ??
                                    "-",
                                style: const TextStyle(
                                  color: ColorResources.white,
                                  fontSize: Dimensions.marginSizeDefault,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SF Pro',
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.school,
                                size: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                context
                                        .read<ProfileProvider>()
                                        .pdd
                                        .country
                                        ?.branch ??
                                    "-",
                                style: const TextStyle(
                                  color: ColorResources.white,
                                  fontSize: Dimensions.marginSizeDefault,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SF Pro',
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 350,
                      child: Text(
                        'Post ${context.read<ProfileProvider>().pdd.fullname ?? "-"}',
                        style: const TextStyle(
                          color: ColorResources.white,
                          fontSize: Dimensions.fontSizeOverLarge,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF Pro',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    postCard(pp: pp),
                  ],
                );
              })
            ]))
          ],
        ),
      ),
    );
  }
}
