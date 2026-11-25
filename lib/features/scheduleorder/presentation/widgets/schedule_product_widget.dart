import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart' hide ContextExtensions;
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/productdetails/domain/request/productdetails_request.dart';
import 'package:getincoffee/shared/widgets/default_image_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/font_manager.dart';

class ScheduleProductWidget extends StatefulWidget {
  const ScheduleProductWidget({
    super.key,
    this.cartproduct,
    this.add,
    this.delete,
    this.decrease,
    this.branchId,
    this.withButtom,
    this.showAddButton = true,
  });
  final AddtoCartRequest? cartproduct;
  final String? branchId;
  final bool? withButtom;
  final bool showAddButton;
  final Function(int)? add;
  final Function(int)? decrease;
  final Function()? delete;
  @override
  State<ScheduleProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ScheduleProductWidget> {
  bool isAdded = false;
  int quan = 1;
  late ProductModel product;
  @override
  void initState() {
    product = widget.cartproduct!.product!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      decoration: BoxDecoration(
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
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.circular(
                    //   26,
                    // ),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    // borderRadius: BorderRadius.circular(
                    //   26,
                    // ),

                    child: DefaultImageWidget(
                      product.images?.first ??
                          LocalizationHelper.tr.unspecified_phrase,
                    ),
                  ),
                ),
                10.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ??
                            LocalizationHelper.tr.unspecified_phrase,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.font12BlackBold.copyWith(
                          color: LightThemeColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeights.extraBold,
                        ),
                      ),
                      3.ph,
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "₺${widget.cartproduct?.totalPrice ?? LocalizationHelper.tr.unspecified_phrase}",
                            style: TextStyles.font14BlackBold.copyWith(
                              fontWeight: FontWeights.semiBold,
                              color: LightThemeColors.primary,
                              fontSize: 14,
                            ),
                          ),
                          5.pw,
                          if (product.getOriginalPrice() != null)
                            Text(
                              "₺${widget.cartproduct!.getOriginalPrice()}",
                              style: TextStyles.font14BlackBold.copyWith(
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeights.regular,
                                color: LightThemeColors.grey,
                                fontSize: 14,
                              ),
                            ),
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
                            "+${product.points ?? LocalizationHelper.tr.unspecified_phrase} points",
                            style: TextStyles.font14BlackBold.copyWith(
                              // decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeights.medium,
                              color: LightThemeColors.green,
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
          10.pw,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: LightThemeColors.primary,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: LightThemeColors.cardBackground,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.remove,
                      color: LightThemeColors.black, size: 16),
                ).onTap(
                  () {
                    if (quan == 1) {
                      widget.delete?.call();
                    }
                    if (quan > 1) {
                      quan--;
                      widget.decrease?.call(quan);
                      setState(() {});
                    }
                  },
                ),
                12.pw,
                Text(
                  "$quan",
                  style: TextStyles.font12BlackBold.copyWith(
                    color: LightThemeColors.white,
                  ),
                ),
                12.pw,
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: LightThemeColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add,
                      color: LightThemeColors.primary, size: 16),
                ).onTap(
                  () {
                    {
                      quan++;
                      widget.add?.call(quan);
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
          // 46.pw,
        ],
      ),
    );
    // .onTap(
    //   () {
    //     if (widget.withButtom == false) {
    //       Navigator.pop(
    //         context,
    //         widget.product?..choosenNumber = quan.toString(),
    //       );
    //     } else {
    //       Navigator.pushNamed(
    //         context,
    //         Routes.ProductdetailsScreen,
    //         arguments: ProductDetailsargs(
    //             id: widget.product?.id ?? LocalizationHelper.tr.unspecified_phrase, branchId: widget.branchId ?? LocalizationHelper.tr.unspecified_phrase),
    //       );
    //     }
    //   },
    // );
  }
}
