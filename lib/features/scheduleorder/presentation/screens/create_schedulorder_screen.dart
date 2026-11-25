import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/cart/presentation/widgets/bottomsheets.dart'
    show AddressesSheetBodyWidget;
import 'package:getincoffee/features/cart/presentation/widgets/delete_bottomsheet.dart';
import 'package:getincoffee/features/cart/presentation/widgets/payment_widget.dart';
import 'package:getincoffee/features/home/presentation/widgets/bottom_sheet/search_bottom_sheet.dart';
import 'package:getincoffee/features/productdetails/domain/request/productdetails_request.dart';
import 'package:getincoffee/features/scheduleorder/cubit/scheduleorder_cubit.dart';
import 'package:getincoffee/features/scheduleorder/cubit/scheduleorder_states.dart';
import 'package:getincoffee/features/scheduleorder/presentation/widgets/calender_sheetbody.dart';
import 'package:getincoffee/features/scheduleorder/presentation/widgets/schedule_product_widget.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:getincoffee/shared/widgets/default_image_widget.dart';
import 'package:getincoffee/shared/widgets/edit_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/Router/Router.dart';
import '../../../../shared/back_widget.dart';
import '../../../addresses/domain/model/addresses_model/datum.dart';
import '../../../cart/presentation/widgets/widgets.dart';
import '../../../home/domain/model/home_model.dart';
import 'package:getincoffee/core/services/stripe_service.dart';

class CreateSchedulorderScreen extends StatefulWidget {
  const CreateSchedulorderScreen({super.key});

  @override
  State<CreateSchedulorderScreen> createState() =>
      _CreateSchedulorderScreenState();
}

