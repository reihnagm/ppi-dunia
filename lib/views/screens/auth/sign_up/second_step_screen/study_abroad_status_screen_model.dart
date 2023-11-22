import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ppidunia/data/models/country/country.dart';
import 'package:ppidunia/data/repository/auth/auth.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/utils/exceptions.dart';
import 'package:ppidunia/utils/shared_preferences.dart';
import 'package:ppidunia/views/basewidgets/snackbar/snackbar.dart';
import 'package:ppidunia/views/screens/auth/sign_up/third_step_screen/otp_state.dart';
import 'package:ppidunia/views/screens/auth/sign_up/widgets/search_bottomsheet_widget.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/utils/color_resources.dart';

enum StudyAbroadOptions { empty, abroad, notAbroad }

enum AssignCountryStatus { idle, loading, success, error }
AssignCountryStatus _assignCountryStatus = AssignCountryStatus.idle;

enum CountryListStatus { empty, loading, loaded, error }
CountryListStatus _countryListStatus = CountryListStatus.empty;

List<CountryData> _countryList = [];
List<CountryData> _searchCountryList = [];

abstract class StudyAbroadStatusScreenModelData {
  void setStateAssignCountryStatus(AssignCountryStatus status);
  Future<void> assignCountry(BuildContext context);
  void setStateCountryListStatus(CountryListStatus status);
  Future<void> getCountries(BuildContext context, {required int page, required String query});
  Future<List<CountryData>> searchCountries(BuildContext context, {required int page, required String query});
}


class StudyAbroadStatusScreenModel with ChangeNotifier implements StudyAbroadStatusScreenModelData {
  final AuthRepo ar;
  
  StudyAbroadStatusScreenModel({
    required this.ar,
  });

  AssignCountryStatus get assignCountryStatus => _assignCountryStatus;
  
  CountryListStatus get countryListStatus => _countryListStatus;

  List<CountryData> get countryList => _countryList;

  List<CountryData> get searchCountryList => _searchCountryList;

  List<CountryData>? foundSearch;

  StudyAbroadOptions selectedStudyAbroadOption = StudyAbroadOptions.empty;

  TextEditingController searchC = TextEditingController();
  Timer? debouncer;

  late String studyAbroadValue;

  ScrollController scrollC = ScrollController();
  late int pageNumber;
  bool isFetchingMore = false;
  bool hasMore = true;
  bool isLoadingItem = true;

  void scrollListener(BuildContext context) {
    if(scrollC.position.maxScrollExtent == scrollC.offset) {
      getCountries(context, page: pageNumber);
    }
  }

  void setStudyAbroadValue(String value) {
    studyAbroadValue = value;
    notifyListeners();
  }

  void resetStudyAbroad() {
    selectedStudyAbroadOption = StudyAbroadOptions.empty;
    pageNumber = 1;
    studyAbroadValue = "-";
    isFetchingMore = false;
    hasMore = true;
    isLoadingItem = true;
    _countryList.clear();
    _searchCountryList.clear();
    notifyListeners();
  }

  void setselectedStudyAbroadOption(BuildContext context, StudyAbroadOptions value, StudyAbroadStatusScreenModel viewModel) {
    selectedStudyAbroadOption = value;
    if(selectedStudyAbroadOption == StudyAbroadOptions.abroad) {
      buildBottomSheet(context, viewModel);
    } else if(selectedStudyAbroadOption == StudyAbroadOptions.notAbroad) {
      setStudyAbroadValue("19021987-fa82-4de8-82aa-ad6f8d55977f");
    }
    notifyListeners();
  }

  void _submissionValidation(BuildContext context, String selectedStudyAbroad) {
    if(selectedStudyAbroadOption == StudyAbroadOptions.empty) {
      ShowSnackbar.snackbar(context, getTranslated('STUDY_ABROAD_OPTION_0'), '', ColorResources.error);
      return;
    }
    if(selectedStudyAbroad == "-" && selectedStudyAbroadOption == StudyAbroadOptions.abroad) {
      ShowSnackbar.snackbar(context, getTranslated('COUNTRY_NOT_SELECTED'), '', ColorResources.error);
      return;
    }
    if(selectedStudyAbroad != "-" 
    && selectedStudyAbroadOption == StudyAbroadOptions.abroad
    || selectedStudyAbroadOption == StudyAbroadOptions.notAbroad) {
      SharedPrefs.writeRegCountryId(selectedStudyAbroad);
      assignCountry(context);
    }
    notifyListeners();
  }

