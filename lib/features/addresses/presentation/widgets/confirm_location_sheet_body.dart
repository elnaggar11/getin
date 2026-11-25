import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/localization/localization_helper.dart';

class ConfirmLocationSheetBody extends StatelessWidget {
  const ConfirmLocationSheetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        children: [
          61.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocalizationHelper.tr.how_receive_order,
                style: TextStyles.font14BlackMedium.copyWith(
                  color: LightThemeColors.black,
                  fontWeight: FontWeights.extraBold,
                ),
              ),
              SvgPicture.asset(
                SvgAssets.cannerIcon,
              ),
            ],
          ),
          20.ph,
          const Divider(
            thickness: 1,
            height: 0,
            color: LightThemeColors.darkwhite,
          ),
          30.ph,
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: LightThemeColors.primary,
              borderRadius: BorderRadius.circular(
                24,
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                SvgAssets.confirmlocationIcon,
              ),
            ),
          ),
          20.ph,
          Text(
            LocalizationHelper.tr.confirm_your_location,
            style: TextStyles.font22BlackBlack.copyWith(
              color: LightThemeColors.black,
              fontWeight: FontWeights.extraBold,
            ),
          ),
          20.ph,
          SizedBox(
            width: 350,
            child: Text(
              textAlign: TextAlign.center,
              LocalizationHelper.tr.delivery_location_confirmation,
              style: TextStyles.font12BlackBold.copyWith(
                fontWeight: FontWeights.regular,
                color: LightThemeColors.lightgrey,
              ),
            ),
          ),
          30.ph,
          Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  title: LocalizationHelper.tr.i_confirm_my_location,
                ),
              ),
              6.pw,
              Expanded(
                child: ButtonWidget(
                  buttonColor: LightThemeColors.black,
                  title: LocalizationHelper.tr.change,
                ),
              )
            ],
          ),
          33.ph,
        ],
      ),
    );
  }
}
