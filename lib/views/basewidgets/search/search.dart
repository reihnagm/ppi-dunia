import 'package:flutter/material.dart';

import 'package:ppidunia/common/utils/box_shadow.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/custom_themes.dart';
import 'package:ppidunia/common/utils/dimensions.dart';

// import 'package:ppidunia/views/screens/store/search_product.dart';

class SearchWidget extends StatelessWidget {
  final String? hintText;
  final String? type;
  const SearchWidget({Key? key, this.hintText, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if(type == "commerce") {
        //   NS.push(context, const SearchProductScreen(typeProduct: "commerce"));
        // }
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: ColorResources.white,
          boxShadow: boxShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Icon(
                      Icons.search,
                      size: 20.0,
                      color: ColorResources.primary,
                    ),
                    const SizedBox(width: 10.0),
                    Text(hintText!,
                        style: sfProRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: ColorResources.primary),
                        overflow: TextOverflow.ellipsis)
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
