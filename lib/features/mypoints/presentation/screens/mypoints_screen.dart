import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/services/stripe_service.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/core/utils/utils.dart';
import 'package:getincoffee/features/cart/domain/request/payment_data.dart';
import 'package:getincoffee/features/cart/presentation/widgets/bottomsheets.dart';
import 'package:getincoffee/features/mypoints/domain/model/my_star_model/order.dart';
import 'package:getincoffee/features/paymentmethod/domain/request/paymentmethod_request.dart';
import 'package:getincoffee/shared/back_widget.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:getincoffee/shared/widgets/edit_text_widget.dart';
import 'package:getincoffee/shared/widgets/loadinganderror.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/font_manager.dart'
    show FontWeights, TextStyles;
import '../../cubit/mypoints_cubit.dart';
import '../../cubit/mypoints_states.dart';

class MypointsScreen extends StatefulWidget {
  const MypointsScreen({super.key});

  @override
  State<MypointsScreen> createState() => _MypointsScreenState();
}

class _MypointsScreenState extends State<MypointsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MypointsCubit()..mypoints(),
      child: BlocConsumer<MypointsCubit, MypointsStates>(
        listener: (context, state) {
          if (state is GetPointsSuccess) {
            MypointsCubit.get(context).allpoints = state.pointModel;
          }
        },
        builder: (context, state) {
          final cubit = MypointsCubit.get(context);
          return Scaffold(
            backgroundColor: LightThemeColors.white,
            appBar: AppBar(
              leading: const BackWidget(),
              centerTitle: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(
                      LocalizationHelper.tr.my_rewards_points,
                      style: const TextStyle(
                        color: LightThemeColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ButtonWidget(
                      fontSize: 12,
                      height: 34,
                      onTap: () {
                        Alerts.bottomSheet(
                          context,
                          child: BuyPointsSheetWidget(cubit: cubit),
                        );
                      },
                      title: LocalizationHelper.tr.buy_points,
                      buttonColor: LightThemeColors.black,
                    ),
                  )
                ],
              ),
            ),
            body: LoadingAndError(
              isError: state is GetPointsFailed,
              isLoading: state is GetPointsLoading,
              function: () => cubit.mypoints(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      12.ph,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 25,
                        ),
                        decoration: BoxDecoration(
                          color: LightThemeColors.cardBackground,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  SvgAssets.starsMoney,
                                ),
                                16.ph,
                                Text(
                                  LocalizationHelper.tr.total_points,
                                  style: TextStyles.font16BlackRegular.copyWith(
                                    fontWeight: FontWeights.regular,
                                    color: LightThemeColors.grey,
                                    fontSize: 18,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              cubit.allpoints?.points.toString() ?? "",
                              style: TextStyles.font16BlackRegular.copyWith(
                                fontWeight: FontWeights.bold,
                                color: LightThemeColors.grey,
                                fontSize: 32,
                              ),
                            )
                          ],
                        ),
                      ),
                      10.ph,
                      ButtonWidget(
                        onTap: () {
                          Navigator.pop(context, true);
                        },
                        buttonColor: LightThemeColors.black,
                        title: LocalizationHelper.tr.buy_product_now,
                      ),
                      15.ph,
                      Text(
                        LocalizationHelper.tr.history_points,
                        style: TextStyles.font14BlackBold.copyWith(
                          color: LightThemeColors.primary,
                          fontWeight: FontWeights.semiBold,
                        ),
                      ),
                      15.ph,
                      Container(
                        padding: const EdgeInsets.all(
                          16,
                        ),
                        decoration: BoxDecoration(
                          color: LightThemeColors.cardBackground,
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return DealItem(
                                points: cubit.allpoints?.starpoints?[index].item
                                    ?.starsTotal
                                    .toString(),
                                name: "points",
                                order: cubit.allpoints?.starpoints?[index]);
                          },
                          separatorBuilder: (context, index) {
                            return 10.ph;
                          },
                          itemCount: cubit.allpoints?.starpoints?.length ?? 0,
                        ),
                        // Column(
                        //   children: List.generate(
                        //     10,
                        //     (i) => const DealItem(),
                        //   ),
                        // ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DealItem extends StatelessWidget {
  const DealItem({
    super.key,
    this.points,
    this.order,
    this.name = "points",
  });
  final String? points;
  final StarOrder? order;
  final String? name;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: LightThemeColors.primary,
                  borderRadius: BorderRadius.circular(
                    24,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    SvgAssets.points,
                  ),
                ),
              ),
              10.pw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order?.productName ??
                        LocalizationHelper.tr.italian_coffee_cup_item,
                    style: TextStyles.font14BlackBold.copyWith(
                        color: LightThemeColors.grey,
                        fontWeight: FontWeights.regular,
                        fontSize: 14),
                  ),
                  5.ph,
                  Text(
                    order?.createdAt ?? "26/05/2025",
                    style: TextStyles.font12BlackBold.copyWith(
                        color: LightThemeColors.lightgrey,
                        fontWeight: FontWeights.regular,
                        fontSize: 14),
                  ),
                ],
              )
            ],
          ),
          const Spacer(),
          Text(
            "+${order?.item?.starsTotal ?? ""} $name",
            style: TextStyles.font12BlackBold.copyWith(
              color: LightThemeColors.green,
              fontWeight: FontWeights.semiBold,
            ),
          )
        ],
      ),
    );
  }
}

