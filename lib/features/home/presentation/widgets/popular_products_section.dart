import 'package:flutter/material.dart';
import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/Router/navigation_helper.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/home/cubit/home_cubit.dart';
import 'package:getincoffee/features/home/presentation/widgets/product_widget.dart';

class PopularProductsSection extends StatelessWidget {
  const PopularProductsSection({
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
    if (cubit.homemodel.popularproducts?.isEmpty ?? true) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: Text(
              LocalizationHelper.tr.popular,
              style: TextStyles.font16BlackBold.copyWith(
                color: LightThemeColors.primary,
                fontWeight: FontWeights.regular,
              ),
            ),
          ),
        ),
        10.ph,
        SizedBox(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            separatorBuilder: (context, index) => 10.ph,
            itemCount: cubit.homemodel
                    .filterpopularproducts(searchController.text)
                    ?.length ??
                0,
            itemBuilder: (context, index) => ProductWidget(
              showAddButton: true,
              showStar: true,
              isSchedule: isSchedule,
              add: (p0) {
                final item = cubit.homemodel
                    .filterpopularproducts(searchController.text)?[index];
                if (item?.hasOptions ?? false) {
                  Navigator.pushNamed(
                    context,
                    Routes.ProductdetailsScreen,
                    arguments: ProductDetailsargs(
                        id: item?.id ??
                            LocalizationHelper.tr.unspecified_phrase,
                        branchId: cubit.homemodel.branch?.id ??
                            LocalizationHelper.tr.unspecified_phrase,
                        isSchedule: isSchedule),
                  );
                  return;
                }
                cubit.request.branchId = cubit.homemodel.branch?.id ??
                    LocalizationHelper.tr.unspecified_phrase;
                cubit.request.product = cubit.homemodel
                    .filterpopularproducts(searchController.text)?[index];

                cubit.request.optionValueIds = [];
                cubit.request.productId = cubit.homemodel
                    .filterpopularproducts(searchController.text)?[index]
                    .id;
                cubit.request.quantity = p0.toString();
                if (isSchedule) {
                  NavigationHelper.pop(result: cubit.request);
                } else {
                  cubit.addtoCart();
                }
              },
              decrease: (p0) {
                cubit.request.branchId = cubit.homemodel.branch?.id ??
                    LocalizationHelper.tr.unspecified_phrase;
                cubit.request.optionValueIds = [];
                cubit.request.productId = cubit.homemodel
                    .filterpopularproducts(searchController.text)?[index]
                    .id;
                cubit.request.quantity = p0.toString();
                cubit.addtoCart();
              },
              product: cubit.homemodel
                  .filterpopularproducts(searchController.text)?[index],
              branchId: cubit.homemodel.branch?.id ??
                  LocalizationHelper.tr.unspecified_phrase,
            ),
          ),
        ),
      ]),
    );
  }
}
