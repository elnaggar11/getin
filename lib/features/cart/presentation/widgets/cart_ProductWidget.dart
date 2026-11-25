import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'dart:async';

import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/shared/widgets/default_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/font_manager.dart';
import '../../../../core/theme/light_theme.dart';

class CartProductwidget extends StatefulWidget {
  const CartProductwidget({
    super.key,
    this.withCounter = false,
    this.item,
    this.updatequa,
    this.id,
    this.branchId,
    this.quan,
    this.deleteItem,
    this.onAddToCart,
  });
  final bool withCounter;
  final int? branchId;
  final String? id;
  final String? quan;
  final Future<void>? Function(ProductModel)? deleteItem;
  final VoidCallback? onAddToCart;

  final ProductModel? item;
  final Future<bool>? Function(String? id, int? quantity)? updatequa;
  @override
  State<CartProductwidget> createState() => _CartProductwidgetState();
}

class _CartProductwidgetState extends State<CartProductwidget> {
  bool withCounter = false;
  int? quantitiy;
  int? shownQua;
  Timer? _timer;
  @override
  void initState() {
    withCounter = widget.withCounter;
    quantitiy = int.parse(widget.quan ?? "0");
    shownQua = int.parse(widget.quan ?? "0");

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 3,
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
          Row(
            children: [
              10.pw,
              Container(
                width: 95,
                height: 95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    26,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    24,
                  ),
                  child: DefaultImageWidget(
                    widget.item?.images?.first ??
                        LocalizationHelper.tr.unspecified_phrase,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              10.pw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item?.name ??
                        LocalizationHelper.tr.unspecified_phrase,
                    style: TextStyles.font12BlackBold.copyWith(
                      color: LightThemeColors.primary,
                      fontWeight: FontWeights.extraBold,
                    ),
                  ),
                  10.ph,
                  // Text(
                  //   "Traditional Turkish coffee, smooth, rich...",
                  //   style: TextStyles.font12BlackBold.copyWith(
                  //     fontWeight: FontWeights.regular,
                  //     color: LightThemeColors.lightgrey,
                  //     fontSize: 8,
                  //   ),
                  // ),
                  // 3.ph,
                  Row(
                    children: [
                      SvgPicture.asset(
                        SvgAssets.Star,
                      ),
                      2.pw,
                      Text(
                        widget.item?.rating_avg ??
                            LocalizationHelper.tr.unspecified_phrase,
                        style: TextStyles.font12BlackBold.copyWith(
                          fontWeight: FontWeights.regular,
                        ),
                      ),
                      5.pw,
                      Text(
                        "(${widget.item?.revies_count ?? LocalizationHelper.tr.unspecified_phrase}+)",
                        style: TextStyles.font12BlackBold.copyWith(
                          fontWeight: FontWeights.regular,
                          color: LightThemeColors.grey,
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
                      Text(
                        widget.item?.delivery_time ??
                            LocalizationHelper.tr.unspecified_phrase,
                        style: TextStyles.font12BlackBold.copyWith(
                          fontWeight: FontWeights.regular,
                        ),
                      ),
                      6.pw,
                    ],
                  ),
                  10.ph,
                  Row(
                    children: [
                      Text(
                        "₺${widget.item?.getPrice() ?? LocalizationHelper.tr.unspecified_phrase}",
                        style: TextStyles.font12BlackBold.copyWith(
                          fontWeight: FontWeights.semiBold,
                          color: LightThemeColors.primary,
                        ),
                      ),
                      5.pw,
                      if (widget.item?.getOriginalPrice() != null)
                        Text(
                          "₺${widget.item?.getOriginalPrice() ?? LocalizationHelper.tr.unspecified_phrase}",
                          style: TextStyles.font12BlackBold.copyWith(
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeights.regular,
                            color: LightThemeColors.grey,
                          ),
                        ),
                      5.pw,
                      // Container(
                      //   width: 5,
                      //   height: 5,
                      //   decoration: const BoxDecoration(
                      //     color: LightThemeColors.lightgrey,
                      //     shape: BoxShape.circle,
                      //   ),
                      // ),
                      // 5.pw,
                      // Text(
                      //   "+12 points",
                      //   style: TextStyles.font12BlackBold.copyWith(
                      //     // decoration: TextDecoration.lineThrough,
                      //     fontWeight: FontWeights.medium,
                      //     color: LightThemeColors.green,
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
            ],
          ),
          // 46.pw,
          withCounter == true
              ? Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Column(
                        spacing: 15,
                        children: [
                          const Icon(Icons.minimize).onTap(() async {
                            if (quantitiy == 1) {
                              widget.deleteItem?.call(widget.item!);
                              return;
                            }
                            if (quantitiy != null) {
                              // Prevent reducing to zero or negative
                              if (quantitiy! > 0) {
                                final oldValue = quantitiy;

                                // Reduce immediately in UI
                                quantitiy = quantitiy! - 1;
                                setState(() {});

                                // Update backend
                                final success = await widget.updatequa
                                        ?.call(widget.id, quantitiy) ??
                                    false;

                                if (success) {
                                  shownQua = quantitiy;
                                } else {
                                  // If failed, revert
                                  quantitiy = oldValue;
                                  setState(() {});
                                }
                              }
                            }
                          }),
                          Text(
                            "${shownQua ?? 0}",
                            style: TextStyles.font14BlackBold.copyWith(
                              color: LightThemeColors.black,
                            ),
                          ),
                          const Icon(Icons.add).onTap(() async {
                            /*                       if (quantitiy! >=
                                (int.parse(widget.item?.remaining_quantity ??
                                        "0") +
                                    1)) {
                              Alerts.snack(
                                  text: "Maximum quantity reached",
                                  state: SnackState.failed);
                            }
 */
                            if (quantitiy != null) {
                              // Update UI immediately
                              quantitiy = quantitiy! + 1;
                              setState(() {});

                              // Call backend
                              final success = await widget.updatequa
                                      ?.call(widget.id, quantitiy) ??
                                  false;

                              if (success) {
                                shownQua = quantitiy;
                              } else {
                                // Revert to old quantity if update failed
                                quantitiy = quantitiy! - 1;
                                setState(() {});
                              }
                            }
                          }),
                        ],
                      ),
                    ),
                    15.pw,
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    if (widget.item?.hasOptions ?? false) {
                      Navigator.pushNamed(
                        context,
                        Routes.ProductdetailsScreen,
                        arguments: ProductDetailsargs(
                          id: widget.item?.id ??
                              LocalizationHelper.tr.unspecified_phrase,
                          branchId: widget.branchId?.toString() ?? "",
                        ),
                      );
                    } else {
                      widget.onAddToCart?.call();
                    }
                  },
                  child: Row(
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
                      ),
                      15.pw,
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