class BuyPointsSheetWidget extends StatefulWidget {
  const BuyPointsSheetWidget({
    super.key,
    this.withTitle = true,
    required this.cubit,
  });

  final bool withTitle;
  final MypointsCubit cubit;

  @override
  State<BuyPointsSheetWidget> createState() => _BuyPointsSheetWidgetState();
}

class _BuyPointsSheetWidgetState extends State<BuyPointsSheetWidget> {
  final TextEditingController _amountController = TextEditingController();
  PaymentmethodRequest? selectedPaymentMethod;

  Future<void> _choosePaymentMethod(BuildContext context) async {
    final result = await Alerts.bottomSheet(
      context,
      child: const PaymentshetBody(),
    );
    print(result);
    print("result");
    if (result != null && result is PaymentmethodRequest) {
      setState(() {
        selectedPaymentMethod = result;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleStripePayment(PaymentData data) async {
    try {
      await StripeService.presentPaymentSheet(
        clientSecret: data.clientSecret ?? '',
        ephemeralKey: data.ephemeralKey ?? '',
        stripeCustomerId: data.stripeCustomerId ?? '',
      );

      if (mounted) {
        widget.cubit.mypoints();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocalizationHelper.tr.confirm_now,
            ),
          ),
        );
      }
    } on StripeException catch (e) {
      log(e.error.localizedMessage ?? 'Payment cancelled', name: "eeee");
      if (mounted) {
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
    return BlocListener<MypointsCubit, MypointsStates>(
      bloc: widget.cubit,
      listener: (context, state) {
        if (state is BuyPointsSuccess) {
          _handleStripePayment(state.data);
        }
        if (state is BuyPointsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to initiate payment'),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            if (widget.withTitle == true)
              Align(
                alignment: Alignment.topLeft,
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
            InkWell(
              onTap: () => _choosePaymentMethod(context),
              child: Container(
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
                              selectedPaymentMethod?.brand ??
                                  LocalizationHelper.tr.select_payment_method,
                              style: TextStyles.font14BlackBold.copyWith(
                                color: LightThemeColors.primary,
                                fontWeight: FontWeights.semiBold,
                              ),
                            ),
                            5.ph,
                            if (selectedPaymentMethod != null)
                              Text(
                                "**** ${selectedPaymentMethod?.last4 ?? ''}",
                                style: TextStyles.font12BlackLight.copyWith(
                                  color: LightThemeColors.grey,
                                  fontWeight: FontWeights.regular,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    if (selectedPaymentMethod != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 30,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            24,
                          ),
                        ),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: LightThemeColors.primary,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check,
                              size: 15,
                              color: LightThemeColors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            30.ph,
            TextFormFieldWidget(
              hintText: LocalizationHelper.tr.points_entry_prompt,
              fixedlabel: LocalizationHelper.tr.point_count,
              controller: _amountController,
              type: TextInputType.number,
              validator: Utils.valid.defaultValidation,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            30.ph,
            BlocBuilder<MypointsCubit, MypointsStates>(
              bloc: widget.cubit,
              builder: (context, state) {
                return ButtonWidget(
                  title: state is BuyPointsLoading
                      ? '...'
                      : LocalizationHelper.tr.confirm_now,
                  witharrows: state is! BuyPointsLoading,
                  onTap: state is BuyPointsLoading
                      ? null
                      : () {
                          final amount = _amountController.text.trim();
                          if (selectedPaymentMethod == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(LocalizationHelper
                                    .tr.select_payment_method),
                              ),
                            );
                            return;
                          }
                          if (amount.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter an amount'),
                              ),
                            );
                            return;
                          }
                          widget.cubit.buyPoints(
                            amount: amount,
                            paymentMethodId: selectedPaymentMethod?.id ?? '',
                          );
                        },
                );
              },
            ),
            41.ph,
          ],
        ),
      ),
    );
  }
}
