import 'package:flutter/material.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/home/cubit/home_cubit.dart';
import 'package:getincoffee/features/home/presentation/widgets/home_widgets.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({
    super.key,
    required this.cubit,
    required this.tabController,
    required this.vsync,
    required this.searchController,
    required this.onSearchChanged,
  });

  final HomeCubit cubit;
  final TabController tabController;
  final TickerProviderStateMixin vsync;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            FilterWidget(
              cubit: cubit,
              tabController: tabController,
              vsync: vsync,
              searchController: searchController,
              onChanged: onSearchChanged,
            ),
            10.ph,
            TitleAndFollowWidget(cubit: cubit),
            10.ph,
            BranchDetailsWidget(branch: cubit.homemodel.branch),
          ],
        ),
      ),
    );
  }
}
