import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/custom_themes.dart';
import 'package:ppidunia/utils/dimensions.dart';
import 'package:ppidunia/views/screens/auth/sign_up/third_step_screen/otp_screen_model.dart';
import 'package:provider/provider.dart';

class OtpContentWidget extends StatelessWidget {
  const OtpContentWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OtpScreenModel>(
      builder: (context, model, _) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: model.onProcessOTP
            ? OngoingContent(model: model,)
            : const SuccessContent(),
        );
      }
    );
  }
}

class OngoingContent extends StatefulWidget {
  final OtpScreenModel model;
  
  const OngoingContent({
    super.key, required this.model,
  });

  @override
  State<OngoingContent> createState() => _OngoingContentState();
}

class _OngoingContentState extends State<OngoingContent> {
  bool _startTimer = false;

  final StopWatchTimer _timer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromSecond(60),
  );

  String _parseSeconds(int value) {
    value++;
    if(value > 1) return "${getTranslated('RESEND_ATTEMPT')} $value ${getTranslated('PLURAL_SECOND')}";
    return "${getTranslated('RESEND_ATTEMPT')} $value ${getTranslated('SINGULAR_SECOND')}";
  }

  @override
  void initState() {
    super.initState();

    _timer.fetchEnded.listen((value) {
      _startTimer = false;
      _timer.onResetTimer();
      setState(() { });
    });
  } 
  
  @override
  void dispose() {
    super.dispose();

    _timer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Column(
      key: const Key('otp-ongoing'),
      children: [
        OtpTextField(
          clearText: true,
          onSubmit: (value) {
            widget.model.value = value;
          }, 
          fieldWidth: screenSize.width * 0.15,
          borderColor: ColorResources.black,
          focusedBorderColor: ColorResources.white,
          styles: [
            sfProRegular.copyWith(
              fontSize: Dimensions.fontSizeTitle,
              fontWeight: FontWeight.bold,
            ),
            sfProRegular.copyWith(
              fontSize: Dimensions.fontSizeTitle,
              fontWeight: FontWeight.bold,
            ),
            sfProRegular.copyWith(
              fontSize: Dimensions.fontSizeTitle,
              fontWeight: FontWeight.bold,
            ),
            sfProRegular.copyWith(
              fontSize: Dimensions.fontSizeTitle,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        const SizedBox(height: 35,),
        _startTimer
        ? StreamBuilder<int>(
            stream: _timer.secondTime,
            initialData: _timer.initialPresetTime,
            builder: (context, snap) {
              final value = snap.data ?? 0;
              return Text(_parseSeconds(value),
                style: sfProRegular,
              );
            }
          )
        : RichText(
          text: TextSpan(
            children: [
              TextSpan(text: getTranslated("RESEND_OTP")),
              TextSpan(text: ' ${getTranslated("RESEND_OTP_TOGGLE")}',
                style: sfProRegular.copyWith(
                  color: ColorResources.primaryButton,
                ),
                recognizer: TapGestureRecognizer()
                ..onTap = () {
                  widget.model.resendOTP(context);
                  _startTimer = true;
                  _timer.onStartTimer();
                  setState(() { });
                },
              ),
        
            ]
          ),
        ),
      ],
    );
  }
}

class SuccessContent extends StatelessWidget {
  const SuccessContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        key: const Key('otp-success'),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(getTranslated('OTP_SUCCESS_1'),
            style: sfProRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: ColorResources.hintColor
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15,),
          Text(getTranslated('OTP_SUCCESS_2'),
            style: sfProRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: ColorResources.hintColor
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
  }
}