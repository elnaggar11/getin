import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/features/home/cubit/home_cubit.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/home/presentation/widgets/tab_bar_widget.dart';

class HomeStickyTabBar extends StatelessWidget {
  const HomeStickyTabBar({
    super.key,
    required this.cubit,
    required this.controller,
    required this.searchController,
    required this.onTabClicked,
  });

  final HomeCubit cubit;
  final AutoScrollController controller;
  final TextEditingController searchController;
  final Function(bool) onTabClicked;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      toolbarHeight: 50,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: LightThemeColors.grey.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
              top: 6.5, bottom: 5, start: 14, end: 0),
          child: TabBarWidget(
            onchange: (index) {
              if (index == 0) {
                cubit.params.category_id = null;
                cubit.params.is_new = "1";
                cubit.params.is_top_rated = "0";
                controller.scrollToIndex(-2,
                    preferPosition: AutoScrollPosition.begin);
              } else if (index == 1) {
                controller.scrollToIndex(-1,
                    preferPosition: AutoScrollPosition.begin);
              } else {
                final categoryId = cubit.categories[index - 2].id;

                onTabClicked(true);
                var list = cubit.homemodel
                    .getproductcategorylist(title: searchController.text);
                var targetIndex = list.indexWhere((element) =>
                    element.type == ProductCategoryListenum.category &&
                    (element.item as BranchCategory).id == categoryId);
                if (targetIndex != -1) {
                  controller
                      .scrollToIndex(targetIndex,
                          preferPosition: AutoScrollPosition.begin)
                      .then((_) {
                    Future.delayed(const Duration(milliseconds: 600), () {
                      onTabClicked(false);
                    });
                  });
                } else {
                  onTabClicked(false);
                }
              }

              print(index);
            },
            categories: cubit.categories,
            secondtabController: cubit.secondtabController,
            viewAll: (cubit.homemodel.newproducts?.isNotEmpty ?? false),
          ),
        ),
      ),
    );
  }
}
