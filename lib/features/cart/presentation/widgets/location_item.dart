import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/addresses/cubit/addresses_cubit.dart';
import 'package:getincoffee/features/addresses/domain/model/addresses_model/datum.dart';
import 'package:getincoffee/features/addresses/presentation/widgets/update_addreess_sheet_body.dart';
import 'package:getincoffee/features/cart/presentation/widgets/bottomsheets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

//// location widget
class LocationItemWidget extends StatefulWidget {
  const LocationItemWidget({
    super.key,
    this.address,
    this.onEdit,
    this.onDelete,
    this.onchoose,
  });
  final AddresseData? address;
  final Function(AddresseData)? onEdit;
  final Function(int)? onDelete;
  final VoidCallback? onchoose;

  @override
  State<LocationItemWidget> createState() => _LocationItemWidgetState();
}

class _LocationItemWidgetState extends State<LocationItemWidget> {
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            Text(LocalizationHelper.tr.delete_address),
          ],
        ),
        content: Text(
          LocalizationHelper.tr.delete_address_confirmation,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(LocalizationHelper.tr.cancel,
                style: const TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onDelete!(widget.address!.id!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(LocalizationHelper.tr.delete,
                style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onchoose,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: LightThemeColors.orange,
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 30,
                  ),
                  decoration: BoxDecoration(
                    color: LightThemeColors.white,
                    borderRadius: BorderRadius.circular(
                      24,
                    ),
                  ),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 8),
                          blurRadius: 30,
                          color: LightThemeColors.black.withOpacity(
                            .1,
                          ),
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        SvgAssets.cartLocation,
                      ),
                    ),
                  ),
                ),
                10.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: LocalizationHelper.crossAxisAlignment,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.address?.addressTitle ?? "New York, NY",
                              style: TextStyles.font14BlackBold.copyWith(
                                color: LightThemeColors.primary,
                                fontWeight: FontWeights.semiBold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              // color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Alerts.bottomSheet(context,
                                        child: BlocProvider.value(
                                            value: AddressesCubit.get(context),
                                            child: UpdateAddreessSheetBody(
                                              addressModel: widget.address ??
                                                  AddresseData(),
                                            )));
                                  },
                                  icon: const Icon(Icons.edit_rounded),
                                  color: LightThemeColors.primary,
                                  tooltip: LocalizationHelper.tr.edit_address,
                                  style: IconButton.styleFrom(
                                    minimumSize: const Size(40, 40),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 20,
                                  color: Colors.grey[300],
                                ),
                                IconButton(
                                  onPressed: _showDeleteDialog,
                                  icon: const Icon(Icons.delete_rounded),
                                  color: Colors.red[400],
                                  tooltip: LocalizationHelper.tr.delete_address,
                                  style: IconButton.styleFrom(
                                    minimumSize: const Size(40, 40),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      5.ph,
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          widget.address?.addressDescription ??
                              "6391 Elgin St. Celina, Delaware 10299",
                          style: TextStyles.font12BlackLight.copyWith(
                            color: LightThemeColors.grey,
                            fontWeight: FontWeights.regular,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//// payment method widget
class PaymentMethodWidget extends StatelessWidget {
  const PaymentMethodWidget({
    super.key,
    this.withTitle = true,
    this.endwidget,
  });
  final bool withTitle;
  final Widget? endwidget;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        children: [
          if (withTitle == true)
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                LocalizationHelper.tr.payment_method,
                style: TextStyles.font14BlackBold.copyWith(
                  fontSize: 16,
                  color: LightThemeColors.primary,
                  fontWeight: FontWeights.semiBold,
                ),
              ),
            ),
          8.ph,
          Container(
            padding: const EdgeInsets.all(10),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 30,
                      ),
                      decoration: BoxDecoration(
                        color: LightThemeColors.white,
                        borderRadius: BorderRadius.circular(
                          24,
                        ),
                      ),
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 8),
                              blurRadius: 30,
                              color: LightThemeColors.black.withOpacity(
                                .1,
                              ),
                            ),
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            SvgAssets.masterCard,
                          ),
                        ),
                      ),
                    ),
                    10.pw,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocalizationHelper.tr.master_card,
                          style: TextStyles.font14BlackBold.copyWith(
                            color: LightThemeColors.primary,
                            fontWeight: FontWeights.semiBold,
                          ),
                        ),
                        5.ph,
                        Text(
                          "**** 4869",
                          style: TextStyles.font12BlackLight.copyWith(
                            color: LightThemeColors.grey,
                            fontWeight: FontWeights.regular,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  // height: 58,
                  // width: 58,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: LightThemeColors.orange,
                    borderRadius: BorderRadius.circular(
                      24,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: endwidget ??
                            SvgPicture.asset(
                              SvgAssets.editIcon,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ).onTap(() {
        Alerts.bottomSheet(
          context,
          child: const PaymentshetBody(),
        );
      }),
    );
  }
}

//// payment summary widget
class PaymentSUmmaryWidget extends StatelessWidget {
  const PaymentSUmmaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: LightThemeColors.cardBackground,
        borderRadius: BorderRadius.circular(
          25,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocalizationHelper.tr.item_total,
                style: TextStyles.font16BlackRegular.copyWith(
                  color: LightThemeColors.lightgrey,
                ),
              ),
              Text(
                "₺32.97",
                style: TextStyles.font16BlackRegular,
              ),
            ],
          ),
          15.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocalizationHelper.tr.delivery_charge,
                style: TextStyles.font16BlackRegular.copyWith(
                  color: LightThemeColors.lightgrey,
                ),
              ),
              Text(
                "₺32.97",
                style: TextStyles.font16BlackRegular,
              ),
            ],
          ),
          15.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocalizationHelper.tr.tax,
                style: TextStyles.font16BlackRegular.copyWith(
                  color: LightThemeColors.lightgrey,
                ),
              ),
              Text(
                "₺32.97",
                style: TextStyles.font16BlackRegular,
              ),
            ],
          ),
          15.ph,
          const Divider(
            height: 0,
            thickness: 1,
            color: LightThemeColors.dividercolor,
          ),
          15.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocalizationHelper.tr.subtotal,
                style: TextStyles.font16BlackRegular,
              ),
              Text(
                "₺32.97",
                style: TextStyles.font16BlackRegular,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

////offer delivery widget

class OfferDileveryWidget extends StatelessWidget {
  const OfferDileveryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 25,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: LightThemeColors.black,
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                SvgAssets.payDeliverIcon,
              ),
              5.pw,
              Text(
                LocalizationHelper.tr.free_delivery,
                style: TextStyles.font16BlackSemiBold.copyWith(
                  color: LightThemeColors.white,
                ),
              )
            ],
          ),
          8.ph,
          Text(
            LocalizationHelper.tr.free_delivery_condition("100"),
            style: TextStyles.font12BlackBold.copyWith(
              color: LightThemeColors.white,
              fontWeight: FontWeights.regular,
            ),
          )
        ],
      ),
    );
  }
}

/// copon widget
class PaymentCoponWidget extends StatelessWidget {
  const PaymentCoponWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 116,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: LightThemeColors.orange,
        borderRadius: BorderRadius.circular(
          40,
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            SvgAssets.couponIcon,
          ),
          8.pw,
          Text(
            LocalizationHelper.tr.add_coupon,
            style: TextStyles.font16BlackRegular.copyWith(
              color: LightThemeColors.grey,
            ),
          ),
        ],
      ),
    ).onTap(() {
      Alerts.bottomSheet(
        context,
        child: CoponBottomSheet(
          type: "",
        ),
      );
    });
  }
}
