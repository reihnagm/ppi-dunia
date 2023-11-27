import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:ppidunia/features/banner/data/models/banner.dart';
import 'package:ppidunia/features/banner/data/repositories/banner.dart';

import 'package:ppidunia/common/errors/exceptions.dart';

enum BannerStatus { idle, loading, loaded, error, empty }

class BannerProvider with ChangeNotifier {
  final BannerRepo br;

  BannerProvider({
    required this.br
  });

  late CarouselController carouselC;

  int currentIndexMultipleImg = 0;
  int currentIndex = 0;

  BannerStatus _bannerStatus = BannerStatus.loading;
  BannerStatus get bannerStatus => _bannerStatus;

  List<BannerData>? _banners = [];
  List<BannerData>? get banners => _banners;

  void onChangeCurrentMultipleImg(int i) {
    currentIndexMultipleImg = i;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateBannerStatus(BannerStatus bannerStatus) {
    _bannerStatus = bannerStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getBanner() async {
    setStateBannerStatus(BannerStatus.loading);
    try {   
      _banners = [];
      BannerModel? nm = await br.getBanner();
      if(nm!.data!.isNotEmpty) {
        _banners!.addAll(nm.data!);
        setStateBannerStatus(BannerStatus.loaded);
      } else {
        setStateBannerStatus(BannerStatus.empty);
      }
    } on CustomException catch(e) {
      debugPrint(e.toString());
      setStateBannerStatus(BannerStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateBannerStatus(BannerStatus.error);
    }
  }
}