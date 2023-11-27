import 'package:flutter/material.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/common/utils/custom_themes.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/second_step_screen/study_abroad_status_screen_model.dart';
import 'package:provider/provider.dart';

class StudyAbroadRadioList extends StatelessWidget {
  const StudyAbroadRadioList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<StudyAbroadStatusScreenModel>(builder: (context, model, _) {
      return Wrap(
        children: [
          RadioListTile(
            visualDensity: VisualDensity.comfortable,
            dense: true,
            value: StudyAbroadOptions.abroad,
            groupValue: model.selectedStudyAbroadOption,
            onChanged: (value) =>
                model.setselectedStudyAbroadOption(context, value!, model),
            title: Text(
              getTranslated('STUDY_ABROAD_OPTION_1'),
              style: sfProRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraLarge,
              ),
            ),
          ),
          RadioListTile(
            visualDensity: VisualDensity.comfortable,
            dense: true,
            value: StudyAbroadOptions.notAbroad,
            groupValue: model.selectedStudyAbroadOption,
            onChanged: (value) =>
                model.setselectedStudyAbroadOption(context, value!, model),
            title: Text(
              getTranslated('STUDY_ABROAD_OPTION_2'),
              style: sfProRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraLarge,
              ),
            ),
          ),
        ],
      );
    });
  }
}
