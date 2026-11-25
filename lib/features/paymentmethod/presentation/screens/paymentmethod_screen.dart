import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/cart/presentation/widgets/bottomsheets.dart';
import 'package:getincoffee/features/cart/presentation/widgets/payment_widget.dart';
import 'package:getincoffee/shared/back_widget.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:getincoffee/shared/widgets/loadinganderror.dart';
import 'package:getincoffee/shared/widgets/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getincoffee/shared/widgets/empty_widget.dart';

import '../../cubit/paymentmethod_cubit.dart';
import '../../cubit/paymentmethod_states.dart';

class PaymentmethodScreen extends StatefulWidget {
  const PaymentmethodScreen({super.key});

  @override
  State<PaymentmethodScreen> createState() => _PaymentmethodScreenState();
}

class _PaymentmethodScreenState extends State<PaymentmethodScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentmethodCubit(),
      child: BlocConsumer<PaymentmethodCubit, PaymentmethodStates>(
        listener: (context, state) {
          if (state is PaymentmethodSuccessState) {}
          if (state is DeletePaymentMethodSuccess) {
            Alerts.snack(
              text: LocalizationHelper.tr.deleted_successfully,
              state: SnackState.success,
            );
          }
          if (state is DeletePaymentMethodError) {
            Alerts.snack(
              text: state.message ?? LocalizationHelper.tr.failed_to_delete,
              state: SnackState.failed,
            );
          }
        },
        builder: (context, state) {
          final cubit = PaymentmethodCubit.get(context);
          return Scaffold(
            backgroundColor: LightThemeColors.white,
            appBar: AppBar(
              leading: const BackWidget(),
              centerTitle: false,
              title: Text(
                LocalizationHelper.tr.payment_methods,
                style: const TextStyle(
                  color: LightThemeColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: LoadingAndError(
              isLoading: state is PaymentmethodLoadingState ||
                  state is DeletePaymentMethodLoading,
              isError: state is PaymentmethodErrorState,
              function: () {
                cubit.getAllpaymentMethods();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    37.ph,
                    Expanded(
                      child: cubit.cards?.cards?.isEmpty ?? true
                          ? EmptyWidget(
                              image: SvgAssets.emptyCard,
                              title:
                                  LocalizationHelper.tr.empty_payment_methods,
                              subtitle: LocalizationHelper
                                  .tr.add_payment_method_subtitle,
                            )
                          : ListView.separated(
                              itemBuilder: (context, index) {
                                return PaymentMethodWidget(
                                  withTitle: false,
                                  model: cubit.cards?.cards?[index],
                                  endwidget: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: SvgPicture.asset(
                                      SvgAssets.delete,
                                    ),
                                  ),
                                  ontap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => DeleteDialog(
                                        title: LocalizationHelper
                                            .tr.delete_payment_method_title,
                                        subTitle: LocalizationHelper.tr
                                            .delete_payment_method_confirmation,
                                        onConfirm: () {
                                          Navigator.pop(context);
                                          cubit.deletePaymentMethod(
                                            cubit.cards!.cards![index].id!,
                                          );
                                        },
                                        onCancel: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              separatorBuilder: (context, index) => 10.ph,
                              itemCount: cubit.cards?.cards?.length ?? 0,
                            ),
                    ),
                    const Spacer(),
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
                    25.ph,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
