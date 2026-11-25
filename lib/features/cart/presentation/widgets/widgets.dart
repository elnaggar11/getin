import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/cart/cubit/cart_cubit.dart';
import 'package:getincoffee/features/cart/cubit/cart_states.dart';
import 'package:getincoffee/features/cart/presentation/widgets/delete_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'cart_ProductWidget.dart';

class ItemsWidget extends StatelessWidget {
  const ItemsWidget({
    super.key,
    this.cubit,
  });

  final CartCubit? cubit;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cubit?.cartModel.items?.length ?? 0,
      padding: const EdgeInsets.only(bottom: 10),
      itemBuilder: (context, i) {
        final item = cubit!.cartModel.items![i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CartProductwidget(
            quan: cubit?.cartModel.items![i].quantity,
            updatequa: (id, qua) => cubit?.updateQuantity(
              id: id,
              quantity: qua.toString(),
            ),
            deleteItem: (item) {
              Alerts.bottomSheet(context,
                  child: BlocListener<CartCubit, CartStates>(
                    bloc: cubit,
                    listener: (context, state) {
                      if (state is DeleteItemSuccess) {
                        //  Navigator.pop(context);
                      }
                    },
                    child: ActionBottomSheet(
                      onConfirm: () {
                        cubit?.deleteItem(
                            id: cubit?.cartModel.items![i].id.toString());
                      },
                    ),
                  ));
              return null;
            },
            item: cubit?.cartModel.items![i].product,
            id: cubit?.cartModel.items![i].id,
            withCounter: true,
          ),
        );
      },
    );
  }
}

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({
    super.key,
    this.subtotal,
    this.total,
    this.tax,
    this.deliveryCharge,
    this.discount,
  });
  final String? subtotal;
  final String? total;
  final String? tax;
  final String? deliveryCharge;
  final String? discount;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: LightThemeColors.cardBackground,
        borderRadius: BorderRadius.circular(
          25,
        ),
      ),
      child: Column(
        children: [
          SummaryRow(
            label: LocalizationHelper.tr.item_total,
            value: "₺$subtotal",
          ),
          15.ph,
          SummaryRow(
            label: LocalizationHelper.tr.delivery_charge,
            value: "₺$deliveryCharge",
          ),
          if (tax != null && tax != "") ...[
            15.ph,
            SummaryRow(
              label: LocalizationHelper.tr.tax,
              value: "₺$tax",
            ),
          ],
          if (discount != null && discount != "") ...[
            15.ph,
            SummaryRow(
              label: LocalizationHelper.tr.discount,
              value: "-₺$discount",
            ),
          ],
          15.ph,
          const Divider(
            height: 0,
            thickness: 1,
            color: LightThemeColors.dividercolor,
          ),
          15.ph,
          SummaryRow(
            label: LocalizationHelper.tr.total,
            value: "₺$total",
            type: SummaryRowType.total,
          ),
        ],
      ),
    );
  }
}

enum SummaryRowType {
  regular,
  total,
}

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.type = SummaryRowType.regular,
  });

  final String label;
  final String value;
  final SummaryRowType type;

  bool get _isTotal => type == SummaryRowType.total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: _isTotal
              ? TextStyles.font16BlackRegular
              : TextStyles.font16BlackRegular.copyWith(
                  color: LightThemeColors.lightgrey,
                ),
        ),
        Text(
          value,
          style: _isTotal
              ? TextStyles.font16BlackRegular
              : TextStyles.font16BlackRegular,
        ),
      ],
    );
  }
}

class DiscountWidget extends StatelessWidget {
  const DiscountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = CartCubit.get(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 9,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: LinearGradient(
          colors: LightThemeColors.gradientPrimary,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                SvgAssets.discountIcon,
              ),
              7.pw,
              SizedBox(
                width: 300,
                child: Text(
                  cubit.cartModel.descriptionText ??
                      LocalizationHelper.tr.selected_items_discount_info,
                  style: TextStyles.font12BlackBold.copyWith(
                    color: LightThemeColors.white,
                    // fontSize: 10,
                    fontWeight: FontWeights.regular,
                  ),
                ),
              ),
            ],
          ),
          // 11.pw,
          const Icon(
            Icons.arrow_forward_ios,
            size: 10,
            color: LightThemeColors.white,
          )
        ],
      ),
    );
  }
}

class LocationTabbar extends StatelessWidget {
  const LocationTabbar(
      {super.key, this.tabController, this.canDelivery = true});
  final TabController? tabController;
  final bool? canDelivery;
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 194,
      padding: const EdgeInsets.all(
        10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          40,
        ),
        color: LightThemeColors.orange,
      ),
      child: TabBar(
        dividerHeight: 0,
        controller: tabController,
        indicator: BoxDecoration(
          border: Border.all(
            width: 1,
            color: LightThemeColors.primary,
          ),
          color: LightThemeColors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: LightThemeColors.primary,
        unselectedLabelColor: Colors.black,
        labelStyle: const TextStyle(
          color: LightThemeColors.primary,
          fontWeight: FontWeights.medium,
          fontSize: 12,
        ),
        tabs: [
          if (canDelivery ?? false)
            Tab(text: LocalizationHelper.tr.delivery_option_place),
          Tab(text: LocalizationHelper.tr.pickup_option_branch),
        ],
      ),
    );
  }
}
