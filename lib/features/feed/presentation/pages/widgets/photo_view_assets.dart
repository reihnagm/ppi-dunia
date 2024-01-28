import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewAssets extends StatelessWidget {
  final File image;
  const PhotoViewAssets({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "image-view",
      child: Center(
        child: ClipRect(
          child: PhotoView(
            imageProvider: Image.file(
              image,
              fit: BoxFit.contain,
            ).image,
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
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
      ),
    );
  }
}
