import 'package:flutter/material.dart';
import 'package:ppidunia/features/profil/presentation/pages/profil_update/profile_update_state.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ppidunia/features/profil/presentation/provider/profile.dart';

import 'package:ppidunia/services/navigation.dart';

import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/helpers/greetings_util.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';

import 'package:ppidunia/features/profil/presentation/pages/profile_state.dart';

class FeedPersonalInfo extends StatelessWidget {
  final GlobalKey<ScaffoldState> gk;
  const FeedPersonalInfo({required this.gk, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        height: 100.0,
        padding: const EdgeInsets.only(left: 20, top: 30, bottom: 10),
        margin: const EdgeInsets.symmetric(
          vertical: 5.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                context.watch<ProfileProvider>().profileStatus ==
                        ProfileStatus.loading
                    ? const CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Color(0xFF637687),
                      )
                    : context.watch<ProfileProvider>().profileStatus ==
                            ProfileStatus.error
                        ? const CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Color(0xFF637687),
                          )
                        : InkWell(
                            onTap: () {
                              NS.push(context, const ProfileUpdateScreen());
                            },
                            child: CachedNetworkImage(
                              imageUrl:
                                  context.read<ProfileProvider>().pd.avatar!,
                              imageBuilder: (BuildContext context,
                                  ImageProvider<Object> imageProvider) {
                                return CircleAvatar(
                                  radius: 25.0,
                                  backgroundImage: imageProvider,
                                );
                              },
                              placeholder: (BuildContext context, String url) {
                                return const CircleAvatar(
                                  radius: 25.0,
                                  backgroundColor: Color(0xFF637687),
                                );
                              },
                              errorWidget: (BuildContext context, String url,
                                  dynamic error) {
                                return const CircleAvatar(
                                  radius: 25.0,
                                  backgroundImage: AssetImage(
                                      'assets/images/default/ava.jpg'),
                                );
                              },
                            ),
                          ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${GreetingsHelper.greetings(context)}",
                      style: const TextStyle(
                          color: ColorResources.hintColor,
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SF Pro'),
                    ),
                    const SizedBox(height: 5.0),
                    context.watch<ProfileProvider>().profileStatus ==
                            ProfileStatus.loading
                        ? const SizedBox()
                        : context.watch<ProfileProvider>().profileStatus ==
                                ProfileStatus.error
                            ? const SizedBox()
                            : context.watch<ProfileProvider>().profileStatus ==
                                    ProfileStatus.empty
                                ? const SizedBox()
                                : SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width < 400
                                            ? 175
                                            : 200,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        context
                                            .read<ProfileProvider>()
                                            .pd
                                            .fullname!,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: ColorResources.white,
                                            fontSize: Dimensions.fontSizeLarge,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'SF Pro'),
                                      ),
                                    ),
                                  )
                  ],
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(right: 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () {
                      NS.push(context, const ProfileScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        AssetsConst.imageIcNotification,
                        width: 20.0,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () {
                      gk.currentState!.openDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        AssetsConst.imageIcSettings,
                        width: 20.0,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
