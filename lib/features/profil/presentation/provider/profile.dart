// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ppidunia/common/extensions/snackbar.dart';
import 'package:ppidunia/common/utils/global.dart';
import 'package:ppidunia/common/utils/modals.dart';

import 'package:ppidunia/features/media/data/repositories/media.dart';
import 'package:ppidunia/features/notification/provider/storage.dart';

import 'package:ppidunia/features/profil/data/models/profile.dart';
import 'package:ppidunia/features/profil/data/models/mention.dart';

import 'package:ppidunia/features/profil/data/repositories/profile.dart';
import 'package:ppidunia/features/feed/data/models/feed.dart';
import 'package:ppidunia/features/feed/data/reposiotories/feed.dart';

import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/basewidgets/textfield/textfield.dart';
import 'package:provider/provider.dart';

enum FeedStatus { idle, loading, loaded, empty, error }

enum ProfileStatus { idle, loading, loaded, error, empty }

enum ProfilePictureStatus { idle, loading, loaded, error, empty }

class ProfileProvider with ChangeNotifier {
  final ProfileRepo pr;
  final MediaRepo mr;
  final FeedRepo fr;

  ProfileProvider({required this.pr, required this.mr, required this.fr});

  int pageKey = 1;
  bool hasMore = true;

  File? file;
  ImageSource? imageSource;

  String? pfpPath;

  String search = '';

  String progress = "";

  late TextEditingController firstNameC;
  late TextEditingController lastNameC;
  late TextEditingController searchC;
  late TextEditingController emailC;
  late TextEditingController phoneC;
  late TextEditingController countryC;

  FocusNode firstNameFn = FocusNode();
  FocusNode lastNameFn = FocusNode();
  FocusNode emailFn = FocusNode();
  FocusNode numberFn = FocusNode();

  Timer? debounce;

  int currentIndexMultipleImg = 0;
  int currentIndex = 0;

  ProfileData _pd = ProfileData();
  ProfileData get pd => _pd;

  ProfileData _pdd = ProfileData();
  ProfileData get pdd => _pdd;

  List<Map<String, dynamic>> _usermentiondata = [];
  List<Map<String, dynamic>> get usermentiondata => [..._usermentiondata];

  final List<String> _userScans = [];
  List<String> get userScans => [..._userScans];

  List<GetUserMentionData> _usermention = [];
  List<GetUserMentionData> get usermention => [..._usermention];

  List<FeedData> _feeds = [];
  List<FeedData> get feeds => [..._feeds];

  FeedStatus _feedStatus = FeedStatus.idle;
  FeedStatus get feedStatus => _feedStatus;

  ProfileStatus _profileStatus = ProfileStatus.loading;
  ProfileStatus get profileStatus => _profileStatus;

  ProfilePictureStatus _profilePictureStatus = ProfilePictureStatus.idle;
  ProfilePictureStatus get profilePictureStatus => _profilePictureStatus;

