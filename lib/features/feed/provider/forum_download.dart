import 'dart:io' as io;
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/features/feed/provider/file_storage.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:video_player/video_player.dart';
import 'package:open_filex/open_filex.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

class ForumContentVideo extends StatefulWidget {
  final String dataSource;
  const ForumContentVideo({
    super.key, 
    required this.dataSource,
  });

  @override
  State<ForumContentVideo> createState() => ForumContentVideoState();
}

class ForumContentVideoState extends State<ForumContentVideo> {

  VideoPlayerController? videoC;
  ChewieController? chewieC;

  int total = 0;
  int received = 0;

  bool finishDownload = false;

  late http.StreamedResponse response;

  final List<int> bytes = [];
  
  Future<void> initializePlayer() async {
    String originName = p.basename(widget.dataSource.split('/').last).split('.').first;
    String ext = p.basename(widget.dataSource).toString().split('.').last;

    String filename = "${DateFormat('yyyydd').format(DateTime.now())}-$originName.$ext";

    bool isExistFile = await FileStorage.checkFileExist(filename);
    NS.pop(context);
    if(!isExistFile) {
      response = await http.Client().send(http.Request('GET', Uri.parse(widget.dataSource)));
    
      total = response.contentLength ?? 0;

      response.stream.listen((value) {
        if(!mounted) return;
          setState(() {
            bytes.addAll(value);
            received += value.length;
          });
      }).onDone(() async {
        Uint8List uint8List = Uint8List.fromList(bytes);

        await FileStorage.saveFile(uint8List, filename);

        String fileToPlay = await FileStorage.getFileFromAsset(filename);
          
        videoC = VideoPlayerController.file(io.File(fileToPlay))
          ..initialize().then((_) {
          setState(() {
            debugPrint('Filename : $filename');
            finishDownload = true;

            chewieC = ChewieController(
              videoPlayerController: videoC!,
              aspectRatio: videoC?.value.aspectRatio,
              autoInitialize: true,
              autoPlay: false,
              looping: false,
            );
          });
        });
        NS.pop(context);
      });

      // Create a ByteBuilder to accumulate bytes
      // BytesBuilder byteBuilder = BytesBuilder();

      // Listen to the stream and accumulate bytes
      // await for (List<int> chunk in response.stream) {
      //   byteBuilder.add(chunk);
      // }

      // Get the final bytes
      // Uint8List resultBytes = byteBuilder.toBytes();

    } else {
      // playMediaFromAsset(filename);
      // OpenFilex.open(filename);
    }
  }

  Future<void> playMediaFromAsset(String filename) async {
    String fileToPlay = await FileStorage.getFileFromAsset(filename);

    videoC = VideoPlayerController.file(io.File(fileToPlay))
      ..initialize().then((_) {
      setState(() {
        finishDownload = true;

        chewieC = ChewieController(
          videoPlayerController: videoC!,
          aspectRatio: videoC?.value.aspectRatio,
          autoInitialize: true,
          autoPlay: false,
          looping: false,
        );
      });
      NS.pop(context);
    });    
  }

  @override 
  void initState() {
    super.initState();
    
    Future.microtask(() => initializePlayer());
  }

  @override 
  void dispose() {
    videoC?.dispose();
    chewieC?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return finishDownload && chewieC != null && chewieC!.videoPlayerController.value.isInitialized
    ? Container(
        margin: EdgeInsets.only(
          top: 10.h,
          left: 12.w,
          right: 12.w
        ),
        child: AspectRatio(
          aspectRatio: videoC!.value.aspectRatio,
          child: ClipRRect(
            borderRadius:  BorderRadius.circular(10.0),
            child: Chewie(
              controller: chewieC!
            ),
          ),
        ),
    )
    : SizedBox(
        height: 80.h,
        child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            
            Text("${(received / total * 100).isNaN || (received / total * 100).isInfinite ? '0' : (received / total * 100).toStringAsFixed(2)}%",
              style: TextStyle(
                color: ColorResources.blueDrawerPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold
              ),
            ),

            SizedBox(width: 12.w),

            const SpinKitChasingDots(
              color: ColorResources.blueDrawerPrimary,
            )

          ],
        )
      ),
    );
  }
}