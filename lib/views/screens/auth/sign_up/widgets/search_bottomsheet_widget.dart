import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/utils/custom_themes.dart';
import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/dimensions.dart';
import 'package:ppidunia/views/screens/auth/sign_up/second_step_screen/study_abroad_status_screen_model.dart';

class SearchBottomsheetWidget extends StatelessWidget {
  final TextEditingController searchC;
  final Size screenSize; 
  final ScrollController scrollC;

  const SearchBottomsheetWidget({super.key, required this.screenSize, required this.searchC, required this.scrollC});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenSize.height * 0.5,
      decoration: BoxDecoration(
        color: ColorResources.primaryBottomSheet,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: ColorResources.black.withOpacity(0.6), blurRadius: 20.0,)],
      ),
      child: Column(
        children: [
          Container(
            height: 7,
            margin: const EdgeInsets.all(20.0),
            width: screenSize.width * 0.16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: ColorResources.white.withOpacity(0.4),
            ),
          ),
          Consumer<StudyAbroadStatusScreenModel>(
            builder: (context, viewModel, _) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: searchC,
                  onChanged: (value) {
                    viewModel.runFilter(context, value);
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter,
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                  ],
                  style: sfProRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: ColorResources.fillPrimary.withOpacity(0.5),
                    prefixIcon: const Icon(Icons.search,
                      color: ColorResources.hintColor,
                      size: Dimensions.iconSizeLarge,
                    ),
                    hintText: 'Search',
                    hintStyle: sfProRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: ColorResources.hintColor,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: ColorResources.transparent)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: ColorResources.transparent)
                    )
                  ),
                ),
              );
            }
          ),
          Expanded(
            child: Consumer<StudyAbroadStatusScreenModel>(
              builder: (context, viewModel, _) {
                return ListView.builder(
                  controller: scrollC,
                  itemCount: viewModel.foundSearch!.length + 1,
                  itemBuilder: (context, index) {
                    if(index < viewModel.foundSearch!.length) {
                      return Material(
                          type: MaterialType.transparency,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                            onTap: () {
                              final value = viewModel.foundSearch?[index];
                              viewModel.setStudyAbroadValue(value?.uid ?? "-");
                              NS.pop(context);
                            },
                            title: Text(viewModel.foundSearch?[index].name ?? "...",
                              style: sfProRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                              ),
                            ),
                          ),
                        );
                      } else if (viewModel.foundSearch?.isEmpty == true) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(getTranslated('COUNTRY_NOT_FOUND'),
                              style: sfProRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: viewModel.hasMore
                              ? viewModel.isLoadingItem
                                ? const CircularProgressIndicator()
                                : const SizedBox.shrink()
                              : const SizedBox.shrink(),
                          ),
                        );
                      }
                    },
                  );
              }
            ),
            )
          ],
        ),
      );
    }
  }