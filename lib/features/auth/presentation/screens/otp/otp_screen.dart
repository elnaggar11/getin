import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import '../../../../../core/generated/images.dart';
import '../../../../../core/localization/localization_helper.dart';
import '../../../../../core/resources/font_manager.dart';
import '../../../../../core/theme/light_theme.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/widgets/button_widget.dart';
import '../../widgets/auth_top_header.dart';

class OtpScreen extends StatefulWidget {
  final String sendTo;
  final Function(String code) onSubmit;
  final bool? init;
  final VoidCallback onReSend;

  const OtpScreen({
    super.key,
    required this.sendTo,
    required this.onSubmit,
    required this.onReSend,
    this.init,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final formKey = GlobalKey<FormState>();
  DateTime target = DateTime.now().add(const Duration(minutes: 2));
  bool isVerified = false;
  DateTime now = DateTime.now();
  Timer? timer;
  String remainingTime = '02:00';
  final TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.init == true) widget.onReSend.call();
      startTimer();
    });
  }

  void startTimer() {
    timer?.cancel();
    target = DateTime.now().add(const Duration(minutes: 2));
    now = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (s) {
      if (now.isBefore(target)) {
        now = now.add(const Duration(seconds: 1));
        final remaining = target.difference(now);
        remainingTime =
            '${remaining.inMinutes.toString().padLeft(2, '0')}:${remaining.inSeconds.remainder(60).toString().padLeft(2, '0')}';
        if (mounted) setState(() {});
      } else {
        remainingTime = '';
        timer?.cancel();
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: TextStyles.font18BlackBold.copyWith(
        fontSize: 22,
        fontWeight: FontWeights.bold,
        color: LightThemeColors.primary,
      ),
      decoration: BoxDecoration(
        color: LightThemeColors.offwhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: LightThemeColors.primary.withOpacity(.12),
          width: 1,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: LightThemeColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: LightThemeColors.primary,
          width: 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: LightThemeColors.primary.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5F3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: LightThemeColors.primary.withOpacity(.35),
          width: 1.2,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: LightThemeColors.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AuthTopHeader(
              showLogo: false,
              showBack: true,
              title: LocalizationHelper.tr.verify_mobile_number,
              subtitle: LocalizationHelper.tr.enter_code_sent_mobile,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                decoration: const BoxDecoration(
                  color: LightThemeColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 20,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              28.ph,
                              Container(
                                width: 90,
                                height: 90,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F5F3),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: LightThemeColors.primary
                                        .withOpacity(0.08),
                                    width: 1.5,
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  SvgAssets.otpPhone,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              18.ph,
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: LightThemeColors.offwhite,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: LightThemeColors.primary
                                        .withOpacity(0.08),
                                  ),
                                ),
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.phone_iphone_rounded,
                                        size: 16,
                                        color: LightThemeColors.primary,
                                      ),
                                      6.pw,
                                      Text(
                                        widget.sendTo,
                                        style:
                                            TextStyles.font14BlackBold.copyWith(
                                          color: LightThemeColors.primary,
                                          fontWeight: FontWeights.semiBold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              32.ph,
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Pinput(
                                  length: 4,
                                  autofocus: true,
                                  keyboardType: TextInputType.number,
                                  controller: otpController,
                                  defaultPinTheme: defaultPinTheme,
                                  focusedPinTheme: focusedPinTheme,
                                  submittedPinTheme: submittedPinTheme,
                                  separatorBuilder: (index) =>
                                      const SizedBox(width: 12),
                                  pinAnimationType: PinAnimationType.scale,
                                  validator: Utils.valid.defaultValidation,
                                  onChanged: (value) {
                                    setState(
                                        () => isVerified = value.length == 4);
                                  },
                                  onCompleted: (pin) {
                                    widget.onSubmit(pin);
                                  },
                                ),
                              ),
                              30.ph,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LocalizationHelper.tr.didnt_receive_code,
                                    style:
                                        TextStyles.font14BlackMedium.copyWith(
                                      fontSize: 13,
                                      color: LightThemeColors.lightgrey,
                                    ),
                                  ),
                                  8.pw,
                                  remainingTime.isEmpty
                                      ? InkWell(
                                          onTap: () {
                                            widget.onReSend.call();
                                            startTimer();
                                          },
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 2,
                                            ),
                                            child: Text(
                                              LocalizationHelper.tr.resend_code,
                                              style: TextStyles.font14BlackBold
                                                  .copyWith(
                                                fontSize: 13,
                                                color: LightThemeColors.primary,
                                                fontWeight: FontWeights.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: LightThemeColors.offwhite,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            remainingTime,
                                            style: TextStyles.font14BlackBold
                                                .copyWith(
                                              fontSize: 13,
                                              color: LightThemeColors.secondary,
                                              fontWeight: FontWeights.bold,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 20),
                          child: ButtonWidget(
                            title: LocalizationHelper.tr.verify,
                            witharrows: isVerified,
                            buttonColor: isVerified
                                ? LightThemeColors.primary
                                : LightThemeColors.primary.withOpacity(.45),
                            onTap: isVerified
                                ? () async =>
                                    widget.onSubmit(otpController.text)
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
