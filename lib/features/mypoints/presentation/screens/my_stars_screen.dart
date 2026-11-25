import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/extensions/widget_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/mypoints/domain/model/my_star_model/order.dart';
import 'package:getincoffee/features/mypoints/presentation/screens/mypoints_screen.dart';
import 'package:getincoffee/shared/back_widget.dart';
import 'package:getincoffee/shared/widgets/default_image_widget.dart';
import 'package:getincoffee/shared/widgets/loadinganderror.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/font_manager.dart'
    show FontWeights, TextStyles;
import '../../cubit/mypoints_cubit.dart';
import '../../cubit/mypoints_states.dart';

class MyStarsScreen extends StatefulWidget {
  const MyStarsScreen({super.key});

  @override
  State<MyStarsScreen> createState() => _MypointsScreenState();
}

class _MypointsScreenState extends State<MyStarsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MypointsCubit()..getMyStar(),
      child: BlocConsumer<MypointsCubit, MypointsStates>(
        listener: (context, state) {
          if (state is GetAllRanksSuccess) {
            Navigator.pushNamed(context, Routes.StarCardDetailsScreen,
                arguments: state.ranksListModel);
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
                      LocalizationHelper.tr.my_rewards_stars,
                      style: const TextStyle(
                        color: LightThemeColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Expanded(
                  //   flex: 2,
                  //   child: ButtonWidget(
                  //     fontSize: 12,
                  //     height: 34,
                  //     title: "Buy points",
                  //     buttonColor: LightThemeColors.black,
                  //   ),
                  // )
                ],
              ),
            ),
            body: LoadingAndError(
              isLoading: state is MypointsLoading,
              isError: state is MypointsError,
              function: () {
                cubit.getMyStar();
              },
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
                                const DefaultImageWidget(
                                  SvgAssets.TicketStar,
                                ),
                                16.ph,
                                Text(
                                  LocalizationHelper.tr.total_stars,
                                  style: TextStyles.font16BlackRegular.copyWith(
                                    fontWeight: FontWeights.regular,
                                    color: LightThemeColors.grey,
                                    fontSize: 18,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              cubit.myStarModel?.userStars ?? "11.596",
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: LightThemeColors.cardBackground,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 70,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              cubit.myStarModel?.currentRank
                                                      ?.image ??
                                                  "",
                                            ),
                                          ),
                                        ),
                                        child: DefaultImageWidget(
                                          cubit.myStarModel?.currentRank
                                                  ?.image ??
                                              "",
                                          isCircle: false,
                                          radius: 12,
                                        ),
                                      ).onTap(() {
                                        cubit.getAllRanks(
                                          cubit.myStarModel?.currentRank?.id ??
                                              0,
                                        );
                                        /* Navigator.pushNamed(
                                          context,
                                          Routes.StarCardDetailsScreen,
                                          arguments: cubit
                                              .myStarModel?.currentRank?.id,
                                        ); */
                                      }),
                                      4.ph,
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Row(
                                          children: [
                                            Text(
                                              "${LocalizationHelper.tr.points} * ${cubit.myStarModel?.currentRank?.pointsIncrement ?? LocalizationHelper.tr.unspecified_phrase}",
                                              style: TextStyles.font12BlackBold
                                                  .copyWith(
                                                      fontSize: 10,
                                                      color:
                                                          LightThemeColors.grey,
                                                      fontWeight:
                                                          FontWeights.regular),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "${LocalizationHelper.tr.stars} * ${cubit.myStarModel?.currentRank?.starsIncrement ?? LocalizationHelper.tr.unspecified_phrase}",
                                              style: TextStyles.font12BlackBold
                                                  .copyWith(
                                                      fontSize: 10,
                                                      color:
                                                          LightThemeColors.grey,
                                                      fontWeight:
                                                          FontWeights.regular),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          6,
                                        ),
                                        color: Colors.transparent),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 70,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: DefaultImageWidget(
                                          cubit.myStarModel?.nextRank?.image ??
                                              "",
                                          isCircle: false,
                                          radius: 12,
                                        ),
                                      ).onTap(() {
                                        cubit.getAllRanks(
                                          cubit.myStarModel?.nextRank?.id ?? 0,
                                        );
                                      }),
                                      4.ph,
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Row(
                                          children: [
                                            Text(
                                              "${LocalizationHelper.tr.points} * ${cubit.myStarModel?.nextRank?.pointsIncrement ?? LocalizationHelper.tr.unspecified_phrase}",
                                              style: TextStyles.font12BlackBold
                                                  .copyWith(
                                                      fontSize: 10,
                                                      color:
                                                          LightThemeColors.grey,
                                                      fontWeight:
                                                          FontWeights.regular),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "${LocalizationHelper.tr.stars} * ${cubit.myStarModel?.nextRank?.starsIncrement ?? LocalizationHelper.tr.unspecified_phrase}",
                                              style: TextStyles.font12BlackBold
                                                  .copyWith(
                                                      fontSize: 10,
                                                      color:
                                                          LightThemeColors.grey,
                                                      fontWeight:
                                                          FontWeights.regular),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            7.ph,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      cubit.myStarModel?.currentRank
                                              ?.minStars ??
                                          "39.507",
                                      style: TextStyles.font14BlackBold
                                          .copyWith(
                                              fontWeight: FontWeights.regular,
                                              color: LightThemeColors.grey),
                                    ),
                                    4.ph,
                                    Text(
                                      cubit.myStarModel?.currentRank?.name ??
                                          LocalizationHelper
                                              .tr.classic_plus_tier,
                                      style: TextStyles.font14BlackBold
                                          .copyWith(
                                              fontWeight: FontWeights.regular,
                                              fontSize: 10,
                                              color: LightThemeColors.grey),
                                    ),
                                  ],
                                ),
                                const Icon(
                                  Icons.arrow_forward,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      cubit.myStarModel?.nextRank?.minStars ??
                                          "39.507",
                                      style: TextStyles.font14BlackBold
                                          .copyWith(
                                              fontWeight: FontWeights.regular,
                                              color: LightThemeColors.grey),
                                    ),
                                    4.ph,
                                    Text(
                                      cubit.myStarModel?.nextRank?.name ??
                                          LocalizationHelper
                                              .tr.classic_plus_tier,
                                      style: TextStyles.font14BlackBold
                                          .copyWith(
                                              fontWeight: FontWeights.regular,
                                              fontSize: 10,
                                              color: LightThemeColors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            10.ph,
                            Container(
                              width: 400,
                              height: 14,
                              decoration: BoxDecoration(
                                color: LightThemeColors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: ((double.parse(
                                            cubit.myStarModel?.userStars ??
                                                "0.0"))) /
                                        (double.parse(cubit.myStarModel
                                                ?.nextRank?.minStars ??
                                            "1.0")) *
                                        400,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: LightThemeColors.primary,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
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
                        child: Column(
                          children: List.generate(
                            cubit.myStarModel?.orders?.length ?? 0,
                            (i) => DealItem(
                              points: LocalizationHelper.tr.stars,
                              name: "stars",
                              order:
                                  cubit.myStarModel?.orders?[i] ?? StarOrder(),
                            ),
                          ),
                        ),
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
