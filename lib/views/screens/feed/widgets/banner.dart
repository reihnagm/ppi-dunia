import 'package:flutter/material.dart';
import 'package:ppidunia/providers/banner/banner.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:ppidunia/utils/color_resources.dart';

class FeedBanner extends StatelessWidget {
  const FeedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10.0
        ),
        child: Consumer<BannerProvider>(
          builder: (BuildContext context, BannerProvider banner, Widget? child) {
            return banner.bannerStatus == BannerStatus.loading 
            ? Container() 
            : banner.bannerStatus == BannerStatus.error 
            ? Container()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 180.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      enlargeStrategy: CenterPageEnlargeStrategy.scale,
                      initialPage: banner.currentIndex,
                      onPageChanged: (int i, CarouselPageChangedReason reason) {
                        banner.onChangeCurrentMultipleImg(i);
                      },
                    ),
                    itemCount: banner.banners!.length,
                    itemBuilder: (BuildContext context, int i, int z) {
                      return  Material(
                        color: ColorResources.transparent,
                        borderRadius: BorderRadius.circular(30.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30.0),
                          onTap: () {},
                          child: CachedNetworkImage(
                            imageUrl: banner.banners![i].path!,
                            imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                              return Card(
                                margin: EdgeInsets.zero,
                                color: ColorResources.bgPrimaryColor,
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0)
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18.0),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: imageProvider
                                    )
                                  ),
                                ),
                              );
                            },
                            placeholder: (BuildContext context, String val) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[200]!,
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  color: ColorResources.white,
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18.0),
                                      color: ColorResources.white
                                    ),
                                  ),
                                ),
                              ); 
                            },
                            errorWidget: (BuildContext context, String text, dynamic _) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[200]!,
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  color: ColorResources.white,
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18.0),
                                      color: ColorResources.white
                                    ),
                                  ),
                                ),
                              ); 
                            },
                          )
                        ),
                      );                  
                    }
                  ),

                ],
              );
          },
        )
      ),
    );
  }
}