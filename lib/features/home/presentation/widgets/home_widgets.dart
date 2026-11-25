import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/extensions/widget_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/home/cubit/home_cubit.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/home/domain/request/filter_request.dart';
import 'package:getincoffee/features/home/presentation/widgets/deleivry_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/font_manager.dart';
import '../../../../core/theme/light_theme.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({
    super.key,
    this.tabController,
    this.cubit,
    this.searchController,
    this.vsync,
    this.onChanged,
  });
  final TabController? tabController;
  final HomeCubit? cubit;
  final TextEditingController? searchController;
  final TickerProviderStateMixin? vsync;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 6,
          child: Container(
            height: 48,
            // width: 230,
            padding: const EdgeInsets.symmetric(
              vertical: 0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                40,
              ),
              color: LightThemeColors.darkwhite,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                20.pw,
                Row(
                  children: [
                    Text(
                      LocalizationHelper.tr.branches,
                      style: TextStyles.font12BlackBold.copyWith(
                        fontWeight: FontWeights.regular,
                        fontSize: 10,
                      ),
                    ),
                    2.pw,
                    Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          SvgAssets.arrowDown,
                        ),
                      ),
                    )
                  ],
                ).onTap(() {
                  cubit?.searchBranch(
                    context,
                    vsync: vsync!,
                    filter: true,
                    withpop: false,
                  );
                }),
                8.pw,
                Container(
                  width: 1,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: LightThemeColors.black,
                  ),
                ),
                4.pw,
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      SvgAssets.filterHomeIcon,
                      colorFilter: const ColorFilter.mode(
                        LightThemeColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ).onTap(() async {
                  // final res =
                  await Navigator.pushNamed(
                    context,
                    Routes.FilterScreen,
                    arguments: FilterScreenArgs(
                      categories: cubit?.categories ?? [],
                      productFilter: cubit?.productFilter ?? ProductFilter(),
                      values: RangeValues(
                        cubit?.homemodel.minPrice?.toDouble() ?? 0,
                        cubit?.homemodel.maxPrice?.toDouble() ?? 100,
                      ),
                    ),
                  ).then((e) {
                    if (e != null) {
                      cubit?.changeProductFilter(e as ProductFilter);
                    }
                  });
                  // if (res != null) {
                  //  cubit?.getBranchcategories();
                  // }
                }),
                8.pw,
                Expanded(
                    child: TextFormField(
                  //controller: searchController,
                  onChanged: onChanged,
                  style: TextStyles.font12BlackBold.copyWith(
                    fontWeight: FontWeights.regular,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        LocalizationHelper.tr.search_your_coffee_sweets,
                        style: TextStyles.font12BlackBold.copyWith(
                          fontWeight: FontWeights.regular,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    // hintText: LocalizationHelper.tr.search_your_coffee_sweets,
                    hintStyle: TextStyles.font12BlackBold.copyWith(
                      fontWeight: FontWeights.regular,
                      fontSize: 10,
                    ),
                    contentPadding: const EdgeInsets.only(
                      bottom: 16,
                    ),
                  ),
                )),
                /*  Text(
                  LocalizationHelper.tr.search_your_coffee_sweets,
                  style: TextStyles.font12BlackBold.copyWith(
                    fontWeight: FontWeights.regular,
                    fontSize: 10,
                  ),
                ).onTap(() {
                  Alerts.bottomSheet(
                    context,
                    child: const SearchBottomSheet(),
                  );
                }) */
              ],
            ),
          ),
        ),
        const DeliveryToggle(),
      ],
    );
  }
}

class TitleAndFollowWidget extends StatelessWidget {
  const TitleAndFollowWidget({super.key, this.cubit});
  final HomeCubit? cubit;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "${(cubit?.currentBranch?.name ?? "") * 1} (${(cubit?.currentBranch?.description ?? "") * 1})",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font20WhiteSemiBold.copyWith(
              fontWeight: FontWeights.bold,
              fontSize: 18,
              color: LightThemeColors.primary,
            ),
          ),
        ),
        /*    ButtonWidget(
          onTap: () {
            if (cubit?.currentBranch?.followed ?? true) {
              cubit?.unfollowBranchtoUser();
            } else {
              cubit?.followBranch();
            }
          },
          fontSize: 12,
          height: 35,
          width: 70,
          buttonColor: cubit?.currentBranch?.followed ?? true
              ? LightThemeColors.primary
              : LightThemeColors.black,
          title: cubit?.currentBranch?.followed ?? true
              ? LocalizationHelper.tr.unfollow
              : LocalizationHelper.tr.follow,
          fontweight: FontWeights.semiBold,
        )
     */
      ],
    );
  }
}

class BranchDetailsWidget extends StatelessWidget {
  const BranchDetailsWidget({super.key, this.branch});
  final BranchModel? branch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          SvgAssets.Star,
        ),
        2.pw,
        Text(
          branch?.averageRating ?? LocalizationHelper.tr.unspecified_phrase,
          style: TextStyles.font12BlackBold.copyWith(
            fontWeight: FontWeights.regular,
          ),
        ),
        3.pw,
        Text(
          "(${branch?.totalRating ?? LocalizationHelper.tr.unspecified_phrase})",
          style: TextStyles.font12BlackBold.copyWith(
            fontWeight: FontWeights.regular,
          ),
        ),
        10.pw,
        Container(
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            color: LightThemeColors.lightgrey,
            shape: BoxShape.circle,
          ),
        ),
        6.pw,
        Text(
          "${branch?.scopeWork ?? ""} ",
          style: TextStyles.font12BlackBold.copyWith(
            fontWeight: FontWeights.regular,
          ),
        ),
        10.pw,
        Container(
          width: 1,
          height: 10,
          decoration: const BoxDecoration(
            color: LightThemeColors.lightgrey,
            // shape: BoxShape.circle,
          ),
        ),
        10.pw,
      
        branch?.workingTime() ?? const SizedBox.shrink(),
        10.pw,
        Container(
          width: 1,
          height: 10,
          decoration: const BoxDecoration(
            color: LightThemeColors.lightgrey,
            // shape: BoxShape.circle,
          ),
        ),
        10.pw,
        SvgPicture.asset(
          SvgAssets.motor,
        ),
        5.pw,
        Text(
          branch?.deliveryTime ?? LocalizationHelper.tr.unspecified_phrase,
          style: TextStyles.font12BlackBold.copyWith(
            fontWeight: FontWeights.regular,
          ),
        ),
        // Text(
        //   "Open Now",
        //   style: TextStyles.font12BlackBold.copyWith(
        //     fontWeight: FontWeights.regular,
        //   ),
        // ),
      ],
    );
  }
}