class _CreateSchedulorderScreenState extends State<CreateSchedulorderScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  TextEditingController branchController = TextEditingController();
  TextEditingController dateControler = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  BranchModel branchModel = BranchModel();
  String? imagePath;
  // TextEditingController dateControler = TextEditingController();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.removeListener(() {
      setState(() {});
    });
    branchController.dispose();
    dateControler.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScheduleorderCubit()
        ..getBranches()
        ..addpageListener(),
      child: BlocConsumer<ScheduleorderCubit, ScheduleorderStates>(
        listener: (context, state) async {
          if (state is BranchesLoadedSuccess) {
            ScheduleorderCubit.get(context).branchModel = state.branches;
          }
          if (state is ScheduleorderSuccess) {
            var cubit = ScheduleorderCubit.get(context);
            if (cubit.scheduleorderRequest.payWith == 'money' &&
                state.data != null) {
              try {
                await StripeService.presentPaymentSheet(
                  clientSecret: state.data?.clientSecret ?? '',
                  ephemeralKey: state.data?.ephemeralKey ?? '',
                  stripeCustomerId: state.data?.stripeCustomerId ?? '',
                );
                if (context.mounted) {
                  Navigator.pop(context, "refresh");
                }
              } catch (e) {
                Alerts.snack(text: e.toString(), state: SnackState.failed);
                print(e.toString());
              }
            } else {
              Navigator.pop(context, "refresh");
            }
          }
        },
        builder: (context, state) {
          final cubit = ScheduleorderCubit.get(context);
          return Scaffold(
            backgroundColor: LightThemeColors.white,
            appBar: AppBar(
              leading: const BackWidget(),
              centerTitle: false,
              title: Text(
                LocalizationHelper.tr.schedule_order,
                style: const TextStyle(
                  color: LightThemeColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          LocationTabbar(
                            tabController: tabController,
                            canDelivery: true,
                          ),
                          32.ph,
                          if (cubit.paymentmethodRequest.id == null)
                            SelectPaymentWidget(
                              ontap: () => cubit.chooseCard(context),
                            )
                          else
                            PaymentMethodWidget(
                              model: cubit.paymentmethodRequest,
                              ontap: () => cubit.chooseCard(context),
                            ),
                          16.ph,
                          if (tabController.index == 0) ...[
                            TextFormFieldWidget(
                              controller: locationController,
                              readOnly: true,
                              onTap: () {
                                Alerts.bottomSheet(
                                  close: (val) async {
                                    if (val != null) {
                                      cubit.scheduleorderRequest
                                          .userLocationId = val.id.toString();
                                      locationController.text =
                                          (val as AddresseData)
                                              .nameAddress
                                              .toString();
                                    }
                                    return true;
                                  },
                                  context,
                                  child: const AddressesSheetBodyWidget(),
                                );
                                // }
                              },
                              fixedlabel: LocalizationHelper.tr.location,
                              hintText: LocalizationHelper.tr.select_location,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  width: 33,
                                  height: 33,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: LightThemeColors.darkwhite,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      SvgAssets.arrowDown,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            33.ph,
                          ],
                          TextFormFieldWidget(
                            controller: dateControler,
                            readOnly: true,
                            onTap: () {
                              Alerts.bottomSheet(
                                close: (val) async {
                                  if (val != null) {
                                    cubit.scheduleorderRequest.scheduleTime =
                                        val;
                                    dateControler.text = val;
                                  }
                                  return true;
                                },
                                context,
                                child: const CalenderSheetbody(),
                              );
                            },
                            fixedlabel:
                                LocalizationHelper.tr.delivery_time_required,
                            hintText:
                                LocalizationHelper.tr.enter_delivery_time_here,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                SvgAssets.calender,
                              ),
                            ),
                          ),
                          20.ph,
                          TextFormFieldWidget(
                            // contentPadding:
                            //     const EdgeInsetsDirectional.symmetric(horizontal: 20),
                            controller: branchController,
                            readOnly: true,
                            prefixWidget: imagePath == null
                                ? null
                                : Container(
                                    //width: 30,
                                    //height: 30,
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsetsDirectional.only(
                                        start: 4),
                                    child: DefaultImageWidget(
                                      imagePath ??
                                          LocalizationHelper
                                              .tr.unspecified_phrase,
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 40,
                                      radius: 20,
                                    ),
                                  ),
                            onTap: () {
                              if (cubit.cartproducts.isNotEmpty == true) {
                                Alerts.snack(
                                    text: LocalizationHelper
                                        .tr.please_remove_products_first,
                                    state: SnackState.failed);
                              } else {
                                Alerts.bottomSheet(
                                  context,
                                  close: (val) async {
                                    if (val != null) {
                                      branchModel = val;
                                      cubit.scheduleorderRequest.branchId =
                                          val.id;
                                      branchController.text = val.name;
                                      imagePath = val.image;
                                      setState(() {});
                                    }
                                    return true;
                                  },
                                  child: SearchBottomSheet(
                                    branches: cubit.branchModel ?? [],
                                    // ontap: (id) {
                                    //   Navigator.pop(context, id);
                                    // },
                                  ),
                                );
                              }
                            },
                            fixedlabel:
                                LocalizationHelper.tr.choose_branch_required,
                            hintText: LocalizationHelper.tr.enter_branch_here,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                width: 33,
                                height: 33,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: LightThemeColors.darkwhite,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    SvgAssets.arrowDown,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          20.ph,
                          TextFormFieldWidget(
                            readOnly: true,
                            onTap: () async {
                              if (cubit.scheduleorderRequest.branchId == null) {
                                Alerts.snack(
                                  text: LocalizationHelper
                                      .tr.please_choose_branch_first,
                                  state: SnackState.failed,
                                );
                              } else {
                                print(
                                  cubit.scheduleorderRequest.branchId,
                                );
                                final response = await Navigator.pushNamed(
                                  context,
                                  Routes.HomeScreen,
                                  arguments: HomeArgs(
                                    fromsch: false,
                                    branch: branchModel,
                                    canchangeBranch: false,
                                    isSchedule: true,
                                  ),
                                );

                                if ((response as AddtoCartRequest?) != null) {
                                  cubit.cartproducts.add((response));

                                  setState(() {});
                                  // cubit.quantities.add((response).choosenNumber ?? LocalizationHelper.tr.unspecified_phrase);
                                }
                              }
                            },
                            fixedlabel:
                                LocalizationHelper.tr.choose_product_required,
                            hintText: LocalizationHelper.tr.enter_product_here,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                width: 33,
                                height: 33,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: LightThemeColors.darkwhite,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    SvgAssets.arrowDown,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          10.ph,
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cubit.cartproducts.length,
                            itemBuilder: (context, index) {
                              return ScheduleProductWidget(
                                cartproduct: cubit.cartproducts[index]!,
                                decrease: (p0) {
                                  cubit.cartproducts[index]?.quantity =
                                      p0.toString();
                                  setState(() {});
                                },
                                delete: () {
                                  Alerts.bottomSheet(context,
                                      child: ActionBottomSheet(
                                    onConfirm: () {
                                      cubit.cartproducts.removeAt(index);
                                      setState(() {});
                                    },
                                  ));
                                },
                                add: (p0) {
                                  cubit.cartproducts[index]?.quantity =
                                      p0.toString();
                                  setState(() {});
                                },
                              );
                            },
                          ),
                          // cubit.cartproducts.isEmpty ? 300.ph : 150.ph,
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            cubit.scheduleorderRequest.payWith = 'points';
                            setState(() {});
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  cubit.scheduleorderRequest.payWith == 'points'
                                      ? LightThemeColors.primary
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow:
                                  cubit.scheduleorderRequest.payWith == 'points'
                                      ? [
                                          BoxShadow(
                                            color: LightThemeColors.primary
                                                .withOpacity(0.3),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.stars_rounded,
                                  size: 20,
                                  color: cubit.scheduleorderRequest.payWith ==
                                          'points'
                                      ? Colors.white
                                      : LightThemeColors.grey,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    LocalizationHelper.tr.pay_with_points,
                                    style: TextStyle(
                                      color:
                                          cubit.scheduleorderRequest.payWith ==
                                                  'points'
                                              ? Colors.white
                                              : LightThemeColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            cubit.scheduleorderRequest.payWith = 'money';
                            setState(() {});
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  cubit.scheduleorderRequest.payWith != 'points'
                                      ? LightThemeColors.primary
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow:
                                  cubit.scheduleorderRequest.payWith != 'points'
                                      ? [
                                          BoxShadow(
                                            color: LightThemeColors.primary
                                                .withOpacity(0.3),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_rounded,
                                  size: 20,
                                  color: cubit.scheduleorderRequest.payWith !=
                                          'points'
                                      ? Colors.white
                                      : LightThemeColors.grey,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    LocalizationHelper.tr.money_to_back,
                                    style: TextStyle(
                                      color:
                                          cubit.scheduleorderRequest.payWith !=
                                                  'points'
                                              ? Colors.white
                                              : LightThemeColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar:
                // Pay With Toggle
                Padding(
              padding: EdgeInsets.only(
                  right: 10,
                  left: 10,
                  bottom: 10 + MediaQuery.of(context).viewPadding.bottom),
              child: ButtonWidget(
                //height: 100,
                //width: 300,
                onTap: () {
                  cubit.scheduleorderRequest.orderType =
                      tabController.index == 0 ? "delivery" : "pick_up";

                  if (cubit.scheduleorderRequest.payWith != 'points' &&
                      (cubit.paymentmethodRequest.id == null ||
                          cubit.paymentmethodRequest.id!.isEmpty)) {
                    Alerts.snack(
                        text: LocalizationHelper.tr.select_payment_method,
                        state: SnackState.failed);
                    return;
                  }

                  cubit.addScheduleOrder();
                },
                title: LocalizationHelper.tr.confirm_now,
                witharrows: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
