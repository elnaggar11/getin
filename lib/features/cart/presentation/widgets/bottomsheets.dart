import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/core/utils/utils.dart';
import 'package:getincoffee/features/addresses/cubit/addresses_cubit.dart';
import 'package:getincoffee/features/addresses/cubit/addresses_states.dart';
import 'package:getincoffee/features/auth/presentation/widgets/agree_policy_privacy_widget.dart';
import 'package:getincoffee/features/cart/cubit/cart_states.dart';
import 'package:getincoffee/features/cart/cubit/payment_cubit.dart';
import 'package:getincoffee/features/cart/domain/model/summary_model.dart';
import 'package:getincoffee/features/cart/presentation/widgets/payment_widget.dart';
import 'package:getincoffee/features/paymentmethod/cubit/paymentmethod_cubit.dart';
import 'package:getincoffee/features/paymentmethod/cubit/paymentmethod_states.dart';
import 'package:getincoffee/features/paymentmethod/domain/request/paymentmethod_request.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:getincoffee/shared/widgets/edit_text_widget.dart';
import 'package:getincoffee/shared/widgets/loadinganderror.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class AddressesSheetBodyWidget extends StatelessWidget {
  const AddressesSheetBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressesCubit(),
      child: BlocConsumer<AddressesCubit, AddressesStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = AddressesCubit.get(context);
          return LoadingAndError(
            isLoading: state is GetAddressesLoading,
            isError: state is GetAddressesFailure,
            function: () => cubit.reset(),
            child: Container(
              // height: MediaQuery.sizeOf(context).height * 0.7,
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
                        LocalizationHelper.tr.choose_location_delivery,
                        style: TextStyles.font14BlackMedium.copyWith(
                          color: LightThemeColors.black,
                          fontWeight: FontWeights.extraBold,
                        ),
                      ),
                      SvgPicture.asset(
                        SvgAssets.scanIcon,
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
                  if ((cubit.addressesModel?.data?.length ?? 0) == 0)
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            SvgAssets.location,
                            height: 50,
                            colorFilter: const ColorFilter.mode(
                              LightThemeColors.grey,
                              BlendMode.srcIn,
                            ),
                          ),
                          16.ph,
                          Text(
                            LocalizationHelper.tr.no_location_added_yet,
                            style: TextStyles.font14BlackMedium.copyWith(
                              color: LightThemeColors.grey,
                              fontWeight: FontWeights.semiBold,
                            ),
                          ),
                          20.ph,
                        ],
                      ),
                    )
                  else
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.6,
                      child: ListView.separated(
                        itemCount: cubit.addressesModel?.data?.length ?? 0,
                        separatorBuilder: (context, index) => 15.ph,
                        itemBuilder: (context, index) {
                          return LocationWidget(
                            ontap: () {
                              Navigator.pop(
                                  context, cubit.addressesModel?.data?[index]);
                            },
                            withTitle: false,
                            addressModel: cubit.addressesModel?.data?[index],
                          );
                        },
                      ),
                    ),
                  30.ph,
                  ButtonWidget(
                    title: LocalizationHelper.tr.add_new_location,
                    onTap: () {
                      Navigator.pushNamed(context, Routes.AddressesScreen)
                          .then((value) => cubit.reset());
                    },
                  ),
                  // 5.ph,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// copon bottomsheet

class CoponBottomSheet extends StatefulWidget {
  const CoponBottomSheet({super.key, required this.type});

  final String type;

  @override
  State<CoponBottomSheet> createState() => _CoponBottomSheetState();
}

class _CoponBottomSheetState extends State<CoponBottomSheet> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, CartStates>(
      listener: (context, state) {
        if (state is VerifyCoponSuccess) {
          Navigator.pop(context);
          Alerts.bottomSheet(
            context,
            child: AddcoponSuccessSheetBody(summaryModel: state.summaryModel),
          );
        }
      },
      builder: (context, state) {
        final cubit = PaymentCubit.get(context);
        return Container(
          // height: MediaQuery.sizeOf(context).height * 0.7,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                61.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocalizationHelper.tr.add_coupon,
                      style: TextStyles.font14BlackMedium.copyWith(
                        color: LightThemeColors.black,
                        fontWeight: FontWeights.extraBold,
                      ),
                    ),
                    SvgPicture.asset(
                      SvgAssets.scanIcon,
                    ),
                  ],
                ),
                20.ph,
                const Divider(
                  thickness: 1,
                  height: 0,
                  color: LightThemeColors.darkwhite,
                ),
                42.ph,
                Form(
                  key: formKey,
                  child: TextFormFieldWidget(
                    validator: Utils.valid.defaultValidation,
                    onSaved: (value) => cubit.copon = value!,
                    fixedlabel: LocalizationHelper.tr.coupon_required,
                    hintText: LocalizationHelper.tr.enter_coupon_code,
                  ),
                ),
                30.ph,
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: LocalizationHelper.tr.want_more_coupons,
                        style: TextStyles.font12BlackBold.copyWith(
                          fontWeight: FontWeights.semiBold,
                          color: LightThemeColors.grey,
                        ),
                      ),
                      const TextSpan(
                        text: "\n \n",
                      ),
                      TextSpan(
                        text: LocalizationHelper.tr.social_media_platforms,
                        style: TextStyles.font12BlackBold.copyWith(
                          fontWeight: FontWeights.extraBold,
                          color: LightThemeColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                30.ph,
                ButtonWidget(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      cubit.verifyCopon(
                        type: widget.type,
                      );
                    }
                  },
                  title: LocalizationHelper.tr.verify,
                ),
                46.ph,
              ],
            ),
          ),
        );
      },
    );
  }
}

