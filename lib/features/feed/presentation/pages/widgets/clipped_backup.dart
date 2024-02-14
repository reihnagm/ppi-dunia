
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/helpers/download_util.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/features/feed/presentation/pages/feed/feed_screen_model.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/views/basewidgets/detecttext/detect_text.dart';
import 'package:provider/provider.dart';

class ClippedPhotoView extends StatefulWidget {
  final String image;
  final String? name;
  final String? caption;
  final String? like;
  final String? comment;
  final String? feedId;
  final int? index;
  const ClippedPhotoView({super.key, required this.image, this.name, this.caption, this.like, this.comment, this.feedId, this.index});

  @override
  State<ClippedPhotoView> createState() => _ClippedPhotoViewState();
}

class _ClippedPhotoViewState extends State<ClippedPhotoView> {
  bool isScale = false;
  int zoom = 0;

  @override
  Widget build(BuildContext context) {
    debugPrint('Index : ${widget.index}');
    debugPrint('Feedid : ${widget.feedId}');
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
                    InkWell(
                      onTap: () => NS.pop(context),
                      child: Container(
                        width: 110,
                        padding: const EdgeInsets.all(10),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: ColorResources.greyPrimary.withOpacity(0.8)),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.arrow_back_ios_rounded, size: 30, color: ColorResources.backgroundColor,),
                            SizedBox(width: 5,),
                            Text("Back",
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorResources.white,
                              fontSize: Dimensions.fontSizeExtraLarge,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SF Pro')
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomButton(
                      width: 125,
                      isBorder: false,
                      btnColor: ColorResources.greyPrimary.withOpacity(0.8),
                      btnTextColor: Colors.white,
                      sizeBorderRadius: 10.0,
                      isBorderRadius: true,
                      height: 50.0,
                      onTap: () async {
                        await DownloadHelper.downloadDoc(context: context, url: widget.image);
                      },
                      btnTxt: "Save",
                      isPrefixIcon: true,
                      prefixIcon: const Icon(Icons.download, color: ColorResources.error,),
                    ),
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
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text("GSDJGFSDJGFASDGSAFDHGAFSDHAGDSFAHSGDF",
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                color: ColorResources.white,
                                fontSize: Dimensions.fontSizeLarge,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SF Pro')),
                          ),
                          const SizedBox(height: 10,),
                          DetectText(text: widget.caption ?? "-"),
                          const SizedBox(height: 10,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                width: 125,
                                isBorder: false,
                                btnColor: ColorResources.bgSecondaryColor,
                                btnTextColor: Colors.white,
                                sizeBorderRadius: 10.0,
                                isBorderRadius: true,
                                height: 30.0,
                                onTap: () async {
                                  await context.read<FeedScreenModel>().toggleLike(
                                    feedId: widget.feedId!, 
                                    feedLikes:  context.read<FeedScreenModel>().feeds[widget.index!].feedLikes
                                  );
                                  context.read<FeedScreenModel>().panelC.open();
                                },
                                btnTxt: context.read<FeedScreenModel>().feeds[widget.index!].feedLikes.total.toString(),
                                isPrefixIcon: true,
                                prefixIcon: context.read<FeedScreenModel>().feeds[widget.index!].feedLikes.likes.where((el) => el.user.uid == SharedPrefs.getUserId()).isEmpty
                                  ? Image.asset(
                                  AssetsConst.imageIcLove,
                                  width: 18.0,
                                  ) :Image.asset(
                                    AssetsConst
                                        .imageIcLoveFill,
                                    width: 18.0,
                                  ),
                              ),
                              CustomButton(
                                width: 125,
                                isBorder: false,
                                btnColor: ColorResources.bgSecondaryColor,
                                btnTextColor: Colors.white,
                                sizeBorderRadius: 10.0,
                                isBorderRadius: true,
                                height: 30.0,
                                onTap: () async {},
                                btnTxt: widget.comment,
                                isPrefixIcon: true,
                                prefixIcon: Image.asset(
                                  AssetsConst.imageIcChatFill,
                                  width: 18.0,
                                ),
                              ),
                              CustomButton(
                                width: 125,
                                isBorder: false,
                                btnColor: ColorResources.bgSecondaryColor,
                                btnTextColor: Colors.white,
                                sizeBorderRadius: 10.0,
                                isBorderRadius: true,
                                height: 30.0,
                                onTap: () async {
                                  await DownloadHelper.downloadDoc(context: context, url: widget.image);
                                },
                                btnTxt: "Save",
                                isPrefixIcon: true,
                                prefixIcon: const Icon(Icons.download, color: ColorResources.error,),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
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
}
