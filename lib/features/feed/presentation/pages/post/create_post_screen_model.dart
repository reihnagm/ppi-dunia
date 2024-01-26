import 'dart:io';

import 'package:flutter/material.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ppidunia/common/utils/global.dart';
import 'package:ppidunia/common/utils/modals.dart';
import 'package:ppidunia/features/country/data/models/branch.dart';
import 'package:ppidunia/features/feed/data/reposiotories/feed.dart';
import 'package:ppidunia/features/feed/presentation/pages/feed/feed_screen_model.dart';
import 'package:ppidunia/features/notification/provider/storage.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:video_compress/video_compress.dart';

import 'package:ppidunia/services/navigation.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/common/extensions/snackbar.dart';

import 'package:ppidunia/features/media/data/repositories/media.dart';

import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/errors/exceptions.dart';

enum GetBranchStatus { idle, loading, loaded, empty, error }

enum SharePostStatus { idle, loading, loaded, empty, error }

class CreatePostModel with ChangeNotifier {
  FeedScreenModel fsm;
  FeedRepo fr;
  MediaRepo mr;

  CreatePostModel({required this.fsm, required this.fr, required this.mr});

  late TextEditingController postC;

  int currentIndexMultipleImg = 0;

  String feedType = "text";

  bool? isImage;

  File? videoFile;
  Uint8List? videoFileThumbnail;
  String? videoSize;

  String? docName;
  File? docFile;
  String? docSize;

  List<File> pickedFile = [];
  List<Asset> images = [];
  List<Asset> resultList = [];
  List<File> files = [];

  String selectedBranch = 'All';

  List<String> _branches = [];
  List<String> get branches => [..._branches];

  GetBranchStatus _getBranchStatus = GetBranchStatus.idle;
  GetBranchStatus get getBranchStatus => _getBranchStatus;

  SharePostStatus _sharePostStatus = SharePostStatus.idle;
  SharePostStatus get sharePostStatus => _sharePostStatus;

