import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/views/basewidgets/background/grey.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/second_step_screen/study_abroad_status_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/second_step_screen/study_abroad_status_state.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/widgets/auth_column_widget.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/widgets/study_abroad_radio_list_widget.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/widgets/study_abroad_status_buttons_widget.dart';
import 'package:provider/provider.dart';
import 'package:ppidunia/common/utils/custom_themes.dart';

class StudyAbroadStatusScreenState extends State<StudyAbroadStatusScreen> {
  late StudyAbroadStatusScreenModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = context.read<StudyAbroadStatusScreenModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.resetStudyAbroad();
      viewModel.getCountries(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: GreyBackgroundWidget(
            screenSize: screenSize,
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  AuthColumnWidget(
                    screenSize: screenSize,
                    top: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text(
                        getTranslated('ASK_STUDY_ABROAD'),
                        style: sfProRegular.copyWith(
                          fontSize: Dimensions.fontSizeTitle,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    content: const StudyAbroadRadioList(),
                    contentHeight: 0.4,
                    bottom: const Hero(
                        tag: 'smooth-btn',
                        child: Material(
                            type: MaterialType.transparency,
                            child: StudyAbroadStatusButtonsWidget())),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
