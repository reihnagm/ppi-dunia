import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ClippedPhotoView extends StatelessWidget {
  final String image;
  const ClippedPhotoView({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "image-view",
      child: Center(
        child: PhotoView(
          imageProvider: image == ""
              ? const AssetImage('assets/images/default/ava.jpg')
              : Image.network(image, fit: BoxFit.contain).image,
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 4,
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
    );
  }
}