  Future<void> uploadPic(BuildContext context) async {
    ImageSource? imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                getTranslated("SOURCE_IMAGE"),
              ),
              actions: [
                MaterialButton(
                  child: Text(
                    getTranslated("CAMERA"),
                  ),
                  onPressed: () async {
                    try {
                      if (await Permission.camera.request().isGranted) {
                        Navigator.pop(context, ImageSource.camera);
                      } else if(await Permission.camera.request().isDenied || await Permission.camera.request().isPermanentlyDenied) {
                        await Permission.camera.request();
                        GeneralModal.dialogRequestNotification(msg: "Camera feature needed, please activate your camera");
                      }else{
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                ),
                MaterialButton(
                  child: const Text("Gallery"),
                  onPressed: () async {
                    navigatorKey.currentContext!.read<StorageNotifier>().checkStoragePermission();
                    if(await Permission.photos.isGranted || await Permission.storage.isGranted){
                      Navigator.pop(context, ImageSource.gallery);
                    }
                  },
                )
              ],
            ));
    if (imageSource == ImageSource.camera) {
      XFile? xf = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 80);
      if (xf != null) {
        pickedFile.add(File(xf.path));
        isImage = true;
        feedType = "image";
      }
    }
    if (imageSource == ImageSource.gallery) {
      resultList = await MultiImagePicker.pickImages(
        cupertinoOptions: const CupertinoOptions(
            settings: CupertinoSettings(selection: SelectionSetting(max: 8))),
        materialOptions: const MaterialOptions(maxImages: 8),
        selectedAssets: images,
      );
      for (var imageAsset in resultList) {
        String? filePath = await LecleFlutterAbsolutePath.getAbsolutePath(
            uri: imageAsset.identifier);
        File compressedFile = await FlutterNativeImage.compressImage(filePath!,
            quality: 80, percentage: 80);
        pickedFile.add(File(compressedFile.path));
        isImage = true;
        feedType = "image";
      }
    }
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> uploadDoc(BuildContext context) async {
    if(await Permission.storage.request().isDenied || await Permission.storage.request().isPermanentlyDenied ) {
      await Permission.storage.request();
      GeneralModal.dialogRequestNotification(msg: "Storage feature needed, please activate your storage");
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['pdf', 'doc', 'xlsx', 'rar', 'txt', 'zip'],
        withData: false,
        withReadStream: true,
        onFileLoading: (FilePickerStatus filePickerStatus) {});
    if (result != null) {
      File vf = File(result.files.single.path!);
      int sizeInBytes = vf.lengthSync();
      String fs = filesize(sizeInBytes, 0).replaceAll(RegExp(r'[^0-9]'), '');
      if (int.parse(fs) > 150) {
        // ignore: use_build_context_synchronously
        ShowSnackbar.snackbar(
            context, getTranslated("SIZE_MAXIMUM"), "", ColorResources.error);
        return;
      }
      docFile = vf;
      docName = vf.path.toString().split('/').last;
      docSize = filesize(sizeInBytes, 0);
      feedType = "document";
    }
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> uploadVid(BuildContext context) async {
    navigatorKey.currentContext!.read<StorageNotifier>().checkStoragePermission();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        withData: false,
        withReadStream: true,
        onFileLoading: (FilePickerStatus filePickerStatus) {});
    if (result != null) {
      File vf = File(result.files.single.path!);
      int sizeInBytes = vf.lengthSync();
      String fs = filesize(sizeInBytes, 0).replaceAll(RegExp(r'[^0-9]'), '');
      if (int.parse(fs) > 150) {
        ShowSnackbar.snackbar(
            context, getTranslated("SIZE_MAXIMUM"), "", ColorResources.error);
        return;
      }
      videoFile = vf;
      videoFileThumbnail = await VideoCompress.getByteThumbnail(vf.path);
      videoSize = filesize(sizeInBytes, 0);
      feedType = "video";
    }
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void onSelectBranch(String val) {
    selectedBranch = val;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void onChangeCurrentMultipleImg(int i) {
    currentIndexMultipleImg = i;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateGetBranchStatus(GetBranchStatus getBranchStatus) {
    _getBranchStatus = getBranchStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateSharePostStatus(SharePostStatus sharePostStatus) {
    _sharePostStatus = sharePostStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getCountries(BuildContext context) async {
    setStateGetBranchStatus(GetBranchStatus.loading);
    try {
      _branches = [];
      BranchModel bm = await fr.getBranches();
      for (BranchData bd in bm.data) {
        if (bd.branch == 'ALL') {
          _branches.add(getTranslated("ANYONE"));
        } else {
          _branches.add(bd.branch);
        }
      }
      setStateGetBranchStatus(GetBranchStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateGetBranchStatus(GetBranchStatus.error);
    } catch (e) {
      debugPrint(e.toString());
      setStateGetBranchStatus(GetBranchStatus.error);
    }
  }

  void clearPost() {
    files.clear();
    pickedFile.clear();
    videoFile = null;
    docFile = null;
    feedType = "text";
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> post(BuildContext context) async {
    try {
      String feedId = const Uuid().v4();

      if (postC.text.trim() == "") {
        return ShowSnackbar.snackbar(
          context,
          getTranslated("CAPTION_EMPTY"),
          '',
          ColorResources.error,
          const Duration(seconds: 6),
        );
      }

      setStateSharePostStatus(SharePostStatus.loading);

      if (feedType == "text") {
        await fr.post(
            feedId: feedId,
            caption: postC.text,
            feedType: feedType,
            countryId: selectedBranch);
      }

      if (feedType == "image") {
        await fr.post(
            feedId: feedId,
            caption: postC.text,
            feedType: feedType,
            countryId: selectedBranch);

        for (File p in pickedFile) {
          Map<String, dynamic> d =
              await mr.postMedia(folder: "images", media: File(p.path));
          await fr.postMedia(
              feedId: feedId, path: d["data"]["path"], size: d["data"]["size"]);
        }
      }

      if (feedType == "video") {
        await fr.post(
            feedId: feedId,
            caption: postC.text,
            feedType: feedType,
            countryId: selectedBranch);

        Map<String, dynamic> d =
            await mr.postMedia(folder: "videos", media: File(videoFile!.path));

        await fr.postMedia(
            feedId: feedId, path: d["data"]["path"], size: d["data"]["size"]);
      }

      if (feedType == "document") {
        await fr.post(
            feedId: feedId,
            caption: postC.text,
            feedType: feedType,
            countryId: selectedBranch);

        Map<String, dynamic> d =
            await mr.postMedia(folder: "documents", media: File(docFile!.path));
        await fr.postMedia(
            feedId: feedId, path: d["data"]["path"], size: d["data"]["size"]);
      }

      clearPost();

      fsm.getFeeds();

      NS.pop(context);

      setStateSharePostStatus(SharePostStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateSharePostStatus(SharePostStatus.error);
    } catch (e) {
      debugPrint(e.toString());
      setStateSharePostStatus(SharePostStatus.error);
    }
  }
}