  void submit(BuildContext context) {
    final selectedStudyAbroad = studyAbroadValue.trim();
    _submissionValidation(context, selectedStudyAbroad);
    notifyListeners();
  }

  void initScrolls(BuildContext context) {
    scrollC.addListener(() {
      scrollListener(context);
    });
  }

  void debounce({
    required VoidCallback callback,
    Duration duration = const Duration(milliseconds: 500)
  }) {
    if(debouncer != null) {
      debouncer!.cancel();
    }
    
    debouncer = Timer(duration, callback);
  }

  void runFilter(BuildContext context, String enteredKeyword) {
    debounce(callback: () async {
      pageNumber = 1;
      _countryList.clear();
      _searchCountryList.clear();
      List<CountryData> results = [];
      if (enteredKeyword.isEmpty) {
        isFetchingMore = false;
        hasMore = true;
        getCountries(context);
        _searchCountryList.clear();
        results.addAll(countryList);
      } else {
        _searchCountryList.clear();
        results = await searchCountries(context, query: enteredKeyword);
        results = results.where(
          (item) => item.name?.contains(item.name.toString()) ?? false
        ).toList();
      }

      isLoadingItem = false;
      foundSearch!.addAll(results);
      notifyListeners();
    },);
  }

  void buildBottomSheet(BuildContext context, StudyAbroadStatusScreenModel viewModel) {
    final screenSize = MediaQuery.sizeOf(context);
    foundSearch = countryList;
    initScrolls(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      barrierColor: ColorResources.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(35),
        )
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                return SearchBottomsheetWidget(
                  searchC: searchC,
                  screenSize: screenSize,
                  scrollC: scrollC,
                );
              }
            );
          }
        );
      },
    );
    notifyListeners();
  }

  @override
  void setStateCountryListStatus(CountryListStatus status) {
    _countryListStatus = status;
    notifyListeners();
  }
  
  @override
  Future<void> getCountries(BuildContext context, {int page = 1, String query = ""}) async {
    setStateCountryListStatus(CountryListStatus.loading);
    try {
      if(isFetchingMore) return;
      isFetchingMore = true;
      CountryModel cm = await ar.getCountries(page: page, search: query);
      List<CountryData> data = cm.data ?? [];
      if(data.isEmpty || data == []) {
        setStateCountryListStatus(CountryListStatus.empty);
      } else {
        pageNumber++;
        if(data.length < 10) {
          hasMore = false;
        }
        isFetchingMore = false;
        _countryList.addAll(data);
        setStateCountryListStatus(CountryListStatus.loaded);
      }
      notifyListeners();
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      NetworkException.handle(context, e.toString());
      setStateCountryListStatus(CountryListStatus.error);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      setStateCountryListStatus(CountryListStatus.error);
      notifyListeners();
    }
  }

  @override
  Future<List<CountryData>> searchCountries(BuildContext context, {int page = 1, String query = ""}) async {
    setStateCountryListStatus(CountryListStatus.loading);
    try {
      CountryModel cm = await ar.getCountries(page: page, search: query);
      List<CountryData> data = cm.data ?? [];
      if(data.isEmpty || data == []) {
        setStateCountryListStatus(CountryListStatus.empty);
        notifyListeners();
        return [];
      } else {
        _searchCountryList.addAll(data);
        setStateCountryListStatus(CountryListStatus.loaded);
        notifyListeners();
        return searchCountryList;
      }
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      NetworkException.handle(context, e.toString());
      setStateCountryListStatus(CountryListStatus.error);
      notifyListeners();
      return [];
    } catch (e) {
      debugPrint(e.toString());
      setStateCountryListStatus(CountryListStatus.error);
      notifyListeners();
      return [];
    }
  }
  
  @override
  void setStateAssignCountryStatus(AssignCountryStatus status) {
    _assignCountryStatus = status;
    notifyListeners();
  }

  @override
  Future<void> assignCountry(BuildContext context) async {
    setStateAssignCountryStatus(AssignCountryStatus.loading);
    try {
      await ar.assignCountry(data: SharedPrefs.getRegisterObject());
      NS.pushReplacement(context, const OtpScreen());
      setStateAssignCountryStatus(AssignCountryStatus.success);
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, e.toString(), '', ColorResources.error);
      NetworkException.handle(context, e.toString());
      setStateAssignCountryStatus(AssignCountryStatus.error);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      setStateAssignCountryStatus(AssignCountryStatus.error);
      notifyListeners();
    }
  }
  
}