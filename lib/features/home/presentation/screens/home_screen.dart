import 'dart:async';

import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/Router/navigation_helper.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/utils/utils.dart';
import 'package:getincoffee/features/home/presentation/widgets/product_widget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/home/presentation/widgets/bottom_sheet/branch_bottom_sheet.dart';
import 'package:getincoffee/features/home/presentation/widgets/maintain_branch.dart';
import 'package:getincoffee/features/home/presentation/widgets/screen_error.dart';

import 'package:getincoffee/shared/widgets/myLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/light_theme.dart';

import '../../cubit/home_cubit.dart';
import '../../cubit/home_states.dart';
import '../widgets/slider_widgets.dart';
import '../../../../core/general/cubit/general_cubit.dart';
import '../widgets/category_product_list_sliver.dart';
import '../widgets/home_header_section.dart';
import '../widgets/new_products_section.dart';
import '../widgets/popular_products_section.dart';
import '../widgets/home_sticky_tab_bar.dart';
import '../mixins/scroll_tab_sync_mixin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.withbottom = true,
    this.branch,
    this.canchangeBranch = true,
    this.isSchedule = false,
  });
  final bool? withbottom;
  final BranchModel? branch;
  final bool canchangeBranch;
  final bool isSchedule;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin,
        ScrollTabSyncMixin {
  int chossenNumber = 1;
  @override
  final TextEditingController searchController = TextEditingController();
  final AutoScrollController controller = AutoScrollController();
  final ValueNotifier<bool> showScrollToTop = ValueNotifier(false);

  @override
  AutoScrollController get scrollController => controller;

  bool _isTabClicked = false;
  @override
  bool get isTabClicked => _isTabClicked;
  @override
  set isTabClicked(bool value) => _isTabClicked = value;
  Timer? _debounceTimer;
  @override
  void initState() {
    super.initState();
    initScrollSync();
    controller.addListener(() {
      if (controller.offset > 200 && !showScrollToTop.value) {
        showScrollToTop.value = true;
      } else if (controller.offset <= 200 && showScrollToTop.value) {
        showScrollToTop.value = false;
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    showScrollToTop.dispose();
    disposeScrollSync();
    searchController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocListener<GeneralCubit, GeneralState>(
        listener: (context, state) {
          if (state is GeneralFavoriteUpdated) {
            HomeCubit.get(context).updateProductFavoriteStatus(
              state.productId,
              state.isLiked,
              state.favouriteId,
            );
          }
        },
        child: BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {
            final cubit = HomeCubit.get(context);
            if (state is BranchLoadedSuccess) {
              cubit.categories = state.categories;
              //   cubit.params.is_new = "0";
              cubit.params.category_id = null;
              HomeCubit.get(context).getproductsBycategories();
            }
            if (state is BranchBottomSheetState) {
              var cubit = HomeCubit.get(context);
              Alerts.bottomSheet(
                context,
                isdismissible: !cubit.isDismiss,
                close: (val) async {
                  /*    if (cubit.isDismiss) {
                    return false;
                  } */
                  if (val == null) {
                    return true;
                  } else {
                    cubit.currentBranch = val;
                    if (cubit.currentBranch?.isDelivery == false) {
                      GeneralCubit.get(context).updateDeliveryType(1);
                    }

                    cubit.branchId = (val as BranchModel).id ??
                        LocalizationHelper.tr.unspecified_phrase;
                    Utils.branchId = cubit.branchId;
                    cubit.getBranchcategories();
                    cubit.init(context,
                        vsync: this, withsheet: false, branch: val); // refresh
                    return true;
                  }
                },
                child: BlocProvider.value(
                  value: HomeCubit.get(context),
                  child: BranchBottomSheet(
                    images: state.homeSlider?.sliders
                            .map((e) =>
                                e.image ??
                                LocalizationHelper.tr.unspecified_phrase)
                            .toList() ??
                        [],
                    homeText: state.homeSlider?.texts
                            .map((e) =>
                                e.name ??
                                LocalizationHelper.tr.unspecified_phrase)
                            .toList() ??
                        [],
                    ontap: (val) async {
                      ///MARK: needed as followed
                      Navigator.pop(context, val);
                      cubit.currentBranch = val;
                      if (cubit.currentBranch?.isDelivery == false) {
                        GeneralCubit.get(context).updateDeliveryType(1);
                      }
                      cubit.branchId =
                          (val).id ?? LocalizationHelper.tr.unspecified_phrase;
                      Utils.branchId = cubit.branchId;
                      cubit.getBranchcategories();
                      cubit.init(context,
                          vsync: this,
                          withsheet: false,
                          branch: val); // refresh

                      //  NavigationHelper.pop(result: val);
                      /*  final saved = await saveBranchTouser(
                                  branchId: val.id,
                                  context: context,
                                );
                                if (saved == true) {
                                  Navigator.pop(context, currentBranch);
                                } */
                    },
                    branches: state.branch?.branches,
                    vsync: this,
                  ),
                ),
              );
            }
            if (state is ProductsLoadedSuccess) {
              cubit.homemodel = state.homeModel;
            }
            if (state is ProductsLoadedEmpty) {
              cubit.homemodel = HomeModel();
            }
/*         if (state is BranchChanges &&
            (cubit.currentBranch?.isDelivery == false || true)) { */
            if (state is HomeBranchChanges &&
                (cubit.currentBranch?.isDelivery == false)) {
              Alerts.snack(
                text: LocalizationHelper.tr.branch_pickup_only,
                state: SnackState.success,
              );
            }

            if (state is ProductsLoadedSuccess) {
              if (state.changeTab == true) {
                cubit.secondtabController = TabController(
                  length: cubit.categories.length + 2,
                  vsync: this,
                );
              }
            }
          },
          builder: (context, state) {
            final cubit = HomeCubit.get(context);
            if (state is ProductsLoading || state is HomeInitial) {
              return const Material(child: SmoothLoadingLogo());
            }
            if (state is ProductsLoadedEmpty) {
              return Material(
                child: BranchUnderMaintenance(onViewOtherBranches: () async {
                  if (widget.canchangeBranch == false) {
                    return;
                  }
                  await cubit.searchBranch(context,
                      vsync: this, withpop: false);
                }),
              );
            }
            if (state is ProductsLoadedError) {
              return Material(
                child: ScreenError(onRetry: () {
                  cubit.getproductsBycategories(changeTabbar: false);
                }),
              );
            }
            if (cubit.homemodel.branch == null) {
              return const Material(child: SmoothLoadingLogo());
            }
            return Scaffold(
              backgroundColor: LightThemeColors.white,
              floatingActionButton: ValueListenableBuilder<bool>(
                valueListenable: showScrollToTop,
                builder: (context, show, child) {
                  return AnimatedOpacity(
                    opacity: show ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: IgnorePointer(
                      ignoring: !show,
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: LightThemeColors.primary,
                        onPressed: () {
                          controller.animateTo(0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        },
                        child: const Icon(Icons.keyboard_arrow_up,
                            color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
              body: SafeArea(
                child: CustomScrollView(
                  controller: controller,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  slivers: [
                    if (cubit.homemodel.branch?.images?.isNotEmpty ?? false)
                      SliderWidgets(
                        myaspecRatio: 450 / 200,
                        images: (cubit.homemodel.branch?.images ?? []),
                      ).SliverBox,
                    10.ph.SliverBox,
                    HomeHeaderSection(
                      cubit: cubit,
                      tabController: cubit.tabController,
                      vsync: this,
                      searchController: searchController,
                      onSearchChanged: (value) {
                        _debounceTimer?.cancel();

                        _debounceTimer =
                            Timer(const Duration(milliseconds: 600), () {
                          cubit.searchByName(value);
                        });
                      },
                    ),
                    10.ph.SliverBox,
                    BlocBuilder<HomeCubit, HomeStates>(
                        builder: (context, state) {
                      if (cubit.productFilter.isAllNull()) {
                        return SliverMainAxisGroup(slivers: [
                          HomeStickyTabBar(
                            cubit: cubit,
                            controller: controller,
                            searchController: searchController,
                            onTabClicked: (value) {
                              _isTabClicked = value;
                            },
                          ),
                          if ((cubit.homemodel.filternewproducts(
                                      searchController.text) ??
                                  [])
                              .isNotEmpty)
                            SliverToBoxAdapter(
                              child: AutoScrollTag(
                                key: const ValueKey(-2),
                                controller: controller,
                                index: -2,
                                child: const SizedBox(
                                  height: 10,
                                ),
                              ),
                            ),
                          NewProductsSection(
                            cubit: cubit,
                            isSchedule: widget.isSchedule,
                            searchController: searchController,
                            controller: controller,
                            withbottom: widget.withbottom,
                            onChossenNumberChange: (p0) {
                              chossenNumber = p0;
                            },
                          ),
                          if ((cubit.homemodel.filterpopularproducts(
                                      searchController.text) ??
                                  [])
                              .isNotEmpty)
                            SliverToBoxAdapter(
                              child: AutoScrollTag(
                                key: const ValueKey(-1),
                                controller: controller,
                                index: -1,
                                child: const SizedBox(
                                  height: 6,
                                ),
                              ),
                            ),
                          PopularProductsSection(
                            cubit: cubit,
                            searchController: searchController,
                            controller: controller,
                            isSchedule: widget.isSchedule,
                          ),
                          CategoryProductListSliver(
                            cubit: cubit,
                            searchController: searchController,
                            controller: controller,
                            isSchedule: widget.isSchedule,
                          ),
                        ]);
                      } else {
                        if (cubit.pagingController == null) {
                          return const SliverToBoxAdapter(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: PagedSliverList.separated(
                            pagingController: cubit.pagingController!,
                            builderDelegate:
                                PagedChildBuilderDelegate<ProductModel>(
                              itemBuilder: (context, item, pageKey) {
                                return ProductWidget(
                                  showStar: true,
                                  showAddButton: true,
                                  isSchedule: widget.isSchedule,
                                  product: item,
                                  add: (p0) {
                                    if (item.hasOptions ?? false) {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.ProductdetailsScreen,
                                        arguments: ProductDetailsargs(
                                            id: item.id ??
                                                LocalizationHelper
                                                    .tr.unspecified_phrase,
                                            branchId:
                                                cubit.homemodel.branch?.id ??
                                                    LocalizationHelper
                                                        .tr.unspecified_phrase,
                                            isSchedule:
                                                widget.isSchedule),
                                      );

                                      return;
                                    }
                                    cubit.request.product = item;
                                    cubit.request.branchId =
                                        cubit.homemodel.branch?.id ??
                                            LocalizationHelper
                                                .tr.unspecified_phrase;
                                    cubit.request.optionValueIds = [];
                                    cubit.request.productId = item.id;
                                    cubit.request.quantity = p0.toString();
                                    if (widget.isSchedule) {
                                      NavigationHelper.pop(
                                          result: cubit.request);
                                    } else {
                                      cubit.addtoCart();
                                    }
                                  },
                                  branchId: cubit.homemodel.branch?.id ??
                                      LocalizationHelper.tr.unspecified_phrase,
                                );
                              },
                            ),
                            separatorBuilder: (context, index) {
                              return 10.ph;
                            },
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            );
          },
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
