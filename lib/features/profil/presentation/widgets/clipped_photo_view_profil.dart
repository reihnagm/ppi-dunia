
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ppidunia/common/helpers/download_util.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/features/profil/presentation/provider/profile.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:provider/provider.dart';

class ClippedPhotoViewProfil extends StatefulWidget {
  final String image;
  const ClippedPhotoViewProfil({super.key, required this.image});

  @override
  State<ClippedPhotoViewProfil> createState() => _ClippedPhotoViewProfilState();
}

class _ClippedPhotoViewProfilState extends State<ClippedPhotoViewProfil> {
  late ProfileProvider pp;

  bool isScale = false;
  int zoom = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pp = context.read<ProfileProvider>();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Image : ${widget.image}');
    return Consumer<ProfileProvider>(
      builder: (BuildContext context, ProfileProvider pp, Widget? child) {
        if (pp.profileStatus == ProfileStatus.loading) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .75,
            child: const SpinKitCubeGrid(
              color: ColorResources.greyLightPrimary,
              size: 30.0,
            ),
          );
        }

        if (pp.profileStatus == ProfileStatus.error) {
          return SizedBox(
              height: 150.0,
              child: Center(
                child: Text(
                  getTranslated("PLEASE_TRY_AGAIN_LATER"),
                  style: const TextStyle(
                    color: ColorResources.greyLightPrimary,
                    fontSize: Dimensions.fontSizeOverLarge,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro',
                  ),
                ),
              ));
        }

        if (pp.profileStatus == ProfileStatus.empty) {
          return SizedBox(
              height: 150.0,
              child: Center(
                child: Text(
                  getTranslated("NO_POST"),
                  style: const TextStyle(
                      color: ColorResources.greyLightPrimary,
                      fontSize: Dimensions.fontSizeOverLarge,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro'),
                ),
              ));
        }
        return AnnotatedRegion(
          value: SystemUiOverlayStyle.light,
          child: SafeArea(
            child: Scaffold(
              body: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: PhotoView(
                      backgroundDecoration: const BoxDecoration(color: ColorResources.blackSport),
                      imageProvider: widget.image == ""
                          ? const AssetImage('assets/images/default/ava.jpg')
                          : Image.network(widget.image, fit: BoxFit.contain).image,
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      maxScale: PhotoViewComputedScale.covered * 3,
                      onTapDown: (context, details, controllerValue) {
                        setState(() {
                          zoom = details.kind!.index;
                        });
                      },
                      scaleStateChangedCallback: (value) {
                        setState(() {
                          isScale = value.isScaleStateZooming;
                          zoom = value.index;
                        });
                      },
                      loadingBuilder: (context, event) => Center(
                        child: SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            value: event == null
                                ? 0
                                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                          ),
                        ),
                      ),
                    ),
                  ),
                  isScale || zoom == 1 ? Container() : Positioned(
                    top: 15.0,
                    left: 15.0,
                    right: 15.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorResources.greyPrimary.withOpacity(0.8),
                          ),
                          child: CupertinoNavigationBarBackButton(
                            color: ColorResources.white,
                            onPressed: () {
                              NS.pop(context);
                            },
                          ),
                        ),
                        widget.image != "" ?
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorResources.greyPrimary.withOpacity(0.8),
                          ),
                          child: PopupMenuButton(
                            color: ColorResources.white,
                            iconColor: Colors.white,
                            iconSize: 20,
                            itemBuilder: (BuildContext
                                buildContext) {
                              return [
                                const PopupMenuItem(
                                  value: "/save",
                                  child: Text("Save",
                                    style: TextStyle(
                                        color: ColorResources.greyDarkPrimary,
                                        fontSize: Dimensions.fontSizeSmall,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SF Pro'))
                                ),
                              ];
                            },
                            onSelected: (route) async {
                              if (route == "/save") {
                                await DownloadHelper.downloadDoc(context: context, url: widget.image);
                              }
                            },
                          ),
                        ) : Container(),
                      ],
                    )
                  ),
                  isScale || zoom == 1 ? Container() : Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          color: ColorResources.greyPrimary.withOpacity(0.8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pp.pdd.fullname ?? "",
                                overflow: TextOverflow.visible,
                                style: const TextStyle(
                                  color: ColorResources.white,
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SF Pro')),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    pp.pdd.country?.name ?? "-",
                                    style: const TextStyle(
                                      color: ColorResources.white,
                                      fontSize: Dimensions.fontSizeSmall,
                                      fontFamily: 'SF Pro',
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.school,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    pp.pdd.country?.branch ?? "-",
                                    style: const TextStyle(
                                      color: ColorResources.white,
                                      fontSize: Dimensions.fontSizeSmall,
                                      fontFamily: 'SF Pro',
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
