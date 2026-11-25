import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/extensions/all_extensions.dart';
import '../../../../core/utils/extentions.dart';
import '../../../../core/general/cubit/general_cubit.dart';
import '../../cubit/layout_cubit.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  final Function(int)? onTap;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      decoration: BoxDecoration(
        color: context.background,
        border: Border(
          top: BorderSide(
            color: LightThemeColors.black.withValues(alpha: 0.13),
            width: 2,
          ),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavBarItem(path: SvgAssets.home,      title: LocalizationHelper.tr.home,     index: 0),
          _NavBarItem(path: SvgAssets.cart,      title: LocalizationHelper.tr.cart,     index: 1, isCart: true),
          _NavBarItem(path: SvgAssets.order,     title: LocalizationHelper.tr.order,    index: 2),
          _NavBarItem(path: SvgAssets.favourite, title: LocalizationHelper.tr.favorite, index: 3),
          _NavBarItem(path: SvgAssets.profile,   title: LocalizationHelper.tr.profile,  index: 4),
        ],
      ),
    );
  }
}

// ✅ Isolated widget — BlocBuilder lives here, never inside _NavBarItem
class _CartIcon extends StatelessWidget {
  const _CartIcon({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneralCubit, GeneralState>(
      builder: (context, state) {
        final count = GeneralCubit.get(context).cartItemsCount;

        // ✅ Icon is built fresh INSIDE the builder, never captured from outside
        final icon = SvgPicture.asset(
          SvgAssets.cart,
          width: isActive ? 27 : 25,
          height: isActive ? 27 : 25,
          colorFilter: ColorFilter.mode(
            isActive ? LightThemeColors.primary : LightThemeColors.lightgrey,
            BlendMode.srcIn,
          ),
        );

        if (count > 0) {
          return Badge(
            label: Text(count.toString()),
            backgroundColor: LightThemeColors.primary,
            child: icon,
          );
        }
        return icon;
      },
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.path,
    required this.title,
    required this.index,
    this.isCart = false,
  });

  final String path;
  final String title;
  final int index;
  final bool isCart;

  @override
  Widget build(BuildContext context) {
    final bool isActive =
        context.read<LayoutCubit>().tabController.index == index;

    return Expanded(
      child: Center(
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => context.read<LayoutCubit>().changeTab(index),
          child: SizedBox(
            width: 70,
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✅ No variable reassignment — clean conditional
                if (isCart)
                  _CartIcon(isActive: isActive)
                else
                  SvgPicture.asset(
                    path,
                    width: isActive ? 27 : 25,
                    height: isActive ? 27 : 25,
                    colorFilter: ColorFilter.mode(
                      isActive
                          ? LightThemeColors.primary
                          : LightThemeColors.lightgrey,
                      BlendMode.srcIn,
                    ),
                  ),
                6.ph,
                Text(
                  title,
                  style: context.bodySmall?.copyWith(
                    color: isActive
                        ? LightThemeColors.primary
                        : context.tertiaryColor,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}