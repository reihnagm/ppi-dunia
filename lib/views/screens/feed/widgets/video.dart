import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPlay extends StatefulWidget {
  final String dataSource;
  const VideoPlay({
    required this.dataSource,
    super.key
  });

  @override
  State<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {

  ChewieController? chewieC;
  late VideoPlayerController videoC;
  
  @override 
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override 
  void dispose() {
    videoC.dispose();
    chewieC?.dispose();

    super.dispose();
  }

  Future<void> initializePlayer() async {
    videoC = VideoPlayerController.networkUrl(Uri.parse(widget.dataSource));
    
    await Future.wait([
      videoC.initialize(),
    ]);

    chewieC = ChewieController(
      videoPlayerController: videoC,
      autoInitialize: true,
      aspectRatio: videoC.value.aspectRatio,
      autoPlay: false,
      looping: false,
    );

    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return chewieC != null && chewieC!.videoPlayerController.value.isInitialized
    ? AspectRatio(
        aspectRatio: videoC.value.aspectRatio,
        child: Chewie(
          controller: chewieC!
        ),
      )
    : Container();
  }
}