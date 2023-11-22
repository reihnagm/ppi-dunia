import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:provider/provider.dart';

import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/dimensions.dart';

import 'package:ppidunia/views/screens/feed/feed/feed_screen_model.dart';

class FeedTag extends StatelessWidget {
  const FeedTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedScreenModel>(
      builder: (BuildContext context, FeedScreenModel feed, Widget? child) {
        return feed.getBranchStatus == GetBranchStatus.loading 
        ? Container(
            height: 45.0,
            margin: const EdgeInsets.only(
              top: 30.0,
            ), 
            child: const Center(
              child: SpinKitCubeGrid(
                color: ColorResources.greyLightPrimary,
                size: 30.0,
              ),
            ),
          ) 
        : feed.getBranchStatus == GetBranchStatus.error 
        ? Container(
            height: 45.0, 
            margin: const EdgeInsets.only(
              top: 30.0,
            ), 
            child: Center(
              child: Text(getTranslated("PLEASE_TRY_AGAIN_LATER"),
                style: const TextStyle(
                  color: ColorResources.greyLightPrimary,
                  fontSize: Dimensions.fontSizeOverLarge,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro'
                ),
              )
            ),
          ) 
        : feed.getBranchStatus == GetBranchStatus.empty 
        ? Container(
            height: 45.0, 
            margin: const EdgeInsets.only(
              top: 30.0,
            ), 
            child: const Center(
              child: Text('No Tag',
                style: TextStyle(
                  color: ColorResources.greyLightPrimary,
                  fontSize: Dimensions.fontSizeOverLarge,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro'
                ),
              )
            ),
          ) 
        : Container(
            height: 45.0,
            margin: const EdgeInsets.only(
              top: 20.0,
            ),
            child: ListView.builder(
              controller: feed.countriesC,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: feed.branches.length,
              itemBuilder: (BuildContext context, int i) {
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 13.0,
                      right: i == feed.branches.length - 1 
                      ? 13.0 
                      : 0
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        width: 1.5,
                        color: ColorResources.white
                      ),
                      color: feed.selectedVarTag == i
                      ? ColorResources.white 
                      : ColorResources.transparent
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          feed.selectedTag(
                            feed.branches[i].branch,
                            i
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(feed.branches[i].branch,
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeDefault,
                              color: feed.selectedVarTag == i
                              ? ColorResources.black 
                              : ColorResources.white
                            ),
                          ),
                        ),
                      ),
                    )
                  ),
                );
              },
            )
          );
        },
      );
    }
  }