import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/notification/domain/model/notifications_model.dart';
import 'package:getincoffee/shared/widgets/default_image_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/font_manager.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key, required this.notificationModel});

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: LightThemeColors.darkwhite,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(19),
                decoration: BoxDecoration(
                    color: LightThemeColors.primary,
                    borderRadius: BorderRadius.circular(24)),
                child: const Center(
                  child: DefaultImageWidget(
                    SvgAssets.notificationIconScreen,
                  ),
                ),
              ),
              Text(
                notificationModel.createdAt ??
                    LocalizationHelper.tr.unspecified_phrase,
                style: TextStyles.font16BlackRegular.copyWith(
                  color: LightThemeColors.grey,
                  fontSize: 14,
                ),
              )
            ],
          ),
          10.ph,
          Text(
            notificationModel.data?.message ??
                LocalizationHelper.tr.unspecified_phrase,
            style: TextStyles.font16BlackRegular.copyWith(
              color: LightThemeColors.grey,
              fontSize: 16,
              fontWeight: FontWeights.semiBold,
            ),
          ),
          10.ph,
          Text(
            notificationModel.data?.message ??
                LocalizationHelper.tr.unspecified_phrase,
            style: TextStyles.font16BlackRegular.copyWith(
              color: LightThemeColors.lightgrey,
              fontWeight: FontWeights.medium,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
