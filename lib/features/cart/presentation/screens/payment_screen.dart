import 'dart:developer';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/general/cubit/general_cubit.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/utils/utils.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/cart/cubit/cart_states.dart';
import 'package:getincoffee/features/cart/cubit/payment_cubit.dart';
import 'package:getincoffee/features/cart/presentation/widgets/payment_widget.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:getincoffee/shared/widgets/loadinganderror.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getincoffee/core/services/stripe_service.dart';

import '../../../../core/resources/font_manager.dart';
import '../../../../core/theme/light_theme.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, this.type, this.typeBack});
  final String? type;
  final String? typeBack;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool hasAttemptedCheckout = false;
  String? _selectedPayWith;
  Future<void> _handleStripePayment({
    required BuildContext context,
    required String clientSecret,
    required String? stripeCustomerId,
    required String? ephemeralKey,
    required String orderId,
  }) async {
    try {
      await StripeService.presentPaymentSheet(
          clientSecret: clientSecret,
          ephemeralKey: ephemeralKey ?? '',
          stripeCustomerId: stripeCustomerId ?? '');

      if (context.mounted) {
        GeneralCubit.get(context).updateCartCount(0);
        Navigator.pushNamed(
          context,
          Routes.QrScreen,
          arguments: orderId,
        );
      }
    } on StripeException catch (e, t) {
      log(t.toString(), name: 'stripe');
      log(e.toString(), name: 'stripe');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.error.localizedMessage ?? 'Payment cancelled',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentCubit()..summarydata(type: widget.type),
      child: BlocConsumer<PaymentCubit, CartStates>(
        listener: (context, state) async {
          final cubit = PaymentCubit.get(context);
          if (state is CartSuccessState) {
            cubit.cartModel = state.cartModel;
          }
          if (state is StripeIdSuccess) {
            try {
              await _handleStripePayment(
                  context: context,
                  clientSecret: state.data.clientSecret ?? '',
                  stripeCustomerId: state.data.stripeCustomerId,
                  orderId: state.data.orderId ?? '',
                  ephemeralKey: state.data.ephemeralKey);
            } catch (e) {
              log(e.toString(), name: 'stripe');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      e.toString(),
                    ),
                  ),
                );
              }
            }
          }
          if (state is CheckoutSuccess) {
            GeneralCubit.get(context).updateCartCount(0);
            Navigator.pushNamed(
              context,
              Routes.QrScreen,
              arguments: state.id ?? '',
            );
          }
        },
        builder: (context, state) {
          final cubit = PaymentCubit.get(context);
          final paymentOptions = Utils.userModel.allowedPaymentMethods ??
              const ['money', 'points'];
          final selectedPayWith = paymentOptions.contains(_selectedPayWith)
              ? _selectedPayWith!
              : paymentOptions.contains('money')
                  ? 'money'
                  : paymentOptions.contains('cash')
                      ? 'cash'
                      : 'points';
          final canPayWithPoints = paymentOptions.contains('points') &&
              (cubit.summaryModel?.allowPointsPayment ?? false);
          return LoadingAndError(
            isLoading: state is CartLoadingState || state is CheckoutLoading,
            isError: state is CartFailedState,
            child: Scaffold(
              backgroundColor: LightThemeColors.primary,
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocalizationHelper.tr.payment_method,
                      style: TextStyles.font20WhiteSemiBold.copyWith(
                        color: LightThemeColors.white,
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Text(
                    //       "Clear all",
                    //       style: TextStyles.font14BlackMedium.copyWith(
                    //         color: LightThemeColors.error,
                    //         fontWeight: FontWeights.regular,
                    //       ),
                    //     ),
                    //     7.pw,
                    //     SvgPicture.asset(
                    //      SvgAssets.delete,
                    //     ),
                    //   ],
                    // )
                  ],
                ),
                toolbarHeight: 88,
                backgroundColor: LightThemeColors.primary,
                automaticallyImplyLeading: false,
                leading: const Icon(
                  Icons.arrow_back_sharp,
                  color: LightThemeColors.white,
                ).onTap(
                  () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: LightThemeColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      40,
                    ),
                    topRight: Radius.circular(
                      40,
                    ),
                  ),
                ),
                padding: const EdgeInsets.only(
                  top: 25,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (widget.typeBack != "pick_up")
                              LocationWidget(
                                addressModel: cubit.addresseData,
                                ontap: () => cubit.chooseAddress(context),
                                hasError: hasAttemptedCheckout &&
                                    cubit.addresseData.id == null,
                                errorText: LocalizationHelper
                                    .tr.select_location_first_message,
                              ),
                            15.ph,
                            if (paymentOptions.contains('cash') &&
                                paymentOptions.contains('money'))
                              RadioListTile<String>(
                                value: 'money',
                                groupValue: selectedPayWith,
                                activeColor: LightThemeColors.primary,
                                title: Text(LocalizationHelper.tr.card),
                                onChanged: (value) =>
                                    setState(() => _selectedPayWith = value),
                              ),
                            if (paymentOptions.contains('cash'))
                              RadioListTile<String>(
                                value: 'cash',
                                groupValue: selectedPayWith,
                                activeColor: LightThemeColors.primary,
                                title: Text(LocalizationHelper.tr.cash),
                                onChanged: (value) =>
                                    setState(() => _selectedPayWith = value),
                              ),
                            if (paymentOptions.contains('money') &&
                                selectedPayWith == 'money')
                              cubit.paymentmethodRequest != null
                                  ? PaymentMethodWidget(
                                      model: cubit.paymentmethodRequest,
                                      ontap: () => cubit.chooseCard(context),
                                    )
                                  : SelectPaymentWidget(
                                      ontap: () => cubit.chooseCard(context),
                                      hasError: hasAttemptedCheckout,
                                      errorText: LocalizationHelper
                                          .tr.select_payment_method,
                                    ),

                            // Container(),
                            15.ph,
                            PaymentSUmmaryWidget(
                              showDelivery: widget.typeBack != "pick_up",
                            ),
                            10.ph,
                            if (widget.typeBack != "pick_up")
                              const OfferDileveryWidget(),
                            15.ph,

                            35.ph,
                            // 150.ph,
                          ],
                        ),
                      ),
                    ),
                    PaymentCoponWidget(
                      cubit: cubit,
                    ),
                    15.ph,
                    Row(children: [
                      if ((selectedPayWith == 'money' ||
                              selectedPayWith == 'cash') &&
                          paymentOptions.contains(selectedPayWith))
                        Expanded(
                          flex: canPayWithPoints ? 2 : 1,
                          child: ButtonWidget(
                            onTap: () {
                              final needsAddress = widget.typeBack != "pick_up";
                              final needsCard = selectedPayWith == 'money';
                              final isValid = (!needsAddress ||
                                      cubit.addresseData.id != null) &&
                                  (!needsCard ||
                                      cubit.paymentmethodRequest != null);
                              if (!isValid) {
                                setState(() => hasAttemptedCheckout = true);
                                return;
                              }
                              cubit.checkout(
                                type: widget.typeBack,
                                payWith: selectedPayWith,
                              );
                            },
                            witharrows: false,
                            title: LocalizationHelper.tr.place_order_now,
                          ),
                        ),
                      if (canPayWithPoints) ...[
                        10.pw,
                        Expanded(
                          flex: 1,
                          child: ButtonWidget(
                            buttonColor: LightThemeColors.black,
                            onTap: () {
                              bool isValid = true;
                              if (widget.typeBack != "pick_up" &&
                                  cubit.addresseData.id == null) {
                                isValid = false;
                              }
                              if (!isValid) {
                                setState(() => hasAttemptedCheckout = true);
                                return;
                              }
                              cubit.checkout(
                                type: widget.typeBack,
                                payWith: 'points',
                              );
                            },
                            witharrows: false,
                            title:
                                "${LocalizationHelper.tr.pay_with_points} ${(cubit.summaryModel?.totalPriceWithPoints != null) ? "(${cubit.summaryModel?.totalPriceWithPoints})" : ""}",
                          ),
                        ),
                      ],
                    ]),
                    30.ph,
                  ],
                ),
              ),
              // bottomNavigationBar: 150.ph,
            ),
          );
        },
      ),
    );
  }
}
