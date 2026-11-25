import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:flutter/material.dart';

class KeyWordWidget extends StatelessWidget {
  const KeyWordWidget({super.key, this.keyWord, this.isActive});
  final String? keyWord;
  final bool? isActive;
  @override
  Widget build(BuildContext context) {
    return Container(
      //  width: 160,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: isActive == true
            ? LightThemeColors.primary
            : LightThemeColors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          width: 1,
          color: LightThemeColors.dividercolor,
        ),
      ),
      child: Center(
        child: Text(
          keyWord ?? LocalizationHelper.tr.unspecified_phrase,
          style: TextStyles.font14BlackBold.copyWith(
            fontWeight: FontWeights.regular,
            color: isActive == true
                ? LightThemeColors.white
                : LightThemeColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
