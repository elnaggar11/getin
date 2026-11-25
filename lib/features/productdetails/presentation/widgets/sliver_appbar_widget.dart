import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;

import '../../../../core/resources/font_manager.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../home/domain/model/home_model.dart';
import '../screens/productdetails_screen.dart';

class SliverAppbarWidget extends StatefulWidget {
  const SliverAppbarWidget(
      {super.key, this.productdetails, this.branchId, this.refresh});
  final ProductModel? productdetails;
  final String? branchId;
  final VoidCallback? refresh;

  @override
  State<SliverAppbarWidget> createState() => _SliverAppbarWidgetState();
}

class _SliverAppbarWidgetState extends State<SliverAppbarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ), // Add desired horizontal padding here
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                // flex: 2,
                child: Text(
                  (widget.productdetails?.name ?? "") * 1,
                  maxLines: 7,
                  style: TextStyles.font20WhiteSemiBold.copyWith(
                    color: LightThemeColors.white,
                    fontWeight: FontWeights.medium,
                    fontSize: 22,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              8.pw,
              SizedBox(
                width: 50,
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: FavoriteIcon(
                    refresh: widget.refresh,
                    branchId: widget.branchId,
                    isFavorite: widget.productdetails?.isLiked,
                    favourite_id: widget.productdetails?.favourite_id,
                    id: widget.productdetails?.id ??
                        LocalizationHelper.tr.unspecified_phrase,
                    color: LightThemeColors.gold,
                  ),
                ),
              ),
            ],
          ),
          6.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      SvgAssets.Star,
                    ),
                    2.pw,
                    Text(
                      widget.productdetails?.rating_avg ??
                          LocalizationHelper.tr.unspecified_phrase,
                      style: TextStyles.font12BlackBold.copyWith(
                        fontWeight: FontWeights.regular,
                        color: LightThemeColors.white,
                      ),
                    ),
                    5.pw,
                    Text(
                      "(${widget.productdetails?.revies_count})",
                      style: TextStyles.font12BlackBold.copyWith(
                        fontWeight: FontWeights.regular,
                        color: LightThemeColors.white,
                      ),
                    ),
                    6.pw,
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
                      widget.productdetails?.delivery_time ??
                          LocalizationHelper.tr.unspecified_phrase,
                      style: TextStyles.font12BlackBold.copyWith(
                        fontWeight: FontWeights.regular,
                        color: LightThemeColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              8.pw,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        width: 1,
                        color: LightThemeColors.white,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "+${widget.productdetails?.stars}",
                          style: TextStyles.font12BlackBold.copyWith(
                            fontWeight: FontWeights.regular,
                            color: LightThemeColors.yellow,
                          ),
                        ),
                        3.pw,
                        SvgPicture.asset(
                          SvgAssets.Star,
                        ),
                      ],
                    ),
                  ),
                  10.pw,
                  if (widget.productdetails?.points != null)
                    Text(
                      "${widget.productdetails?.points} ${LocalizationHelper.tr.points} ",
                      style: TextStyles.font12BlackBold.copyWith(
                        fontWeight: FontWeights.medium,
                        color: LightThemeColors.green,
                        fontSize: 10,
                      ),
                    ),
                ],
              )
            ],
          ),
          16.ph,
        ],
      ),
    );
  }
}
