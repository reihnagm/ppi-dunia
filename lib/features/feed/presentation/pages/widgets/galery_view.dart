import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/feed/feed_screen_model.dart';

class GaleryView extends StatelessWidget {
  final FeedScreenModel? fsm;
  final CommentScreenModel? csm;
  final bool isFsm;
  final int index;
  final int mediaIndex;
  const GaleryView(
      {super.key,
      this.csm,
      required this.index,
      this.fsm,
      required this.isFsm,
      required this.mediaIndex});

  @override
  Widget build(BuildContext context) {
    print(index);
    print(mediaIndex);
    print(fsm?.feeds[mediaIndex].media.length);
    print(fsm?.feeds[index].media[mediaIndex].path);
    print(csm?.feedDetailData.media![index].path);
    return Center(
      child: PhotoViewGallery.builder(
        itemCount: isFsm
            ? fsm?.feeds[index].media.length
            : csm!.feedDetailData.media!.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(
              isFsm
                  ? fsm!.feeds[index].media[mediaIndex].path
                  : csm!.feedDetailData.media![index].path,
            ),
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
