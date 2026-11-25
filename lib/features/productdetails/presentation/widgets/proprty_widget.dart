import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/productdetails/presentation/widgets/selectable_item.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/font_manager.dart'
    show TextStyles, FontWeights;
import '../../../../core/theme/light_theme.dart';
import '../../../home/domain/model/home_model.dart';

class PropertyWidget extends StatelessWidget {
  const PropertyWidget({
    super.key,
    this.title,
    this.withtitile = true,
  });
  final String? title;
  final bool withtitile;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (withtitile == true)
          Text(
            title ?? "Cup Type",
            style: TextStyles.font16BlackSemiBold,
          ),
        10.ph,
        Wrap(
          children: [
            Container(
              height: 32,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  24,
                ),
                color: LightThemeColors.cardBackground,
              ),
              child: Center(
                child: Text(
                  "small Cup",
                  style: TextStyles.font12BlackBold.copyWith(
                    color: LightThemeColors.grey,
                    fontWeight: FontWeights.regular,
                  ),
                ),
              ),
            ),
            2.pw,
            Container(
              height: 32,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  24,
                ),
                color: LightThemeColors.cardBackground,
              ),
              child: Center(
                child: Text(
                  "small Cup",
                  style: TextStyles.font12BlackBold.copyWith(
                    color: LightThemeColors.grey,
                    fontWeight: FontWeights.regular,
                  ),
                ),
              ),
            ),
            2.pw,
            Container(
              height: 32,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  24,
                ),
                color: LightThemeColors.cardBackground,
              ),
              child: Center(
                child: Text(
                  "small Cup",
                  style: TextStyles.font12BlackBold.copyWith(
                    color: LightThemeColors.grey,
                    fontWeight: FontWeights.regular,
                  ),
                ),
              ),
            ),
            2.pw,
            Container(
              height: 32,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  24,
                ),
                color: LightThemeColors.cardBackground,
              ),
              child: Center(
                child: Text(
                  "small Cup",
                  style: TextStyles.font12BlackBold.copyWith(
                    color: LightThemeColors.grey,
                    fontWeight: FontWeights.regular,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class PropertyWidget2 extends StatelessWidget {
  const PropertyWidget2({
    super.key,
    this.title,
    this.option,
    this.onChange,
    this.onMultipleChange,
    this.withtitile = true,
  });
  final String? title;
  final bool withtitile;
  final OptionModel? option;
  final Function(ValueOptionModel?)? onChange;
  final Function(List<ValueOptionModel>)? onMultipleChange;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (withtitile == true)
          Text(
            option?.name ?? LocalizationHelper.tr.unspecified_phrase,
            style: TextStyles.font16BlackSemiBold,
          ),
        10.ph,
        CupSizeSelector(
          type: option?.type ?? OptionType.singleChoice,
          onChange: onChange,
          onMultipleChange: onMultipleChange,
          values: option?.values ?? [],
        ),
      ],
    );
  }
}
