import 'package:flutter/material.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:provider/provider.dart';

import 'package:ppidunia/services/navigation.dart';

import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/views/screens/feed/feed/feed_screen_model.dart';

import 'package:ppidunia/views/screens/feed/post/create_post_state.dart';

class FeedSearch extends StatelessWidget {
  const FeedSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedScreenModel>(
      builder: (BuildContext context, FeedScreenModel fsm, Widget? child) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [

            Expanded(
              flex: 22,
              child: Container(
                margin: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0
                ),
                height: 50.0,
                child: TextField(
                  controller: fsm.searchC,
                  cursorColor: ColorResources.hintColor,
                  style: const TextStyle(
                    color: ColorResources.hintColor,
                    fontSize: 20.0,
                    fontFamily: 'SF Pro'
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                      top: 12.0,
                      bottom: 12.0
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                        color: ColorResources.transparent
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                        color: ColorResources.transparent
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                        color: ColorResources.transparent
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                        color: ColorResources.transparent
                      ),
                    ),
                    hintText: getTranslated("SEARCH"),
                    hintStyle: const TextStyle(
                      color: ColorResources.hintColor,
                      fontSize: 20.0,
                      fontFamily: 'SF Pro'
                    ),
                    fillColor: ColorResources.greySearchPrimary,
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 30.0,
                      color: ColorResources.hintColor,
                    )
                  ),
                )
              ),
            ),

            Expanded(
              flex: 3,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [

                  Material(
                    color: ColorResources.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () {
                        NS.push(context, const CreatePostScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/icons/ic-write-post.png',
                          fit: BoxFit.scaleDown,
                          width: 30.0,
                        ),
                      ),
                    ),
                  ),

                  // Material(
                  //   color: ColorResources.transparent,
                  //   child: InkWell(
                  //     borderRadius: BorderRadius.circular(8.0),
                  //     onTap: () {
                  //       debugPrint("test");
                  //     },
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Image.asset('assets/images/icons/ic-list.png',
                  //         fit: BoxFit.scaleDown,
                  //         width: 30.0,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                ],
              )
            )

          ],
        );
      },
    );
  }
}