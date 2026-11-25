import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/addresses/presentation/widgets/confirm_location_sheet_body.dart';
import 'package:getincoffee/features/addresses/presentation/widgets/create_addreess_sheet_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChosseWaylocationSheetbody extends StatelessWidget {
  const ChosseWaylocationSheetbody({super.key});

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
                LocalizationHelper.tr.delivery_option,
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
            padding: const EdgeInsets.all(
              10,
            ),
            decoration: BoxDecoration(
              color: LightThemeColors.dividercolor,
              borderRadius: BorderRadius.circular(
                40,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: LightThemeColors.white,
                        borderRadius: BorderRadius.circular(
                          24,
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          SvgAssets.homeDelivery,
                        ),
                      ),
                    ),
                    10.pw,
                    Text(
                      LocalizationHelper.tr.deliver_to_home,
                      style: TextStyles.font14BlackMedium.copyWith(
                        color: LightThemeColors.primary,
                        fontWeight: FontWeights.semiBold,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: LightThemeColors.orange,
                    borderRadius: BorderRadius.circular(
                      24,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ).onTap(() {
            Navigator.pop(context);
            Alerts.bottomSheet(
              context,
              child: const CreateAddreessSheetBody(),
            );
          }),
          15.ph,
          Container(
            padding: const EdgeInsets.all(
              10,
            ),
            decoration: BoxDecoration(
              color: LightThemeColors.dividercolor,
              borderRadius: BorderRadius.circular(
                40,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: LightThemeColors.white,
                        borderRadius: BorderRadius.circular(
                          24,
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          SvgAssets.location,
                        ),
                      ),
                    ),
                    10.pw,
                    Text(
                      LocalizationHelper.tr.pickup_from_branch,
                      style: TextStyles.font14BlackMedium.copyWith(
                        color: LightThemeColors.primary,
                        fontWeight: FontWeights.semiBold,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: LightThemeColors.orange,
                    borderRadius: BorderRadius.circular(
                      24,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ).onTap(
            () {
              Navigator.pop(context);
              Alerts.bottomSheet(
                context,
                child: const ConfirmLocationSheetBody(),
              );
            },
          ),
          44.5.ph,
        ],
      ),
    );
  }
}
