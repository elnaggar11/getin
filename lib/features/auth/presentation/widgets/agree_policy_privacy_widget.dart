import 'package:flutter/material.dart';
import '../../../../core/localization/localization_helper.dart';
import '../../../../core/resources/font_manager.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../core/utils/extentions.dart';

class AgreePolicyPrivacyWidget extends StatefulWidget {
  const AgreePolicyPrivacyWidget({
    super.key,
    this.onChange,
    this.title,
  });

  final Function(bool?)? onChange;
  final String? title;

  @override
  State<AgreePolicyPrivacyWidget> createState() =>
      _AgreePolicyPrivacyWidgetState();
}

class _AgreePolicyPrivacyWidgetState extends State<AgreePolicyPrivacyWidget> {
  bool agree = false;

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
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
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
            8.pw,
            Flexible(
              child: Text(
                widget.title ?? LocalizationHelper.tr.unspecified_phrase,
                style: TextStyles.font14BlackMedium.copyWith(
                  fontWeight: FontWeights.medium,
                  fontSize: 13,
                  color: LightThemeColors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
