import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/home/presentation/widgets/star_point_widget.dart';
import 'package:getincoffee/shared/widgets/default_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/font_manager.dart';
import '../../../productdetails/presentation/screens/productdetails_screen.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    this.product,
    this.add,
    this.decrease,
    this.branchId,
    this.withButtom,
    this.showAddButton = true,
    this.showStar = false,
    this.onDeleted,
    this.refresh,
    this.isSchedule = false,
  });
  final ProductModel? product;
  final String? branchId;
  final bool? withButtom;
  final bool? showStar;
  final bool showAddButton;
  final VoidCallback? refresh;
  final bool isSchedule;
  final Function(int)? add;
  final Function(int)? decrease;
  final Function(ProductModel)? onDeleted;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  bool isAdded = false;
  int quan = 1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(4, 4),
                  spreadRadius: 1,
                  blurRadius: 5,
                  color: Colors.black.withValues(
                    alpha: 0.2,
                  ),
                )
              ],
              color: LightThemeColors.cardBackground,
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      8.pw,
                      Container(
                        width: 95,
                        height: 95,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            26,
                          ),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                26,
                              ),
                              child: DefaultImageWidget(
                                widget.product?.mainImage ??
                                    LocalizationHelper.tr.unspecified_phrase,
                                fit: BoxFit.cover,
                                width: 90,
                                height: 90,
                              ),
                            ),
                            if ((widget.product?.remaining_quantity ?? "1") ==
                                "0") ...[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: .5),
                                  borderRadius: BorderRadius.circular(26),
                                ),
                              ),

                              // Text shown when unavailable
                              const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'unavailable',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      10.pw,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              //height: 22,
                              child: Text(
                                (widget.product?.name ?? "") * 1,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.font12BlackBold.copyWith(
                                  color: LightThemeColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeights.extraBold,
                                ),
                              ),
                            ),
                            3.ph,
                            SizedBox(
                              width: 248,
                              child: Text(
                                widget.product?.description ??
                                    LocalizationHelper.tr.unspecified_phrase,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyles.font12BlackBold.copyWith(
                                  fontWeight: FontWeights.medium,
                                  color: LightThemeColors.lightgrey,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            3.ph,
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    // color: LightThemeColors.buttonColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        SvgAssets.Star,
                                      ),
                                      2.pw,
                                      Text(
                                        widget.product?.rating_avg ??
                                            LocalizationHelper
                                                .tr.unspecified_phrase,
                                        style:
                                            TextStyles.font14BlackBold.copyWith(
                                          fontWeight: FontWeights.regular,
                                          fontSize: 10,
                                        ),
                                      ),
                                      5.pw,
                                      Text(
                                        "(${widget.product?.revies_count ?? LocalizationHelper.tr.unspecified_phrase}${(widget.product?.showReviewsCount() ?? false) ? "+" : ""})",
                                        style:
                                            TextStyles.font14BlackBold.copyWith(
                                          fontWeight: FontWeights.regular,
                                          fontSize: 10,
                                          color: const Color(0xFF737373),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                3.pw,
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: LightThemeColors.lightgrey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                6.pw,
                                Text(
                                  widget.product?.delivery_time ??
                                      LocalizationHelper.tr.unspecified_phrase,
                                  style: TextStyles.font14BlackBold.copyWith(
                                    fontWeight: FontWeights.regular,
                                    fontSize: 11,
                                    color: const Color(0xFF737373),
                                  ),
                                ),
                                6.pw,
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: LightThemeColors.lightgrey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                6.pw,
                                // 10.pw,
                                SvgPicture.asset(
                                  SvgAssets.wallet,
                                ),
                                4.pw,
                                Text(
                                  "+${widget.product?.total_sales ?? LocalizationHelper.tr.unspecified_phrase}",
                                  style: TextStyles.font14BlackBold.copyWith(
                                    fontWeight: FontWeights.regular,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            3.ph,
                            Row(
                              children: [
                                Text(
                                  "₺${widget.product?.getPrice() ?? LocalizationHelper.tr.unspecified_phrase}",
                                  style: TextStyles.font14BlackBold.copyWith(
                                    fontWeight: FontWeights.semiBold,
                                    color: LightThemeColors.primary,
                                    fontSize: 12,
                                  ),
                                ),
                                if (widget.product?.getOriginalPrice() !=
                                    null) ...[
                                  5.pw,
                                  Text(
                                    "₺${widget.product?.getOriginalPrice() ?? LocalizationHelper.tr.unspecified_phrase}",
                                    style: TextStyles.font14BlackBold.copyWith(
                                      fontWeight: FontWeights.semiBold,
                                      color: LightThemeColors.grey
                                          .withValues(alpha: 0.5),
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                                5.pw,
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: LightThemeColors.lightgrey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                5.pw,
                                Text(
                                  "+${widget.product?.points ?? LocalizationHelper.tr.unspecified_phrase} points",
                                  style: TextStyles.font14BlackBold.copyWith(
                                    // decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeights.medium,
                                    color: LightThemeColors.green,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // 46.pw,
                !widget.showAddButton
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          /* decoration: BoxDecoration(
                            color: LightThemeColors.lightgrey.withValues(
                              alpha: .4,
                            ),
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                          ), */
                          child: Center(
                            child: FavoriteIcon(
                              refresh: widget.refresh,
                              branchId: widget.branchId,
                              favourite_id: widget.product?.favourite_id,
                              isFavorite: widget.product?.isLiked,
                              id: widget.product?.id ??
                                  LocalizationHelper.tr.unspecified_phrase,
                            ),
                          ),
                        ),
                      ).onTap(() {
                        //widget.onDeleted?.call(widget.product!);
                      })
                    // const SizedBox.shrink()
                    : Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: LightThemeColors.primary,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                size: 16,
                                color: LightThemeColors.white,
                              ),
                            ),
                          ).onTap(() {
                            widget.add?.call(quan);
                          }),
                          15.pw,
                        ],
                      ),
              ],
            ),
          ).onTap(() {
            if (widget.withButtom == false) {
              Navigator.pop(
                context,
                widget.product?..choosenNumber = quan.toString(),
              );
            } else {
              if (((widget.product?.remaining_quantity ?? "1") == "0")) {
                Alerts.snack(
                    text: "Product is not available", state: SnackState.failed);
                return;
              }
              Navigator.pushNamed(
                context,
                Routes.ProductdetailsScreen,
                arguments: ProductDetailsargs(
                    id: widget.product?.id ??
                        LocalizationHelper.tr.unspecified_phrase,
                    branchId: widget.branchId ?? "",
                    isSchedule: widget.isSchedule),
              );
            }
          }),
          if (widget.showStar == true && widget.product?.stars != null)
            Positioned(
              top: -3,
              right: (LocalizationHelper.isRTL ? -10 : null),
              left: (LocalizationHelper.isRTL ? null : -10),
              child: StarPointWidget(
                count: num.parse(widget.product?.stars ?? "0").toInt(),
              ),
            )
        ],
      ),
    );
  }
}
