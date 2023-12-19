import 'package:flutter/material.dart';
import 'package:ppidunia/features/feed/presentation/pages/widgets/clipped_photo_view.dart';
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
        height: 82.0,
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.symmetric(
          vertical: 20.0,
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
                        radius: 60.0,
                        backgroundColor: Color(0xFF637687),
                      )
                    : context.watch<ProfileProvider>().profileStatus ==
                            ProfileStatus.error
                        ? const CircleAvatar(
                            radius: 60.0,
                            backgroundColor: Color(0xFF637687),
                          )
                        : Stack(
                            children: [
                              InkWell(
                                onTap: () => NS.push(
                                  context,
                                  ClippedPhotoView(
                                    image: context
                                        .read<ProfileProvider>()
                                        .pd
                                        .avatar!,
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: context
                                      .read<ProfileProvider>()
                                      .pd
                                      .avatar!,
                                  imageBuilder: (BuildContext context,
                                      ImageProvider<Object> imageProvider) {
                                    return CircleAvatar(
                                      radius: 60.0,
                                      backgroundImage: imageProvider,
                                    );
                                  },
                                  placeholder:
                                      (BuildContext context, String url) {
                                    return const CircleAvatar(
                                      radius: 60.0,
                                      backgroundColor: Color(0xFF637687),
                                    );
                                  },
                                  errorWidget: (BuildContext context,
                                      String url, dynamic error) {
                                    return const CircleAvatar(
                                      radius: 60.0,
                                      backgroundImage: AssetImage(
                                          'assets/images/default/ava.jpg'),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                right: 18.0,
                                bottom: 0.0,
                                child: InkWell(
                                  onTap: () {
                                    NS.push(
                                        context, const ProfileUpdateScreen());
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: ColorResources.white,
                                    size: 20.0,
                                  ),
                                ),
                              )
                            ],
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
                                    width: 120,
                                    child: Text(
                                      context
                                          .read<ProfileProvider>()
                                          .pd
                                          .fullname!,
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: ColorResources.white,
                                          fontSize: Dimensions.fontSizeLarge,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'SF Pro'),
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
                        width: 25.0,
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
                        width: 25.0,
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
