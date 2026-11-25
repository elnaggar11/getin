import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/scheduleorder/domain/model/scheduleorder_model.dart';

class ScheduleorderItem extends StatelessWidget {
  const ScheduleorderItem({super.key, this.item, this.onRefresh});
  final ScheduleorderModel? item;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.pushNamed(
          context,
          Routes.ScheduleOrderDetailScreen,
          arguments: item,
        );
        if (result == "refresh" && onRefresh != null) {
          onRefresh!();
        }
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
        ),
        decoration: BoxDecoration(
          color: LightThemeColors.darkwhite,
          borderRadius: BorderRadius.circular(
            40,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      24,
                    ),
                    color: LightThemeColors.primary,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      SvgAssets.sechdualOrderIcon,
                    ),
                  ),
                ),
                10.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item?.branch?.name ?? "",
                        style: TextStyles.font16BlackSemiBold.copyWith(
                          color: LightThemeColors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      2.ph,
                      Row(
                        children: [
                          Text(
                            "₺${item?.total_price ?? "0.00"}",
                            style: TextStyles.font12BlackBold.copyWith(
                              color: LightThemeColors.primary,
                            ),
                          ),
                          16.pw,
                          Expanded(
                            child: Text(
                              item?.orderReceiptTime ?? "",
                              style: TextStyles.font12BlackBold.copyWith(
                                fontWeight: FontWeights.regular,
                                color: LightThemeColors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.QrScreen,
                      arguments: item!.id,
                    );
                  },
                  icon: Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: LightThemeColors.primary,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        SvgAssets.scanIcon,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            10.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(item?.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item?.status ?? "",
                    style: TextStyles.font12BlackBold.copyWith(
                      color: _getStatusColor(item?.status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      LocalizationHelper.tr.see_more,
                      style: TextStyles.font12BlackBold.copyWith(
                        color: LightThemeColors.primary,
                        fontWeight: FontWeights.semiBold,
                      ),
                    ),
                    10.pw,
                    const Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: LightThemeColors.primary,
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return LightThemeColors.primary;
      case 'cancelled':
      case 'canceled':
        return LightThemeColors.error;
      default:
        return const Color.fromARGB(255, 239, 166, 8);
    }
  }
}
