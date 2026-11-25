import 'package:getincoffee/core/Router/navigation_helper.dart';
import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart'
    show TextStyles, FontWeights;
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/myorder/domain/model/myorder_model.dart';
import 'package:getincoffee/features/rating/domain/request/rating_request.dart';
import 'package:getincoffee/features/rating/presentation/widgets/keywoed_widget.dart';
import 'package:getincoffee/features/rating/presentation/widgets/rating_driver_body.dart';
import 'package:getincoffee/features/rating/presentation/widgets/rating_product_body.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/light_theme.dart';
import '../../cubit/rating_cubit.dart';
import '../../cubit/rating_states.dart';
import '../widgets/rating_branch_body.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({
    super.key,
    this.item,
  });
  final MyorderModel? item;
  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen>
    with SingleTickerProviderStateMixin {
  bool isDriverRated = false;
  bool isProductRated = false;
  bool isBranchRated = false;

  bool _isCurrentTabRated() {
    if (widget.item?.driver != null) {
      if (tabController.index == 0) return isDriverRated;
      if (tabController.index == 1) return isProductRated;
      return isBranchRated;
    } else {
      if (tabController.index == 0) return isProductRated;
      return isBranchRated;
    }
  }

  TextEditingController drivertextController = TextEditingController();
  TextEditingController producttextController = TextEditingController();
  TextEditingController branchtextController = TextEditingController();
  String keyWordId = LocalizationHelper.tr.unspecified_phrase;
  String driverratevalue = LocalizationHelper.tr.unspecified_phrase;
  String productratevalue = LocalizationHelper.tr.unspecified_phrase;
  String branchratevalue = LocalizationHelper.tr.unspecified_phrase;
  late TabController tabController;

  @override
  void initState() {
    if (widget.item?.driver != null) {
      tabController = TabController(length: 3, vsync: this);
    } else {
      tabController = TabController(length: 2, vsync: this);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RatingCubit()..getKeywords(),
      child: BlocConsumer<RatingCubit, RatingStates>(
        listener: (context, state) {
          if (state is RatingSuccessState) {
            RatingCubit.get(context).keywords = state.keywords;
          }
          if (state is RatingBranchSuccessState) {
            setState(() {
              isBranchRated = true;
            });
            Alerts.snack(
                text: state.message ?? LocalizationHelper.tr.unspecified_phrase,
                state: SnackState.success);
          }
          if (state is RatingDeliverySuccessState) {
            setState(() {
              isDriverRated = true;
            });
            Alerts.snack(
                text: state.message ?? LocalizationHelper.tr.unspecified_phrase,
                state: SnackState.success);
          }
          if (state is RatingProductSuccessState) {
            setState(() {
              isProductRated = true;
            });
            Alerts.snack(
                text: state.message ?? LocalizationHelper.tr.unspecified_phrase,
                state: SnackState.success);
          }
        },
        builder: (context, state) {
          final cubit = RatingCubit.get(context);
          return Scaffold(
            backgroundColor: LightThemeColors.primary,
            appBar: AppBar(
              leading: const Icon(
                Icons.arrow_back_sharp,
                color: LightThemeColors.white,
              ).onTap(
                () {
                  Navigator.pop(context);
                },
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocalizationHelper.tr.rating_now,
                    style: TextStyles.font20WhiteSemiBold.copyWith(
                      color: LightThemeColors.white,
                    ),
                  ),
                ],
              ),
              toolbarHeight: 109,
              backgroundColor: LightThemeColors.primary,
              automaticallyImplyLeading: false,
            ),
            body: Container(
              width: MediaQuery.sizeOf(context).width,
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
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  24.ph,
                  TabBar(
                    physics: const NeverScrollableScrollPhysics(),
                    tabAlignment: TabAlignment.center,
                    dividerHeight: 0,
                    controller: tabController,
                    indicator: BoxDecoration(
                      color: LightThemeColors.primary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: LightThemeColors.white,
                    unselectedLabelColor: Colors.black,
                    labelPadding: EdgeInsets.zero,
                    labelStyle: const TextStyle(
                      color: LightThemeColors.grey,
                      fontWeight: FontWeights.medium,
                      fontSize: 14,
                    ),
                    onTap: (value) {
                      setState(() {});
                    },
                    tabs: [
                      if (widget.item?.driver != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Tab(
                            icon: Row(
                              children: [
                                5.pw,
                                Container(
                                  width: 115,
                                  // height: 20,
                                  // padding: const EdgeInsets.symmetric(
                                  //   horizontal: 25,
                                  // ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      40,
                                    ),
                                    color: tabController.index == 0
                                        ? LightThemeColors.primary
                                        : LightThemeColors.orange,
                                  ),
                                  child: Center(
                                    child: Text(
                                      LocalizationHelper.tr.rate_driver,
                                      style:
                                          TextStyles.font12BlackBold.copyWith(
                                        color: tabController.index == 0
                                            ? LightThemeColors.white
                                            : LightThemeColors.primary,
                                        fontSize: 14,
                                        fontWeight: FontWeights.medium,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Tab(
                          icon: Container(
                            width: 115,
                            // height: 20,
                            // padding: const EdgeInsets.symmetric(
                            //   horizontal: 25,
                            // ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                40,
                              ),
                              color: ((tabController.index == 1 &&
                                          widget.item?.driver != null) ||
                                      tabController.index == 0 &&
                                          widget.item?.driver == null)
                                  ? LightThemeColors.primary
                                  : LightThemeColors.orange,
                            ),
                            child: Center(
                              child: Text(
                                LocalizationHelper.tr.rate_product,
                                style: TextStyles.font12BlackBold.copyWith(
                                  color: ((tabController.index == 1 &&
                                              widget.item?.driver != null) ||
                                          tabController.index == 0 &&
                                              widget.item?.driver == null)
                                      ? LightThemeColors.white
                                      : LightThemeColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeights.medium,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Tab(
                          icon: Row(
                            children: [
                              5.pw,
                              Container(
                                width: 115,
                                // height: 20,
                                // padding: const EdgeInsets.symmetric(
                                //   horizontal: 20,
                                // ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    40,
                                  ),
                                  color: ((tabController.index == 2 &&
                                              widget.item?.driver != null) ||
                                          tabController.index == 1 &&
                                              widget.item?.driver == null)
                                      ? LightThemeColors.primary
                                      : LightThemeColors.orange,
                                ),
                                child: Center(
                                  child: Text(
                                    LocalizationHelper.tr.rate_branch,
                                    style: TextStyles.font12BlackBold.copyWith(
                                      color: ((tabController.index == 2 &&
                                                  widget.item?.driver !=
                                                      null) ||
                                              tabController.index == 1 &&
                                                  widget.item?.driver == null)
                                          ? LightThemeColors.white
                                          : LightThemeColors.primary,
                                      fontWeight: FontWeights.medium,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  15.ph,
                  Expanded(
                    child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: tabController,
                        children: [
                          if (widget.item?.driver != null)
                            DriverRateBody(
                              controlelr: drivertextController,
                              driver: widget.item!.driver!,
                              initialRating:
                                  double.tryParse(driverratevalue) ?? 0.0,
                              onchange: (p0) {
                                driverratevalue = p0.toString();
                              },
                            ),
                          RatingProductBody(
                            controlelr: producttextController,
                            products: widget.item?.items,
                            onchange: (p0) {
                              productratevalue = p0.toString();
                            },
                          ),
                          RatingBranchBody(
                            controlelr: branchtextController,
                            branch: widget.item?.branch,
                            initialRating:
                                double.tryParse(branchratevalue) ?? 0.0,
                            onchange: (p0) {
                              branchratevalue = p0.toString();
                            },
                          ),
                        ]),
                  ),
                  15.ph,
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return 10.pw;
                        },
                        scrollDirection: Axis.horizontal,
                        itemCount: cubit.keywords?.length ?? 0,
                        itemBuilder: (context, index) {
                          return KeyWordWidget(
                            isActive: cubit.keywords?[index].id == keyWordId,
                            keyWord: cubit.keywords?[index].name,
                          ).onTap(() {
                            if (tabController.index == 0 &&
                                widget.item?.driver != null) {
                              drivertextController.text +=
                                  cubit.keywords?[index].name ??
                                      LocalizationHelper.tr.unspecified_phrase;
                            }
                            if ((tabController.index == 1 &&
                                    widget.item?.driver != null) ||
                                (tabController.index == 0 &&
                                    widget.item?.driver == null)) {
                              producttextController.text +=
                                  cubit.keywords?[index].name ??
                                      LocalizationHelper.tr.unspecified_phrase;
                            }
                            if ((tabController.index == 2 &&
                                    widget.item?.driver != null) ||
                                (tabController.index == 1 &&
                                    widget.item?.driver == null)) {
                              branchtextController.text +=
                                  cubit.keywords?[index].name ??
                                      LocalizationHelper.tr.unspecified_phrase;
                            }
                            // keyWordId = cubit.keywords?[index].id ?? LocalizationHelper.tr.unspecified_phrase;

                            setState(() {});
                          });
                        }),
                  ),
                  10.ph,
                  ButtonWidget(
                    buttonColor:
                        _isCurrentTabRated() ? LightThemeColors.grey : null,
                    onTap: _isCurrentTabRated()
                        ? null
                        : () async {
                            if ((tabController.index == 0 &&
                                widget.item?.driver != null)) {
                              RatingRequest ratingRequest = RatingRequest(
                                orderId: widget.item?.id ??
                                    LocalizationHelper.tr.unspecified_phrase,
                                reviewableId: widget.item?.driver?.id ??
                                    LocalizationHelper.tr.unspecified_phrase,
                                rating: driverratevalue,
                                comment: drivertextController.text,
                              );
                              var res = await cubit.rateDelivery(
                                  ratingRequest,
                                  widget.item?.id ??
                                      LocalizationHelper.tr.unspecified_phrase);
                              if (res == true) {
                                tabController.animateTo(1);
                              }
                            } else if ((tabController.index == 1 &&
                                    widget.item?.driver != null) ||
                                (tabController.index == 0 &&
                                    widget.item?.driver == null)) {
                              RatingRequest ratingRequest = RatingRequest(
                                orderId: widget.item?.id ??
                                    LocalizationHelper.tr.unspecified_phrase,
                                reviewableId: widget.item?.branch?.id ??
                                    LocalizationHelper.tr.unspecified_phrase,
                                rating: productratevalue,
                                productratings: widget.item?.items,
                                comment: producttextController.text,
                              );
                              cubit.rateProduct(
                                ratingRequest,
                                widget.item?.id ??
                                    LocalizationHelper.tr.unspecified_phrase,
                              );
                            } else if ((tabController.index == 2 &&
                                    widget.item?.driver != null) ||
                                (tabController.index == 1 &&
                                    widget.item?.driver == null)) {
                              RatingRequest ratingRequest = RatingRequest(
                                orderId: widget.item?.id ??
                                    LocalizationHelper.tr.unspecified_phrase,
                                reviewableId: widget.item?.branch?.id ??
                                    LocalizationHelper.tr.unspecified_phrase,
                                rating: branchratevalue,
                                comment: branchtextController.text,
                              );
                              cubit.rateBranch(
                                ratingRequest,
                                widget.item?.id ??
                                    LocalizationHelper.tr.unspecified_phrase,
                              );
                            }
                          },
                    title: _isCurrentTabRated()
                        ? LocalizationHelper.tr.done
                        : (tabController.index == 0 &&
                                widget.item?.driver != null)
                            ? LocalizationHelper.tr.rate_driver
                            : ((tabController.index == 1 &&
                                        widget.item?.driver != null) ||
                                    (tabController.index == 0 &&
                                        widget.item?.driver == null))
                                ? LocalizationHelper.tr.rate_product
                                : LocalizationHelper.tr.rate_branch,
                  ),
                  20.ph,
                  TextButton(
                    onPressed: () {
                      NavigationHelper.pop();
                    },
                    child: Text(
                      LocalizationHelper.tr.skip_all_ratings,
                      style: TextStyles.font16BlackRegular.copyWith(
                        color: LightThemeColors.textPrimary,
                      ),
                    ),
                  ),
                  50.ph,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
//  Text(
//                       LocalizationHelper.tr.driver_rating,
//                       style: TextStyles.font16BlackSemiBold.copyWith(
//                         color: LightThemeColors.primary,
//                       ),
//                     ),
//                     25.ph,
//                     Row(
//                       children: [
//                         Container(
//                           width: 60,
//                           height: 60,
//                           decoration:
//                               const BoxDecoration(shape: BoxShape.circle),
//                           child: ClipOval(
//                             child: Image.asset(
//                                                  ImgAssets.onboardingImage,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         10.pw,
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Aleey ",
//                               style: TextStyles.font14BlackBold.copyWith(
//                                 color: LightThemeColors.primary,
//                                 fontWeight: FontWeights.semiBold,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             4.ph,
//                             Text(
//                               "Drive - BMW i8",
//                               style: TextStyles.font14BlackBold.copyWith(
//                                 color: LightThemeColors.grey,
//                                 fontWeight: FontWeights.regular,
//                                 fontSize: 12,
//                               ),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                     15.ph,
//                     const CustomRatingWidget(
//                       starCount: 5,
//                     ),
//                     25.ph,
//                     Text(
//                       "Rating branch",
//                       style: TextStyles.font16BlackSemiBold.copyWith(
//                         color: LightThemeColors.primary,
//                       ),
//                     ),
//                     15.ph,
//                     SearchProductWidget(
//                       branch: BranchModel(),
//                     ),
//                     15.ph,
//                     const CustomRatingWidget(
//                       starCount: 5,
//                     ),
//                     25.ph,
//                     Text(
//                       "Rating branch",
//                       style: TextStyles.font16BlackSemiBold.copyWith(
//                         color: LightThemeColors.primary,
//                       ),
//                     ),
//                     25.ph,
//                     const ProductWidget(),
//                     15.ph,
//                     const CustomRatingWidget(
//                       starCount: 5,
//                     ),
//                     15.ph,
//                     TextFormFieldWidget(
//                       maxLines: 6,
//                       minLines: 6,
//                       hintText: "Your comment...",
//                       backgroundColor: LightThemeColors.darkwhite,
//                       borderColor: Colors.transparent,
//                     ),
//                     16.ph,
//                     const PropertyWidget(
//                       withtitile: false,
//                     ),
//                     15.ph,
//                     Row(
//                       children: [
//                         const Expanded(
//                             child: ButtonWidget(
//                           title: LocalizationHelper.tr.skip,
//                           buttonColor: LightThemeColors.orange,
//                         )),
//                         10.pw,
//                         Expanded(
//                           child: ButtonWidget(
//                             title: "Submit",
//                             onTap: () {
//                               Alerts.bottomSheet(
//                                 context,
//                                 child: const RatingSuccessDialogebody(),
//                               );
//                             },
//                           ),
//                         )
//                       ],
//                     ),
//                     74.ph,
