import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/cart/presentation/screens/trackorder/widgets/dashed_vertical_line.dart';

class TrackItem extends StatelessWidget {
  const TrackItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isDone,
    required this.isLast,
    this.isCanceled = false,
  });

  final String icon;
  final String title;
  final bool isDone;
  final bool isLast;
  final bool isCanceled;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TrackItemStatusColumn(
            icon: icon, isDone: isDone, isLast: isLast, isCanceled: isCanceled),
        6.pw,
        TrackItemInfoColumn(
            title: title, isDone: isDone, isCanceled: isCanceled),
      ],
    );
  }
}

class TrackItemStatusColumn extends StatelessWidget {
  const TrackItemStatusColumn({
    super.key,
    required this.icon,
    required this.isDone,
    required this.isLast,
    this.isCanceled = false,
  });

  final String icon;
  final bool isDone;
  final bool isLast;
  final bool isCanceled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TrackItemStatusIcon(icon: icon, isDone: isDone, isCanceled: isCanceled),
        8.ph,
        if (!isLast) const DashedVerticalLine(height: 40),
      ],
    );
  }
}

class TrackItemStatusIcon extends StatelessWidget {
  const TrackItemStatusIcon({
    super.key,
    required this.icon,
    required this.isDone,
    this.isCanceled = false,
  });

  final String icon;
  final bool isDone;
  final bool isCanceled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCanceled
            ? LightThemeColors.error
            : (isDone ? LightThemeColors.primary : LightThemeColors.grey),
      ),
      child: Center(
        child: SvgPicture.asset(
          icon,
          colorFilter: isCanceled
              ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
              : null,
        ),
      ),
    );
  }
}

class TrackItemInfoColumn extends StatelessWidget {
  const TrackItemInfoColumn({
    super.key,
    required this.title,
    required this.isDone,
    this.isCanceled = false,
  });

  final String title;
  final bool isDone;
  final bool isCanceled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.font14BlackMedium.copyWith(
            color: LightThemeColors.primary,
          ),
        ),
        Text(
          isCanceled
              ? LocalizationHelper.tr.cancelled
              : (isDone
                  ? LocalizationHelper.tr.status_done
                  : LocalizationHelper.tr.status_in_progress),
          style: TextStyles.font12BlackBold.copyWith(
            color: isCanceled
                ? LightThemeColors.error
                : (isDone ? LightThemeColors.green : LightThemeColors.grey),
            fontWeight: FontWeights.semiBold,
          ),
        ),
      ],
    );
  }
}
