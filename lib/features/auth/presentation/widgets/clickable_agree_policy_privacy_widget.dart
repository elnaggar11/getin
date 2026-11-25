import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../core/localization/localization_helper.dart';
import '../../../../core/resources/font_manager.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../core/utils/extentions.dart';

class ClickableAgreePolicyPrivacyWidget extends StatefulWidget {
  const ClickableAgreePolicyPrivacyWidget({
    super.key,
    this.onChange,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  final Function(bool?)? onChange;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  @override
  State<ClickableAgreePolicyPrivacyWidget> createState() =>
      _ClickableAgreePolicyPrivacyWidgetState();
}

class _ClickableAgreePolicyPrivacyWidgetState
    extends State<ClickableAgreePolicyPrivacyWidget> {
  bool agree = false;
  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () {
        widget.onTermsTap?.call();
      };
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        widget.onPrivacyTap?.call();
      };
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  List<TextSpan> _buildTextSpans() {
    final String fullText = LocalizationHelper.tr.p_privacy_policy;
    final String termsText = LocalizationHelper.tr.terms_conditions;

    final TextStyle defaultStyle = TextStyles.font14BlackMedium.copyWith(
      fontWeight: FontWeights.medium,
      fontSize: 12.5,
      color: LightThemeColors.grey,
      height: 1.4,
    );
    final TextStyle clickableStyle = defaultStyle.copyWith(
      color: LightThemeColors.primary,
      fontWeight: FontWeights.bold,
      decoration: TextDecoration.underline,
    );

    List<TextSpan> spans = [];

    int termsIndex = fullText.indexOf(termsText);

    if (termsIndex == -1) {
      return [TextSpan(text: fullText, style: defaultStyle)];
    }

    spans.add(
      TextSpan(text: fullText.substring(0, termsIndex), style: defaultStyle),
    );
    spans.add(
      TextSpan(
        text: termsText,
        style: clickableStyle,
        recognizer: _termsRecognizer,
      ),
    );
    spans.add(
      TextSpan(
        text: fullText.substring(termsIndex + termsText.length),
        style: defaultStyle,
      ),
    );

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        agree = !agree;
        widget.onChange?.call(agree);
        setState(() {});
      },
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: agree ? LightThemeColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    width: 1.5,
                    color: agree
                        ? LightThemeColors.primary
                        : LightThemeColors.lightgrey.withOpacity(0.5),
                  ),
                  boxShadow: agree
                      ? [
                          BoxShadow(
                            color: LightThemeColors.primary.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 180),
                    scale: agree ? 1.0 : 0.0,
                    child: const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: LightThemeColors.white,
                    ),
                  ),
                ),
              ),
            ),
            8.pw,
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: _buildTextSpans(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
