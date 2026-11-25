import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/cart/domain/model/home_change_model.dart';
import 'package:getincoffee/features/cart/presentation/widgets/delete_bottomsheet.dart';
import 'package:getincoffee/features/cart/presentation/widgets/start_dialoge_body.dart';
import 'package:getincoffee/features/cart/presentation/widgets/widgets.dart';
import 'package:getincoffee/features/layout/cubit/layout_cubit.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:getincoffee/shared/widgets/loadinganderror.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/general/cubit/general_cubit.dart';
import '../../../../core/theme/light_theme.dart';
import '../../cubit/cart_cubit.dart';
import '../../cubit/cart_states.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit()..getallcart(),
      child: const CartBody(),
    );
  }
}

class CartBody extends StatefulWidget {
  const CartBody({super.key});

  @override
  State<CartBody> createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody>
    with SingleTickerProviderStateMixin {
// List

  showDialogesuggestions() {
    // final cartCubit = context.read<CartCubit>();
    Alerts.dialog(
      insetPadding: const EdgeInsets.all(0),
      context,
      child: const StartDialogBody(),
    ).then((value) {
      if (value is bool && mounted) {
        refresh();
      }
    });
  }

  void refresh() {
    setState(() {});
    CartCubit.get(context).getallcart();
  }

  late TabController tabController;

  @override
  void initState() {
    final generalCubit = GeneralCubit.get(context);
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: generalCubit.deliveryType,
    );
    tabController.addListener(() {
      generalCubit.updateDeliveryType(tabController.index);
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialogesuggestions();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartStates>(
      listener: (generalContext, state) {
        if (state is CartSuccessState) {
          CartCubit.get(context).cartModel = state.cartModel;
        }
        if (state is ClearAllCartSuccess) {
          CartCubit.get(context).getallcart();
        }
        // if (state is VerifyCoponSuccess) {
        //   CartCubit.get(context).getallcart();
        // }
      },
      builder: (context, state) {
        final cubit = CartCubit.get(context);
        final bool isPickup = cubit.cartModel.isDelivery == false ||
            (cubit.cartModel.isDelivery == true && tabController.index == 1);
        final String displayDeliveryCharge =
            isPickup ? "0" : (cubit.cartModel.deliveryCharge ?? "0");
        final String displayTotal = isPickup
            ? (cubit.cartModel.total.toDouble() -
                    cubit.cartModel.deliveryCharge.toDouble())
                .roundTo2numberString
            : cubit.cartModel.total ?? "0";

        return LoadingAndError(
          isLoading: state is CartLoadingState,
          isError: state is CartFailedState,
          function: () async => cubit.getallcart(),
          child: Scaffold(
            backgroundColor: LightThemeColors.primary,
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocalizationHelper.tr.cart,
                    style: TextStyles.font20WhiteSemiBold.copyWith(
                      color: LightThemeColors.white,
                    ),
                  ),
                  if (cubit.cartModel.items?.isNotEmpty ?? false)
                    Row(
                      children: [
                        Text(
                          LocalizationHelper.tr.clear_all,
                          style: TextStyles.font14BlackMedium.copyWith(
                            color: LightThemeColors.error,
                            fontWeight: FontWeights.regular,
                          ),
                        ),
                        7.pw,
                        SvgPicture.asset(
                          SvgAssets.delete,
                        ),
                      ],
                    ).onTap(() {
                      Alerts.bottomSheet(context,
                          child: BlocListener<CartCubit, CartStates>(
                            bloc: cubit,
                            listener: (context, state) {
                              if (state is ClearAllCartSuccess &&
                                  Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                            child: ActionBottomSheet(
                              onConfirm: () {
                                cubit.clearAlldata();
                              },
                            ),
                          ));
                    }) //"id": 44,
                  //  "order_num": "01.04.2026.566.753.68Z98D",
                ],
              ),
              toolbarHeight: 88,
              backgroundColor: LightThemeColors.primary,
              automaticallyImplyLeading: false,
              // leading: const Icon(
              //   Icons.arrow_back_sharp,
              //   color: LightThemeColors.white,
              // ).onTap(
              //   () {
              //     Navigator.pop(context);
              //   },
              // ),
            ),
            body: (cubit.cartModel.items?.isEmpty ?? true)
                ? const EmptyCart()
                : Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      color: LightThemeColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          36,
                        ),
                        topRight: Radius.circular(
                          36,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 3,
                    ),
                    child: Column(
                      children: [
                        15.ph,
                        Expanded(
                          child: ItemsWidget(
                            cubit: cubit,
                          ),
                        ),
                        10.ph,
                        SummaryWidget(
                          subtotal: cubit.cartModel.subTotal,
                          tax: cubit.cartModel.tax,
                          deliveryCharge: displayDeliveryCharge,
                          discount: cubit.summaryModel?.discount.toString(),
                          total: displayTotal,
                        ),
                        10.ph,
                        const DiscountWidget(),
                        10.ph,
                        LocationTabbar(
                          tabController: tabController,
                          canDelivery: cubit.cartModel.isDelivery ?? true,
                        ),
                        10.ph,
                        ButtonWidget(
                          onTap: () {
                            print(tabController.index);

                            Navigator.pushNamed(
                              context,
                              Routes.PaymentScreen,
                              arguments: {
                                'type': (tabController.index == 0 &&
                                        cubit.cartModel.isDelivery == true)
                                    ? LocalizationHelper.tr.delivery
                                    : LocalizationHelper.tr.pickup,
                                'typeBack': (tabController.index == 0 &&
                                        cubit.cartModel.isDelivery == true)
                                    ? 'delivery'
                                    : 'pick_up',
                              },
                            ).then((e) {
                              if (e is HomeChangeModel && context.mounted) {
                                LayoutCubit.get(context).changeTab(0);
                              } else if (e == true && context.mounted) {
                                CartCubit.get(context).getallcart();
                              } else if (e is int && context.mounted) {
                                LayoutCubit.get(context).changeTab(0);
                              }
                            });
                            // cubit.checkout();
                          },
                          title: LocalizationHelper.tr.checkout,
                          witharrows: true,
                        ),
                        15.ph,
                      ],
                    ),
                  ),
            // bottomNavigationBar: 150.ph,
          ),
        );
      },
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        color: LightThemeColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            36,
          ),
          topRight: Radius.circular(
            36,
          ),
        ),
      ),
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 3,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            LocalizationHelper.tr.empty_cart,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
