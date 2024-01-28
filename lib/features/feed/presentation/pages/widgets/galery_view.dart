import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:ppidunia/features/feed/presentation/pages/feed/feed_screen_model.dart';

class GaleryView extends StatefulWidget {
  final FeedScreenModel? fsm;
  final int index;
  final int mediaIndex;
  const GaleryView(
      {super.key,
      required this.index,
      this.fsm,
      required this.mediaIndex});

  @override
  State<GaleryView> createState() => _GaleryViewState();
}

class _GaleryViewState extends State<GaleryView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: PhotoViewGallery.builder(
        itemCount: widget.fsm!.feeds[widget.index].media.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.fsm!.feeds[widget.index].media[widget.mediaIndex].path),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        loadingBuilder: (context, event) =>
            const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
