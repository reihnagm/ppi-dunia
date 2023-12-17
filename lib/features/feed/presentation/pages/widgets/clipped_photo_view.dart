import 'package:flutter/cupertino.dart';
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
        child: ClipRect(
          child: PhotoView(
            imageProvider: Image.network(
              image,
              fit: BoxFit.contain,
            ).image,
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
            // loadingBuilder: (context, event) =>
            //     const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
