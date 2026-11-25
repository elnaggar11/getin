import 'dart:developer' show log;

import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/layout/cubit/layout_cubit.dart';
import 'package:getincoffee/shared/widgets/loadinganderror.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/font_manager.dart';
import '../../../../core/theme/light_theme.dart';
import '../../cubit/myorder_cubit.dart';
import '../../cubit/myorder_states.dart';
import '../widgets/ongoing_body.dart';
import '../widgets/reorder_confirmation_dialog.dart';

class MyorderScreen extends StatefulWidget {
  const MyorderScreen({super.key});

  @override
  State<MyorderScreen> createState() => _MyorderScreenState();
}

class _MyorderScreenState extends State<MyorderScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyorderCubit()..getOrders(),
      child: BlocConsumer<MyorderCubit, MyorderStates>(
        listener: (context, state) {
          if (state is ReorderConfirmationRequiredState) {
            showDialog(
              context: context,
              builder: (mycontext) => ReorderConfirmationDialog(
                unavailableItems: state.unavailableItems,
                onConfirm: () {
                  Navigator.pop(context);
                  MyorderCubit.get(context).reOrder(state.id, confirm: "1");
                },
                onCancel: () {
                  Navigator.pop(context);
                },
              ),
            );
          }
          if (state is CancelOrderSuccessState ||
              state is ReorderSuccessState) {
            MyorderCubit.get(context).getOrders();
          }
          log(state.toString(), name: "SDDDDDDDD");
          if (state is ReorderSuccessState) {
            try {
              LayoutCubit.get(context).changeTab(1);
            } catch (e) {
              log(e.toString(), name: "S2DDDDDDDD");
            }
          }
        },
        builder: (context, state) {
          final cubit = MyorderCubit.get(context);
          return Scaffold(
            backgroundColor: LightThemeColors.primary,
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocalizationHelper.tr.my_orders,
                    style: TextStyles.font20WhiteSemiBold.copyWith(
                      color: LightThemeColors.white,
                    ),
                  ),
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
                  20.ph,
                  Container(
                    // width: 194,
                    padding: const EdgeInsets.all(
                      10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        40,
                      ),
                      color: LightThemeColors.darkwhite,
                    ),
                    child: TabBar(
                      dividerHeight: 0,
                      controller: tabController,
                      indicator: BoxDecoration(
                        color: LightThemeColors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: LightThemeColors.primary,
                      unselectedLabelColor: Colors.black,
                      labelStyle: const TextStyle(
                        color: LightThemeColors.grey,
                        fontWeight: FontWeights.medium,
                        fontSize: 12,
                      ),
                      onTap: (value) {
                        cubit.statusToBack = value == 0
                            ? "pending"
                            : value == 1
                                ? "completed"
                                : "canceled";
                        cubit.getOrders();
                      },
                      tabs: [
                        Tab(text: LocalizationHelper.tr.ongoing),
                        Tab(text: LocalizationHelper.tr.completed),
                        Tab(text: LocalizationHelper.tr.cancelled),
                      ],
                    ),
                  ),
                  15.ph,
                  Expanded(
                    child: LoadingAndError(
                      isLoading: state is MyorderLoadingState,
                      isError: state is MyorderErrorState,
                      function: () => cubit.getOrders(),
                      child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: tabController,
                          children: List.generate(
                            3,
                            (i) => OngoingBody(
                              cubit: cubit,
                            ),
                          )
                          //  [
                          //   OngoingBody(
                          //     cubit: cubit,
                          //   ),
                          //   // CompletedBody(
                          //   //   cubit: cubit,
                          //   // ),
                          //   // CanceledBody(
                          //   //   cubit: cubit,
                          //   // ),
                          // ],
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
