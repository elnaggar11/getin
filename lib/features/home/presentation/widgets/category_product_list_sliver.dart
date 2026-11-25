import 'package:flutter/material.dart';
import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/Router/navigation_helper.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/home/cubit/home_cubit.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/shared/widgets/default_image_widget.dart';
import 'product_widget.dart';

class CategoryProductListSliver extends StatelessWidget {
  const CategoryProductListSliver({
    super.key,
    required this.cubit,
    required this.searchController,
    required this.controller,
    required this.isSchedule,
  });

  final HomeCubit cubit;
  final TextEditingController searchController;
  final AutoScrollController controller;
  final bool isSchedule;

  @override
  Widget build(BuildContext context) {
    var res =
        cubit.homemodel.getproductcategorylist(title: searchController.text);
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      sliver: SliverList.separated(
        itemBuilder: (context, index) {
          if (res[index].type == ProductCategoryListenum.category) {
            var item = (res[index].item as BranchCategory);

            return AutoScrollTag(
              key: ValueKey(index),
              controller: controller,
              index: index,
              child: Column(
                key: ValueKey("C_${item.id}"),
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        //  horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        item.name ?? LocalizationHelper.tr.unspecified_phrase,
                        style: TextStyles.font16BlackBold.copyWith(
                          color: LightThemeColors.primary,
                          fontWeight: FontWeights.semiBold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        40,
                      ),
                    ),
                    constraints: const BoxConstraints(
                      maxHeight: 45,
                    ),
                    //height: 40,
                    width: MediaQuery.sizeOf(context).width,
                    child: AspectRatio(
                      aspectRatio: 10 / 1,
                      child: DefaultImageWidget(item.image ?? "",
                          radius: 40, fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
            );
          } else {
            var item = (res[index].item as ProductModel);
            return AutoScrollTag(
              key: ValueKey(index),
              controller: controller,
              index: index,
              child: ProductWidget(
                showStar: true,
                showAddButton: true,
                add: (p0) {
                  if (item.hasOptions ?? false) {
                    Navigator.pushNamed(
                      context,
                      Routes.ProductdetailsScreen,
                      arguments: ProductDetailsargs(
                          id: item.id ??
                              LocalizationHelper.tr.unspecified_phrase,
                          branchId: cubit.homemodel.branch?.id ??
                              LocalizationHelper.tr.unspecified_phrase,
                          isSchedule: isSchedule ),
                    );

                    return;
                  }
                  cubit.request.branchId = cubit.homemodel.branch?.id ??
                      LocalizationHelper.tr.unspecified_phrase;
                  cubit.request.product = item;
                  cubit.request.optionValueIds = [];
                  cubit.request.productId = item.id;
                  cubit.request.quantity = p0.toString();
                  if (isSchedule) {
                    NavigationHelper.pop(result: cubit.request);
                  } else {
                    cubit.addtoCart();
                  }
                },
                product: item,
                isSchedule: isSchedule,
                branchId: cubit.homemodel.branch?.id ??
                    LocalizationHelper.tr.unspecified_phrase,
              ),
            );
          }
          // Unreachable code in original, but good to keep for safety if logic changes
          // return const SizedBox();
        },
        separatorBuilder: (BuildContext context, int index) {
          return 10.ph;
        },
        itemCount: res.length,
      ),
    );
  }
}
