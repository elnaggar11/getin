import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/cart/cubit/cart_states.dart';
import 'package:getincoffee/features/cart/cubit/payment_cubit.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/home/presentation/widgets/slider_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'cart_ProductWidget.dart';

class StartDialogBody extends StatefulWidget {
  const StartDialogBody({super.key});

  @override
  State<StartDialogBody> createState() => _StartDialogBodyState();
}

class _StartDialogBodyState extends State<StartDialogBody> {
  int currentindex = 0;

  bool _itemAdded = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentCubit()..addPageListener(),
      child: BlocConsumer<PaymentCubit, CartStates>(
        listener: (context, state) {
          if (state is AddTocartSuccess) {
            _itemAdded = true;
          }
          print(PaymentCubit.get(context).pagingController.itemList?.isEmpty ??
              true);
          print(state);
          if (state is CartProductsFailedState &&
              (PaymentCubit.get(context).pagingController.itemList?.isEmpty ??
                  true)) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final cubit = PaymentCubit.get(context);
          return Container(
            width: MediaQuery.sizeOf(context).width,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 400,
                  child: PagedPageView<int, List<ProductModel>>(
                    pagingController: cubit.pagingController,
                    onPageChanged: (value) {
                      currentindex = value;
                      setState(() {});
                    },
                    builderDelegate:
                        PagedChildBuilderDelegate<List<ProductModel>>(
                      firstPageProgressIndicatorBuilder: (context) =>
                          SizedBox(),
                      itemBuilder: (context, pageProducts, pageIndex) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: pageProducts.map((product) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 16, right: 16),
                              child: CartProductwidget(
                                item: product,
                                branchId: cubit.branchId,
                                onAddToCart: () {
                                  if (product.hasOptions ?? false) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.ProductdetailsScreen,
                                      arguments: ProductDetailsargs(
                                        id: product.id ??
                                            LocalizationHelper
                                                .tr.unspecified_phrase,
                                        branchId:
                                            cubit.branchId?.toString() ?? '',
                                      ),
                                    );
                                    return;
                                  }
                                  cubit.addtoCartRequest.branchId = cubit
                                          .branchId
                                          ?.toString() ??
                                      LocalizationHelper.tr.unspecified_phrase;
                                  cubit.addtoCartRequest.product = product;
                                  cubit.addtoCartRequest.optionValueIds = [];
                                  cubit.addtoCartRequest.productId = product.id;
                                  cubit.addtoCartRequest.quantity = '1';
                                  cubit.addtoCart();
                                },

                                // quan: product.quantity,
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
                60.ph,
                SliderDots(
                  length: cubit.length,
                  currentIndex: currentindex,
                ),
                103.ph,
                /*  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ButtonWidget(
                    title: LocalizationHelper.tr.one_click_exchange_feature,
                  ),
                ), */
                30.ph,
                GestureDetector(
                  onTap: () {
                    if (_itemAdded) {
                      Navigator.pop(context, true);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: LightThemeColors.white,
                    ),
                    child: Center(
                      child: SvgPicture.asset(SvgAssets.cancel),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
