import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:photo_view/photo_view.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:ppidunia/services/navigation.dart';

import 'package:ppidunia/common/utils/custom_themes.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/utils/color_resources.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/common/extensions/snackbar.dart';

class PreviewImageScreen extends StatefulWidget {
  const PreviewImageScreen({
    Key? key, 
    this.img
  }) : super(key: key);
  final String? img;

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {
  
  @override
  void initState() {
    super.initState();
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
      
      appBar: AppBar(
        backgroundColor: ColorResources.black,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: ColorResources.white,
          ),
          onPressed: () {
            NS.pop(context);
          }
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8.0),
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: PopupMenuButton(
              onSelected: (int i) async {
                switch (i) {
                  case 1:
                    ProgressDialog pr = ProgressDialog(context: context);
                    try {
                      PermissionStatus statusStorage = await Permission.storage.status;
                      if(!statusStorage.isGranted) {
                        await Permission.storage.request();
                      } 
                      pr.show(
                        max: 1,
                        msg: '${getTranslated("DOWNLOADING")}...'
                      );
                      await GallerySaver.saveImage(widget.img!);
                      pr.close();
                      ShowSnackbar.snackbar(context, getTranslated("SAVE_TO_GALLERY"), "", ColorResources.success);
                    } catch(e, stacktrace) {
                      debugPrint(stacktrace.toString());
                      pr.close();
                      ShowSnackbar.snackbar(context, getTranslated("THERE_WAS_PROBLEM"), "", ColorResources.error);
                    }
                  break;
                  default:
                }
              },
              icon: const Icon(Icons.more_horiz),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  padding: const EdgeInsets.only(
                    left: Dimensions.paddingSizeSmall,
                    right: Dimensions.paddingSizeSmall
                  ),
                  textStyle: sfProRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault
                  ),
                  value: 1,
                  child: Text(getTranslated("DOWNLOAD"),
                    style: sfProRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: ColorResources.black
                    )
                  ),
                ),
              ]
            ),
          )
        ]
      ),
      backgroundColor: ColorResources.black,
      body: Center(
        child: Hero(
          tag: 'Image',
          child: CachedNetworkImage(
            imageUrl: widget.img!,
            imageBuilder: (BuildContext context, ImageProvider imageProvider) => PhotoView(
              initialScale: PhotoViewComputedScale.contained * 1.1,
              imageProvider: imageProvider,
            ),
            placeholder: (BuildContext context, String url) => Shimmer.fromColors(
              highlightColor: ColorResources.white,
              baseColor: Colors.grey[200]!,
              child: Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(0.0),
                width: double.infinity,
                height: 200.0,
                color: Colors.grey
              )  
            ),
          ),
        )
      ),
    );
  }
}