  void setStateFeedStatus(FeedStatus feedStatus) {
    _feedStatus = feedStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateProfileStatus(ProfileStatus profileStatus) {
    _profileStatus = profileStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateProfilePictureStatus(ProfilePictureStatus profilePictureStatus) {
    _profilePictureStatus = profilePictureStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> chooseFile(BuildContext context) async {
    imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Source Image"),
          actions: [
            MaterialButton(
              child: const Text("Camera"),
              onPressed: () async {
                try {
                  if (await Permission.camera.request().isGranted) {
                    Navigator.pop(context, ImageSource.camera);
                  } else if (await Permission.camera.request().isDenied ||
                      await Permission.camera
                          .request()
                          .isPermanentlyDenied) {
                    GeneralModal.dialogRequestNotification(
                        msg:
                            "Camera feature needed, please activate your camera");
                  } else {
                    NS.pop(context);
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
        )
      );

    if (imageSource != null) {
      if (imageSource == ImageSource.gallery) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
        // XFile? pickedFile = await ImagePicker().pickImage(
        //   source: ImageSource.gallery,
        // );
        File? cropped = await ImageCropper().cropImage(
            sourcePath: result!.files.single.path!,
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: "Crop It",
                toolbarColor: Colors.blueGrey[900],
                toolbarWidgetColor: ColorResources.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            iosUiSettings: const IOSUiSettings(
              minimumAspectRatio: 1.0,
            ));
        if (cropped != null) {
          file = cropped;
          Future.delayed(Duration.zero, () => notifyListeners());
        } else {
          file = null;
          Future.delayed(Duration.zero, () => notifyListeners());
        }
      } else {
        XFile? pickedFile = await ImagePicker().pickImage(
          source: ImageSource.camera,
        );
        file = File(pickedFile!.path);
        Future.delayed(Duration.zero, () => notifyListeners());
        File? cropped = await ImageCropper().cropImage(
            sourcePath: pickedFile.path,
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: "Crop It",
                toolbarColor: Colors.blueGrey[900],
                toolbarWidgetColor: ColorResources.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            iosUiSettings: const IOSUiSettings(
              minimumAspectRatio: 1.0,
            ));
        if (cropped != null) {
          file = cropped;
          Future.delayed(Duration.zero, () => notifyListeners());
        } else {
          file = null;
          Future.delayed(Duration.zero, () => notifyListeners());
        }
      }
    }
  }

  void removeChooseFile() {
    file = null;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void onChangeCurrentMultipleImg(int i) {
    currentIndexMultipleImg = i;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void onChangeSearch(String searchParam) {
    search = searchParam;
    getFeeds();
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> uploadProfile() async {
    Map<String, dynamic> d = await mr.postMedia(folder: "images", media: file!);
    await pr.updateProfilePicture(
      avatar: file == null ? "" : d["data"]["path"],
      userId: SharedPrefs.getUserId()
    );
    file = null;
    getProfile();
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  bool submissionValidation(
    BuildContext context,
    String firstName,
    String lastName,
    String email,
    String number,
  ) {
    if (firstName.isEmpty) {
      ShowSnackbar.snackbar(
          context, getTranslated('FIRST_NAME_EMPTY'), '', ColorResources.error);
      firstNameFn.requestFocus();
      return false;
    } else if (lastName.isEmpty) {
      ShowSnackbar.snackbar(
          context, getTranslated('LAST_NAME_EMPTY'), '', ColorResources.error);
      lastNameFn.requestFocus();
      return false;
    } else if (email.isEmpty) {
      ShowSnackbar.snackbar(
          context, getTranslated('EMAIL_EMPTY'), '', ColorResources.error);
      emailFn.requestFocus();
      return false;
    } else if (!email.isValidEmail()) {
      ShowSnackbar.snackbar(context, getTranslated('INVALID_FORMAT_EMAIL'), '',
          ColorResources.error);
      emailFn.requestFocus();
      return false;
    } else if (number.isEmpty) {
      ShowSnackbar.snackbar(
          context, getTranslated('PHONE_EMPTY'), '', ColorResources.error);
      numberFn.requestFocus();
      return false;
    } else if (number.length < 10) {
      ShowSnackbar.snackbar(
          context, getTranslated('PHONE_LENGTH'), '', ColorResources.error);
      numberFn.requestFocus();
      return false;
    }
    return true;
  }

  Future<void> updateProfileUser(BuildContext context, file) async {
    try {
      final firstName = firstNameC.text.trim();
      final lastName = lastNameC.text.trim();
      final email = emailC.text.trim();
      final phone = phoneC.text;
      final bool isClear =
          submissionValidation(context, firstName, lastName, email, phone);
      if (isClear) {
        file == null
            ? await pr.updateProfile(
                firtNameC: firstNameC.text,
                lastNameC: lastNameC.text,
                email: emailC.text,
                userId: SharedPrefs.getUserId(),
                phone: phoneC.text,
              )
            : await uploadProfile();
        getProfile();
        NS.pop(context);
        ShowSnackbar.snackbar(
          context,
          "Berhasil Ubah Profile",
          '',
          ColorResources.success,
          const Duration(seconds: 3),
        );
      }
      setStateProfileStatus(ProfileStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateProfileStatus(ProfileStatus.error);
      ShowSnackbar.snackbar(
        context,
        e.toString(),
        '',
        ColorResources.error,
        const Duration(seconds: 3),
      );
    } catch (e) {
      debugPrint(e.toString());
      setStateProfileStatus(ProfileStatus.error);
    }
  }

  Future<void> getProfile() async {
    try {
      ProfileModel? pm = await pr.getProfile(userId: SharedPrefs.getUserId());
      _pd = pm!.data;
      setStateProfileStatus(ProfileStatus.loaded);
    } on CustomException catch (_) {
      setStateProfileStatus(ProfileStatus.error);
    } catch (_) {
      setStateProfileStatus(ProfileStatus.error);
    }
  }

  Future<void> getProfileUser({required String userId}) async {
    try {
      ProfileModel? pmd = await pr.getProfile(userId: userId);
      _pdd = pmd!.data;
      setStateProfileStatus(ProfileStatus.loaded);
    } on CustomException catch (_) {
      setStateProfileStatus(ProfileStatus.error);
    } catch (_) {
      setStateProfileStatus(ProfileStatus.error);
    }
  }

  Future<void> loadMoreFeed() async {
    pageKey++;
    FeedModel fm = await pr.getFeeds(pageKey: pageKey, search: search);
    hasMore = fm.pageDetail.hasMore;
    _feeds.addAll(fm.data);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getFeeds() async {
    pageKey = 1;
    hasMore = true;

    try {
      FeedModel fm = await pr.getFeeds(
        pageKey: pageKey,
        search: search,
      );
      _feeds = [];
      _feeds.addAll(fm.data);
      setStateFeedStatus(FeedStatus.loaded);

      if (feeds.isEmpty) {
        setStateFeedStatus(FeedStatus.empty);
      }
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateFeedStatus(FeedStatus.error);
    } catch (_) {
      setStateFeedStatus(FeedStatus.error);
    }
  }

  Future<void> getUserMention() async {
    pageKey = 1;
    hasMore = true;

    try {
      GetUserMention fm = await pr.getUserMention(
        pageKey: pageKey,
        search: search,
      );
      _usermention = [];
      _usermention.addAll(fm.data);
      setStateFeedStatus(FeedStatus.loaded);

      _usermentiondata = [];

      for (GetUserMentionData el in usermention) {
        _usermentiondata.add({
          "id": el.id,
          "display": el.username,
          "photo": el.avatar,
        });
      }

      if (_usermention.isEmpty) {
        setStateFeedStatus(FeedStatus.empty);
      }
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateFeedStatus(FeedStatus.error);
    } catch (_) {
      setStateFeedStatus(FeedStatus.error);
    }
  }

  Future<void> getFeedsUser({required String userId}) async {
    pageKey = 1;
    hasMore = true;

    try {
      FeedModel fm = await pr.getFeedsUser(
        pageKey: pageKey,
        search: search,
        userId: userId,
      );
      _feeds = [];
      _feeds.addAll(fm.data);
      setStateFeedStatus(FeedStatus.loaded);

      if (feeds.isEmpty) {
        setStateFeedStatus(FeedStatus.empty);
      }
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateFeedStatus(FeedStatus.error);
    } catch (_) {
      setStateFeedStatus(FeedStatus.error);
    }
  }

  Future<void> toggleLike(
      {required String feedId, required FeedLikes feedLikes}) async {
    try {
      int idxLikes = feedLikes.likes
          .indexWhere((el) => el.user.uid == SharedPrefs.getUserId());
      if (idxLikes != -1) {
        feedLikes.likes.removeAt(idxLikes);
        feedLikes.total = feedLikes.total - 1;
      } else {
        feedLikes.likes.add(UserLikes(
            user: User(
                uid: SharedPrefs.getUserId(),
                avatar: "-",
                name:
                    "${SharedPrefs.getRegFistName()} ${SharedPrefs.getRegLastName()}")));
        feedLikes.total = feedLikes.total + 1;
      }
      await fr.toggleLike(feedId: feedId);
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (_) {}
  }

  Future<void> toggleBookmark(
      {required String feedId, required FeedBookmarks feedBookmarks}) async {
    try {
      int idxBookmarks = feedBookmarks.bookmarks
          .indexWhere((el) => el.user.uid == SharedPrefs.getUserId());
      if (idxBookmarks != -1) {
        feedBookmarks.bookmarks.removeAt(idxBookmarks);
        feedBookmarks.total = feedBookmarks.total - 1;
      } else {
        feedBookmarks.bookmarks.add(UserLikes(
            user: User(
                uid: SharedPrefs.getUserId(),
                avatar: "-",
                name:
                    "${SharedPrefs.getRegFistName()} ${SharedPrefs.getRegLastName()}")));
        feedBookmarks.total = feedBookmarks.total + 1;
      }
      await fr.toggleBookmark(feedId: feedId);
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (_) {}
  }

  Future<void> delete({required String feedId}) async {
    try {
      await fr.feedDelete(feedId: feedId);
      getFeeds();
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (_) {}
  }

  Future<void> deleteAccount() async {
    try {
      await pr.deleteAccount(userId: SharedPrefs.getUserId());
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (_) {}
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final path = (await getExternalStorageDirectory())?.path;
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$fileName');
  }

  Future<Uint8List> readImageData(String name) async {
    final data = await rootBundle.load('assets/images/card/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