// copon success sheet

class AddcoponSuccessSheetBody extends StatelessWidget {
  const AddcoponSuccessSheetBody({super.key, required this.summaryModel});

  final SummaryModel? summaryModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.sizeOf(context).height * 0.7,
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
                LocalizationHelper.tr.add_coupon,
                style: TextStyles.font14BlackMedium.copyWith(
                  color: LightThemeColors.black,
                  fontWeight: FontWeights.extraBold,
                ),
              ),
              SvgPicture.asset(
                SvgAssets.scanIcon,
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
          Image.asset(
            ImgAssets.successCheck,
          ),
          20.ph,
          Text(
            LocalizationHelper.tr
                .you_saved_percentage(summaryModel?.discount.toString() ?? ""),
            style: TextStyles.font18BlackExtraBold.copyWith(
              color: LightThemeColors.primary,
              // fontWeight: FontWeights.extraBold,
            ),
          ),
          20.ph,
          Text(
            LocalizationHelper.tr.discount_applied_checkout,
            style: TextStyles.font12BlackBold.copyWith(
              color: LightThemeColors.lightgrey,
              fontWeight: FontWeights.medium,
            ),
          ),
          46.ph,
        ],
      ),
    );
  }
}

/// payment method bottomsheet
class PaymentshetBody extends StatelessWidget {
  const PaymentshetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentmethodCubit(),
      child: BlocConsumer<PaymentmethodCubit, PaymentmethodStates>(
        listener: (context, state) {
          final cubit = PaymentmethodCubit.get(context);
          if (state is PaymentmethodSuccessState) {
            cubit.cards = state.cards;
          }
        },
        builder: (context, state) {
          final cubit = PaymentmethodCubit.get(context);
          return LoadingAndError(
            isLoading: state is PaymentmethodLoadingState,
            isError: state is PaymentmethodErrorState,
            function: () => cubit.getAllpaymentMethods(),
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.7,
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
                        LocalizationHelper.tr.add_payment_methods,
                        style: TextStyles.font14BlackMedium.copyWith(
                          color: LightThemeColors.black,
                          fontWeight: FontWeights.extraBold,
                        ),
                      ),
                      SvgPicture.asset(
                        SvgAssets.scanIcon,
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
                  Expanded(
                    child: (cubit.cards?.cards?.isEmpty ?? true)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                SvgAssets.emptyCard,
                                height: 64,
                              ),
                              16.ph,
                              Text(
                                LocalizationHelper.tr.no_payment_yet,
                                style: TextStyles.font14BlackMedium.copyWith(
                                  color: LightThemeColors.grey,
                                  fontWeight: FontWeights.semiBold,
                                ),
                              ),
                            ],
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) {
                              return PaymentMethodWidget(
                                withTitle: false,
                                model: cubit.cards?.cards?[index],
                                onChoose: () {
                                  Navigator.pop(
                                      context, cubit.cards?.cards?[index]);
                                },
                                ontap: () {
                                  Alerts.bottomSheet(
                                    context,
                                    child: SaveBottomSheetBody(
                                      savepaymentMethod: (p0) =>
                                          cubit.savePaymentMethod(request: p0),
                                    ),
                                  );
                                },
                              );
                            },
                            separatorBuilder: (context, index) {
                              return 10.ph;
                            },
                            itemCount: cubit.cards?.cards?.length ?? 0,
                          ),
                  ),
                  20.ph,
                  ButtonWidget(
                    onTap: () async {
                      final result = await Alerts.bottomSheet(
                        context,
                        child: BlocProvider.value(
                          value: cubit,
                          child: const AddPaymentshetBody(),
                        ),
                      );
                      if (result == true) {
                        cubit.getAllpaymentMethods();
                      }
                    },
                    title: LocalizationHelper.tr.add_cards,
                  ),
                  46.ph,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AddPaymentshetBody extends StatefulWidget {
  const AddPaymentshetBody({super.key});

  @override
  State<AddPaymentshetBody> createState() => _AddPaymentshetBodyState();
}

