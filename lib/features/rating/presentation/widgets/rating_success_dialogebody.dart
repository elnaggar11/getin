import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RatingSuccessDialogebody extends StatefulWidget {
  const RatingSuccessDialogebody({super.key});

  @override
  State<RatingSuccessDialogebody> createState() =>
      _RatingSuccessDialogebodyState();
}

class _RatingSuccessDialogebodyState extends State<RatingSuccessDialogebody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      // height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          61.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocalizationHelper.tr.rating_value,
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
          Divider(
            thickness: 1,
            height: 0,
            color: LightThemeColors.black.withOpacity(
              .1,
            ),
          ),
          30.ph,
          Image.asset(
            ImgAssets.ratingSuccess,
          ),
          20.ph,
          SizedBox(
            width: 280,
            child: Text(
              style: TextStyles.font18BlackExtraBold.copyWith(
                color: LightThemeColors.primary,
              ),
              LocalizationHelper.tr.delivery_rating_successful,
              textAlign: TextAlign.center,
            ),
          ),
          20.ph,
          Text(
            LocalizationHelper.tr.operation_completed_successfully,
            style: TextStyles.font12BlackBold.copyWith(
              fontWeight: FontWeights.medium,
              color: LightThemeColors.lightgrey,
            ),
          ),
          30.ph,
          ButtonWidget(
            buttonColor: LightThemeColors.orange,
            textColor: LightThemeColors.grey,
            title: LocalizationHelper.tr.skip,
          ),
          37.ph,
        ],
      ),
    );
  }
}
