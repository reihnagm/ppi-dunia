import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:ppidunia/common/extensions/snackbar.dart';
import 'package:ppidunia/common/helpers/download_util.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
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
      fullScreenByDefault: true,
      optionsBuilder: (context, defaultOptions) async {
        await showDialog<void>(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    CustomButton(
                      isBorder: false,
                      btnColor: ColorResources.greyPrimary.withOpacity(0.8),
                      btnTextColor: Colors.white,
                      sizeBorderRadius: 10.0,
                      isBorderRadius: true,
                      height: 50.0,
                      onTap: () async {
                        Future.delayed(Duration.zero, () {
                          NS.pop(context);
                          ShowSnackbar.snackbar(context, "Successfully downloaded, please wait", '', ColorResources.success);
                        });
                        await DownloadHelper.downloadDoc(context: context, url: widget.dataSource);
                      },
                      btnTxt: "Save Video",
                      isPrefixIcon: true,
                      prefixIcon: const Icon(Icons.download, color: ColorResources.white,),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomButton(
                      isBorder: false,
                      btnColor: ColorResources.greyPrimary.withOpacity(0.8),
                      btnTextColor: Colors.white,
                      sizeBorderRadius: 10.0,
                      isBorderRadius: true,
                      height: 50.0,
                      onTap: () {
                        NS.pop(context);
                      },
                      btnTxt: "Close",
                      isPrefixIcon: true,
                      prefixIcon: const Icon(Icons.cancel, color: ColorResources.white,),
                    ),
                  ],
                )
              ),
            );
          },
        );
      },
      // additionalOptions: (context) {
      //   return <OptionItem>[
      //     OptionItem(
      //       onTap: () async {
      //         await DownloadHelper.downloadDoc(context: context, url: widget.dataSource);
      //       },
      //       iconData: Icons.download,
      //       title: 'Download Video',
      //     ),
      //   ];
      // },
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