class _AddPaymentshetBodyState extends State<AddPaymentshetBody> {
  bool _cardComplete = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentmethodCubit, PaymentmethodStates>(
      listener: (context, state) {
        if (state is SavePaymentMethodSuccess) {
          Navigator.pop(context, true);
        }
        if (state is SavePaymentMethodError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Failed to save card'),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = PaymentmethodCubit.get(context);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                61.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocalizationHelper.tr.add_payment_methods,
                      style: TextStyles.font14BlackMedium.copyWith(
                        color: LightThemeColors.black,
                        fontWeight: FontWeights.extraBold,
                      ),
                    ),
                    SvgPicture.asset(
                      SvgAssets.scanIcon,
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
                CardFormField(
                  onCardChanged: (card) {
                    setState(() {
                      _cardComplete = card?.complete ?? false;
                    });
                  },
                  style: CardFormStyle(
                    backgroundColor: Colors.white,
                    borderColor: LightThemeColors.grey,
                    borderRadius: 12,
                    textColor: LightThemeColors.black,
                    placeholderColor: LightThemeColors.black,
                  ),
                ),
                30.ph,
                ButtonWidget(
                  witharrows: true,
                  title: state is SavePaymentMethodLoading
                      ? LocalizationHelper.tr.loading
                      : LocalizationHelper.tr.add_cards,
                  onTap: _cardComplete && state is! SavePaymentMethodLoading
                      ? () => cubit.addCardWithStripe()
                      : null,
                ),
                46.ph,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// savepaymentmethod sheet

class SaveBottomSheetBody extends StatefulWidget {
  const SaveBottomSheetBody({super.key, this.savepaymentMethod});
  final Function(PaymentmethodRequest?)? savepaymentMethod;
  @override
  State<SaveBottomSheetBody> createState() => _SaveBottomSheetBodyState();
}

class _SaveBottomSheetBodyState extends State<SaveBottomSheetBody> {
  PaymentmethodRequest request = PaymentmethodRequest();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * .8,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            61.ph,
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocalizationHelper.tr.add_payment_methods,
                      style: TextStyles.font14BlackMedium.copyWith(
                        color: LightThemeColors.black,
                        fontWeight: FontWeights.extraBold,
                      ),
                    ),
                    SvgPicture.asset(
                      SvgAssets.scanIcon,
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: LightThemeColors.cardBackground,
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
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: LightThemeColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: LightThemeColors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                15.ph,
                TextFormFieldWidget(
                  hintText: LocalizationHelper.tr.enter_your_name_here,
                  fixedlabel: LocalizationHelper.tr.cardholder_name_required,
                  validator: Utils.valid.defaultValidation,
                  onSaved: (value) {
                    request.name = value;
                  },
                ),
                15.ph,
                TextFormFieldWidget(
                  hintText: LocalizationHelper.tr.enter_card_number_here,
                  fixedlabel: LocalizationHelper.tr.card_number_required,
                  validator: Utils.valid.defaultValidation,
                  type: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(19),
                    CreditCardFormatter(),
                  ],
                  onSaved: (value) {
                    request.last4 = value;
                  },
                ),
                37.ph,
                Row(
                  children: [
                    Expanded(
                      child: TextFormFieldWidget(
                        hintText: "000",
                        fixedlabel:
                            LocalizationHelper.tr.protection_code_required,
                        validator: Utils.valid.defaultValidation,
                        onSaved: (value) {
                          // CVV code
                        },
                      ),
                    ),
                    10.pw,
                    Expanded(
                      child: TextFormFieldWidget(
                        hintText: LocalizationHelper.tr.month_year,
                        fixedlabel:
                            LocalizationHelper.tr.expiration_date_required,
                        validator: Utils.valid.defaultValidation,
                        type: TextInputType.number,
                        inputFormatters: const [
                          // FilteringTextInputFormatter.digitsOnly,
                        ],
                        onSaved: (value) {
                          final parts = value?.split('/') ?? [];
                          if (parts.length == 2) {
                            request.expMonth = int.tryParse(parts[0]);
                            request.expYear = int.tryParse(parts[1]);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            21.ph,
            AgreePolicyPrivacyWidget(
              title: LocalizationHelper.tr.save_payment_info_future,
            ),
            const Spacer(),

            // 15.ph,
            ButtonWidget(
              witharrows: true,
              title: LocalizationHelper.tr.place_order_now,
              onTap: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  widget.savepaymentMethod?.call(request);
                  // AddressesCubit.get(context).addAddress(addressRequest);
                }
              },
            ),
            43.ph,
          ],
        ),
      ),
    );
  }
}

class CreditCardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly =
        newValue.text.replaceAll(' ', LocalizationHelper.tr.unspecified_phrase);

    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      buffer.write(digitsOnly[i]);
      if ((i + 1) % 4 == 0 && i + 1 != digitsOnly.length) {
        buffer.write(' ');
      }
    }

    final newText = buffer.toString();
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
