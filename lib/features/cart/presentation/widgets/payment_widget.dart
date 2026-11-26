import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/addresses/domain/model/addresses_model/datum.dart';
import 'package:getincoffee/features/cart/cubit/cart_states.dart';
import 'package:getincoffee/features/cart/cubit/payment_cubit.dart';
import 'package:getincoffee/features/cart/presentation/widgets/bottomsheets.dart';
import 'package:getincoffee/features/paymentmethod/domain/request/paymentmethod_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

//// location widget
class LocationWidget extends StatelessWidget {
  const LocationWidget({
    super.key,
    this.withTitle = true,
    this.addressModel,
    this.ontap,
    this.hasError = false,
    this.errorText,
  });
  final bool withTitle;
  final AddresseData? addressModel;
  final VoidCallback? ontap;
  final bool hasError;
  final String? errorText;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (withTitle == true)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocalizationHelper.tr.location,
                style: TextStyles.font16BlackSemiBold.copyWith(
                  color: LightThemeColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeights.regular,
                ),
              ),
              Row(
                children: [
                  Text(
                    LocalizationHelper.tr.change,
                    style: TextStyles.font14BlackMedium.copyWith(
                      fontWeight: FontWeights.regular,
                      color: LightThemeColors.grey,
                    ),
                  ),
                  4.pw,
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                  )
                ],
              ).onTap(
                ontap,
              ),
            ],
          ),
        const SizedBox(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: LightThemeColors.orange,
            borderRadius: BorderRadius.circular(
              20,
            ),
            border: hasError
                ? Border.all(
                    color: LightThemeColors.error,
                    width: 1.0,
                  )
                : null,
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: LightThemeColors.white,
                  borderRadius: BorderRadius.circular(
                    24,
                  ),
                ),
                child: Container(
                  width: 95,
                  height: 95,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    addressModel?.nameAddress ??
                        LocalizationHelper.tr.pick_location,
                    style: TextStyles.font14BlackBold.copyWith(
                      color: LightThemeColors.primary,
                      fontWeight: FontWeights.semiBold,
                    ),
                  ),
                  5.ph,
                  Text(
                    addressModel?.addressDescription ??
                        LocalizationHelper.tr.add_location,
                    style: TextStyles.font12BlackLight.copyWith(
                      color: LightThemeColors.grey,
                      fontWeight: FontWeights.regular,
                    ),
                  ),
                ],
              )
            ],
          ),
        ).onTap(
          ontap,
        ),
        if (hasError && errorText != null) ...[
          5.ph,
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                errorText!,
                style: TextStyles.font12BlackLight.copyWith(
                  color: LightThemeColors.error,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

//// payment method widget
class PaymentMethodWidget extends StatelessWidget {
  const PaymentMethodWidget({
    super.key,
    this.withTitle = true,
    this.endwidget,
    this.ontap,
    this.onChoose,
    this.model,
  });
  final bool withTitle;
  final Widget? endwidget;
  final VoidCallback? ontap;
  final VoidCallback? onChoose;
  final PaymentmethodRequest? model;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (withTitle == true)
          Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(
              LocalizationHelper.tr.payment_method_type,
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
            color: const Color(0xFFFAFAFA),

            //  color: LightThemeColors.cardBackground,
            borderRadius: BorderRadius.circular(
              40,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: LightThemeColors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 8),
                              blurRadius: 30,
                              color: LightThemeColors.white),
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          model?.displayBrand?.toLowerCase() == 'visa'
                              ? SvgAssets.visa // Placeholder for Visa
                              : model?.displayBrand?.toLowerCase() == 'cash'
                                  ? SvgAssets.cash
                                  : SvgAssets.masterCard,
                        ),
                      ),
                    ),
                    10.pw,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model?.displayBrand ??
                                model?.brand ??
                                'Master Card',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.font14BlackBold.copyWith(
                              color: LightThemeColors.primary,
                              fontWeight: FontWeights.semiBold,
                            ),
                          ),
                          5.ph,
                          Text(
                            model?.cardNumber ?? "**** 4869",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.font12BlackLight.copyWith(
                              color: LightThemeColors.grey,
                              fontWeight: FontWeights.regular,
                            ),
                          ),
                          5.ph,
                          if (model?.expireDate != null)
                            Text(
                              model?.expireDate ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.font12BlackLight.copyWith(
                                color: LightThemeColors.grey,
                                fontWeight: FontWeights.regular,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              8.pw,
              Center(
                child: Container(
                  width: 58,
                  height: 58,
                  padding: const EdgeInsets.all(15),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Center(
                    child: endwidget ??
                        SvgPicture.asset(
                          SvgAssets.editIcon,
                        ),
                  ),
                ),
              ).onTap(ontap),
            ],
          ),
        ),
      ],
    ).onTap(
      onChoose,
    );
  }
}

