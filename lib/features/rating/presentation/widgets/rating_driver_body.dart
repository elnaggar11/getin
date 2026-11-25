import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/myorder/domain/model/myorder_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/localization_helper.dart';
import '../../../../core/resources/font_manager.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../shared/widgets/default_image_widget.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import '../../../../shared/widgets/rating_widget.dart';

class DriverRateBody extends StatelessWidget {
  const DriverRateBody({
    super.key,
    this.controlelr,
    this.onchange,
    required this.driver,
    this.initialRating = 0.0,
  });
  final TextEditingController? controlelr;
  final Driver driver;
  final Function(double)? onchange;
  final double initialRating;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: const Color(0xffF8F8F8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ClipOval(
                  child: DefaultImageWidget(
                    width: 50,
                    height: 50,
                    ImgAssets.onboardingImage,
                    fit: BoxFit.cover,
                  ),
                ),
                10.ph,
                Text(
                  "${driver.firstName} ${driver.lastName} ",
                  style: TextStyles.font14BlackBold.copyWith(
                    color: LightThemeColors.primary,
                    fontWeight: FontWeights.medium,
                  ),
                ),
                Text(
                  LocalizationHelper.tr.driver_vehicle,
                  style: TextStyles.font14BlackBold.copyWith(
                      color: LightThemeColors.grey,
                      fontWeight: FontWeights.regular,
                      fontSize: 12),
                )
              ],
            ),
          ),
          15.ph,
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              LocalizationHelper.tr.rating_driver,
              style: TextStyles.font16BlackSemiBold.copyWith(
                color: LightThemeColors.primary,
              ),
            ),
          ),
          15.ph,
          CustomRatingWidget(
            initialValue: initialRating,
            onChange: onchange,
            starCount: 5,
          ),
          15.ph,
          TextFormFieldWidget(
            controller: controlelr,
            maxLines: 6,
            minLines: 6,
            hintText: LocalizationHelper.tr.your_comment,
            backgroundColor: LightThemeColors.darkwhite,
            borderColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
