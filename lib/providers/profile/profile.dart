import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ppidunia/data/repository/media/media.dart';

import 'package:ppidunia/data/models/feed/feed.dart';
import 'package:ppidunia/data/models/profile/profile.dart';

import 'package:ppidunia/data/repository/feed/feed.dart';
import 'package:ppidunia/data/repository/profile/profile.dart';

import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/exceptions.dart';
import 'package:ppidunia/utils/shared_preferences.dart';

enum FeedStatus { idle, loading, loaded, empty, error }
enum ProfileStatus { idle, loading, loaded, error, empty }
enum ProfilePictureStatus { idle, loading, loaded, error, empty }

class ProfileProvider with ChangeNotifier {
  final ProfileRepo pr;
  final MediaRepo mr;
  final FeedRepo fr;

  ProfileProvider({
    required this.pr,
    required this.mr,
    required this.fr
  });

  int pageKey = 1;
  bool hasMore = true;

  File? file;
  ImageSource? imageSource;

  String? pfpPath;

  String search = '';

  String progress = "";

  late TextEditingController searchC;

  Timer? debounce;

  int currentIndexMultipleImg = 0;
  int currentIndex = 0;

  ProfileData _pd = ProfileData();
  ProfileData get pd => _pd;

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
    imageSource = await showDialog<ImageSource>(context: context, builder: (BuildContext context) => 
      AlertDialog(
        title: const Text("Source Image"),
        actions: [
        MaterialButton(
          child: const Text("Camera"),
          onPressed: () => Navigator.pop(context, ImageSource.camera),
        ),
        MaterialButton(
          child: const Text("Gallery"),
          onPressed: () => Navigator.pop(context, ImageSource.gallery)
          )
        ],
      )
    );
    if(imageSource != null) {
      if(imageSource == ImageSource.gallery) {
        XFile? pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery, 
        );
        File? cropped = await ImageCropper().cropImage(
          sourcePath: pickedFile!.path,
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: "Crop It",
            toolbarColor: Colors.blueGrey[900],
            toolbarWidgetColor: ColorResources.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false
          ),
          iosUiSettings: const IOSUiSettings(
            minimumAspectRatio: 1.0,
          )
        );  
        if(cropped != null) {
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
          sourcePath:  pickedFile.path,
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: "Crop It",
            toolbarColor: Colors.blueGrey[900],
            toolbarWidgetColor: ColorResources.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false
          ),
          iosUiSettings: const IOSUiSettings(
            minimumAspectRatio: 1.0,
          )
        );  
        if(cropped != null) {
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
      avatar: d["data"]["path"], 
      userId: SharedPrefs.getUserId()
    );
    file = null;
    getProfile();    
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getProfile() async {
    try {     
      ProfileModel? pm = await pr.getProfile(userId: SharedPrefs.getUserId());
      _pd = pm!.data;
      setStateProfileStatus(ProfileStatus.loaded);
    } on CustomException catch (_) {
      setStateProfileStatus(ProfileStatus.error);
    } catch(_) {
      setStateProfileStatus(ProfileStatus.error);
    }
  }

  Future<void> loadMoreFeed() async {
    pageKey++;
    FeedModel fm = await pr.getFeeds(
      pageKey: pageKey,
      search: search
    );
    hasMore = fm.pageDetail.hasMore;
    _feeds.addAll(fm.data);
    Future.delayed(Duration.zero,() => notifyListeners());
  }

  Future<void> getFeeds() async {

    pageKey = 1;
    hasMore = true;

    try {
      FeedModel fm = await pr.getFeeds(
        pageKey: pageKey,
        search: search
      );
      _feeds = [];
      _feeds.addAll(fm.data);
      setStateFeedStatus(FeedStatus.loaded);

      if(feeds.isEmpty) {
        setStateFeedStatus(FeedStatus.empty);
      }
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch(e) {
      debugPrint(e.toString());
      setStateFeedStatus(FeedStatus.error);
    } catch(_) {
      setStateFeedStatus(FeedStatus.error);
    }
  }

  Future<void> toggleLike({required String feedId, required FeedLikes feedLikes}) async {
    try {
      int idxLikes = feedLikes.likes.indexWhere((el) => el.user.uid == SharedPrefs.getUserId());
      if(idxLikes != -1) {
        feedLikes.likes.removeAt(idxLikes);
        feedLikes.total = feedLikes.total - 1; 
      } else {
        feedLikes.likes.add(
          UserLikes(
            user: User(
              uid: SharedPrefs.getUserId(),
              avatar: "-", 
              name: "${SharedPrefs.getRegFistName()} ${SharedPrefs.getRegLastName()}"
            )
          )
        );
        feedLikes.total = feedLikes.total + 1; 
      }
      await fr.toggleLike(feedId: feedId);
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch(e) {
      debugPrint(e.toString());
    } catch(_) {}
  }

  Future<void> toggleBookmark({required String feedId, required FeedBookmarks feedBookmarks}) async {
    try {
      int idxBookmarks = feedBookmarks.bookmarks.indexWhere((el) => el.user.uid == SharedPrefs.getUserId());
      if(idxBookmarks != -1) {
        feedBookmarks.bookmarks.removeAt(idxBookmarks);
        feedBookmarks.total = feedBookmarks.total - 1; 
      } else {
        feedBookmarks.bookmarks.add(
          UserLikes(
            user: User(
              uid: SharedPrefs.getUserId(),
              avatar: "-", 
              name: "${SharedPrefs.getRegFistName()} ${SharedPrefs.getRegLastName()}"
            )
          )
        );
        feedBookmarks.total = feedBookmarks.total + 1; 
      }
      await fr.toggleBookmark(feedId: feedId);
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch(e) {
      debugPrint(e.toString());
    } catch(_) {}
  }

  Future<void> delete({required String feedId}) async {
    try {
      await fr.feedDelete(feedId: feedId);
      getFeeds();
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch(e) {
      debugPrint(e.toString());
    } catch(_) {}
  }

  Future<void> deleteAccount() async {
    try {
      await pr.deleteAccount(userId: SharedPrefs.getUserId());
    } on CustomException catch(e) {
      debugPrint(e.toString());
    } catch(_) {}
  }

}