//// payment summary widget
class PaymentSUmmaryWidget extends StatelessWidget {
  const PaymentSUmmaryWidget({super.key, this.showDelivery = true});
  final bool showDelivery;

  @override
  Widget build(BuildContext context) {
    var cubit = PaymentCubit.get(context);
    return BlocBuilder<PaymentCubit, CartStates>(
      builder: (context, state) {
        print(state);
        print(state);
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
                    "₺${cubit.summaryModel?.subtotal ?? cubit.cartModel.subTotal ?? ''}",
                    style: TextStyles.font16BlackRegular,
                  ),
                ],
              ),
              if (showDelivery) ...[
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
                      "₺${cubit.summaryModel?.deliveryCharge ?? cubit.cartModel.deliveryCharge ?? ''}",
                      style: TextStyles.font16BlackRegular,
                    ),
                  ],
                ),
              ],
              if (cubit.summaryModel?.discount != null) ...[
                15.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocalizationHelper.tr.discount,
                      style: TextStyles.font16BlackRegular.copyWith(
                        color: LightThemeColors.lightgrey,
                      ),
                    ),
                    Text(
                      "₺${cubit.summaryModel?.discount ?? ''}",
                      style: TextStyles.font16BlackRegular,
                    ),
                  ],
                ),
              ],
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
                    "₺${cubit.summaryModel?.tax ?? cubit.cartModel.tax ?? ''}",
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
                    LocalizationHelper.tr.total,
                    style: TextStyles.font16BlackRegular,
                  ),
                  Text(
                    "₺${(cubit.summaryModel?.total ?? 0).toStringAsFixed(2)}",
                    style: TextStyles.font16BlackRegular,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

////offer delivery widget

class OfferDileveryWidget extends StatelessWidget {
  const OfferDileveryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, CartStates>(
      builder: (context, state) {
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
                PaymentCubit.get(context).summaryModel?.descriptionDelivery ??
                    '',
                // LocalizationHelper.tr.is_free_delivery_eligible("100"),
                style: TextStyles.font12BlackBold.copyWith(
                  color: LightThemeColors.white,
                  fontWeight: FontWeights.regular,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

/// copon widget
class PaymentCoponWidget extends StatelessWidget {
  const PaymentCoponWidget({super.key, this.cubit});
  final PaymentCubit? cubit;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: const EdgeInsets.only(
        top: 18,
        bottom: 18, //+ MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
      ),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: LightThemeColors.cardBackground,
        borderRadius: BorderRadius.circular(
          40,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
        close: (val) async {
          if (val != null) {
            cubit?.copon = val;
          }
          return true;
        },
        context,
        child: BlocProvider<PaymentCubit>.value(
          value: cubit!,
          child: CoponBottomSheet(
            type: "delivery",
          ),
        ),
      );
    });
  }
}

class SelectPaymentWidget extends StatelessWidget {
  const SelectPaymentWidget({
    super.key,
    this.ontap,
    this.hasError = false,
    this.errorText,
  });
  final VoidCallback? ontap;
  final bool hasError;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(
              40,
            ),
            border: hasError
                ? Border.all(
                    color: LightThemeColors.error,
                    width: 1.0,
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: LightThemeColors.white,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  SvgAssets.masterCard, // Or a generic card icon
                  width: 24,
                  height: 24,
                ),
              ),
              8.pw,
              Text(
                LocalizationHelper.tr.payment_method_type,
                style: TextStyles.font16BlackRegular.copyWith(
                  color: LightThemeColors.primary,
                  fontWeight: FontWeights.semiBold,
                ),
              ),
            ],
          ),
        ).onTap(ontap),
        if (hasError && errorText != null) ...[
          5.ph,
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                errorText!,
                style: TextStyles.font12BlackLight.copyWith(
                  color: LightThemeColors.error,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
