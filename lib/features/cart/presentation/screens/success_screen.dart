import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/cart/cubit/cart_states.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/resources/font_manager.dart';
import '../../../../core/theme/light_theme.dart';
import '../../cubit/cart_cubit.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(),
      child: BlocConsumer<CartCubit, CartStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = CartCubit.get(context);
          return Scaffold(
            backgroundColor: LightThemeColors.primary,
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocalizationHelper.tr.success,
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
                  //      SvgAssets.delete
                  //     ),
                  //   ],
                  // )
                ],
              ),
              toolbarHeight: 109,
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
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  252.ph,
                  Column(
                    children: [
                      Image.asset(
                        ImgAssets.successCheck,
                      ),
                      20.ph,
                      Text(
                        LocalizationHelper.tr.payment_successful,
                        style: TextStyles.font20WhiteSemiBold.copyWith(
                          fontSize: 21,
                          fontWeight: FontWeights.extraBold,
                          color: LightThemeColors.primary,
                        ),
                      ),
                      8.ph,
                      Text(
                        LocalizationHelper.tr.order_confirmed,
                        style: TextStyles.font20WhiteSemiBold.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeights.semiBold,
                          color: LightThemeColors.grey,
                        ),
                      ),
                    ],
                  ),
                  // 113.ph,
                  const Spacer(),
                  Column(
                    children: [
                      ButtonWidget(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.TrackorderScreen,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocalizationHelper.tr.track_order,
                                style: TextStyles.font16BlackRegular.copyWith(
                                  color: LightThemeColors.white,
                                  fontWeight: FontWeights.medium,
                                ),
                              ),
                              SvgPicture.asset(
                                SvgAssets.buttonLocation,
                              ),
                            ],
                          ),
                        ),
                      ),
                      12.ph,
                      ButtonWidget(
                        buttonColor: LightThemeColors.black,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocalizationHelper.tr.share,
                                style: TextStyles.font16BlackRegular.copyWith(
                                  color: LightThemeColors.white,
                                  fontWeight: FontWeights.medium,
                                ),
                              ),
                              SvgPicture.asset(
                                SvgAssets.successScanIcon,
                              ),
                            ],
                          ),
                        ),
                      ),
                      12.ph,
                      ButtonWidget(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        buttonColor: LightThemeColors.orange,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocalizationHelper.tr.back_to_shopping,
                                style: TextStyles.font16BlackRegular.copyWith(
                                  color: LightThemeColors.black,
                                  fontWeight: FontWeights.medium,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                color: LightThemeColors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  38.ph,
                  // 150.ph,
                ],
              ),
            ),
            // bottomNavigationBar: 150.ph,
          );
        },
      ),
    );
  }
}
