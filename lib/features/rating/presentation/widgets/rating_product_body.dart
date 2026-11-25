import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/myorder/domain/model/myorder_model.dart';
import 'package:getincoffee/shared/widgets/default_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/font_manager.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import '../../../../shared/widgets/rating_widget.dart';

class RatingProductBody extends StatelessWidget {
  const RatingProductBody({
    super.key,
    this.controlelr,
    this.onchange,
    this.products,
  });
  final TextEditingController? controlelr;
  final List<OrderItemModel>? products;
  final Function(double)? onchange;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...List.generate(products!.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RatingProductWidget(
                product: products![index],
              ),
            );
          }),
          15.ph,
          /*   Align(
            alignment: Alignment.topLeft,
            child: Text(
              LocalizationHelper.tr.driver_rating,
              style: TextStyles.font16BlackSemiBold.copyWith(
                color: LightThemeColors.primary,
              ),
            ),
          ),
          15.ph,
          CustomRatingWidget(
            onChange: onchange,
            starCount: 5,
          ), */
          15.ph,
          TextFormFieldWidget(
            controller: controlelr,
            maxLines: 6,
            minLines: 6,
            hintText: LocalizationHelper.tr.your_comment,
            backgroundColor: LightThemeColors.darkwhite,
            borderColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class RatingProductWidget extends StatelessWidget {
  const RatingProductWidget({
    super.key,
    required this.product, // خليناها required عشان نضمن إنها مش null
  });

  // ★★★★★ النوع هنا BranchModel وليس BranchModel? ★★★★★
  final OrderItemModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: LightThemeColors.darkwhite,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- الجزء الأيسر: الصورة والبيانات ---
              Expanded(
                // استخدم Expanded عشان تمنع أي overflow لو النص طويل
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    // الصورة
                    SizedBox(
                      width: 75,
                      height: 75,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: DefaultImageWidget(
                          product.image ??
                              LocalizationHelper.tr
                                  .unspecified_phrase, //   branch.image ?? LocalizationHelper.tr.unspecified_phrase, // استخدم branch مباشرة
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // البيانات (الاسم والتقييم والمسافة)
                    Expanded(
                      // استخدم Expanded هنا كمان عشان النص ياخد راحته
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // الاسم
                          Text(
                            product.product_name ??
                                LocalizationHelper
                                    .tr.no_name, // حماية من الـ null
                            style: TextStyles.font12BlackBold.copyWith(
                              color: LightThemeColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeights.extraBold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          // الوصف
                          Text(
                            product.product_desc ??
                                LocalizationHelper
                                    .tr.no_description, // حماية من الـ null
                            style: TextStyles.font12BlackBold.copyWith(
                              fontWeight: FontWeights.regular,
                              color: LightThemeColors.lightgrey,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          // التقييم والمسافة
                          Row(
                            children: [
                              SvgPicture.asset(SvgAssets.Star),
                              const SizedBox(width: 2),
                              Text(
                                product.ratingAvg?.toString() ?? "0.0",
                                style: TextStyles.font12BlackBold.copyWith(
                                  fontWeight: FontWeights.regular,
                                ),
                              ),
                              const SizedBox(width: 5),
                              /*    Text(
                                "(${branch.reationCounts ?? "0"}+)",
                                style: TextStyles.font12BlackBold.copyWith(
                                  fontWeight: FontWeights.regular,
                                  color: LightThemeColors.grey,
                                ),
                              ), */
                              const SizedBox(width: 6),
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: LightThemeColors.lightgrey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              /*  Text(
                                "${branch.scopeWork ?? "0"} Km",
                                style: TextStyles.font12BlackBold.copyWith(
                                  fontWeight: FontWeights.regular,
                                ),
                              ), */
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // --- الجزء الأيمن: زرار السهم ---
            ],
          ),
        ),
        const SizedBox(height: 15),
        CustomRatingWidget(
          initialValue: product.userRate ?? 0.0,
          onChange: (value) {
            product.userRate = value;
          },
          starCount: 5,
        ),
      ],
    );
  }
}
