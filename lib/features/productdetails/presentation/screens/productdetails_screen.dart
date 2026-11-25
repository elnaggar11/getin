import 'dart:developer';

import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/Router/navigation_helper.dart';
import 'package:getincoffee/core/extensions/widget_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/home/presentation/widgets/slider_widgets.dart';
import 'package:getincoffee/core/general/cubit/general_cubit.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/general/genera_repositories.dart';
import '../../cubit/productdetails_cubit.dart';
import '../../cubit/productdetails_states.dart';
import '../widgets/proprty_widget.dart';
import '../widgets/sliver_appbar_widget.dart';

class ProductdetailsScreen extends StatefulWidget {
  const ProductdetailsScreen({
    super.key,
    this.id,
    this.branchId,
    this.isSchedule,
  });
  final String? id;
  final String? branchId;
  final bool? isSchedule;

  @override
  State<ProductdetailsScreen> createState() => _ProductdetailsScreenState();
}

class _ProductdetailsScreenState extends State<ProductdetailsScreen>
    with SingleTickerProviderStateMixin {
  int quan = 1;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductdetailsCubit()
        ..getProductDetails(id: widget.id, branchId: widget.branchId),
      child: BlocConsumer<ProductdetailsCubit, ProductdetailsStates>(
        listener: (context, state) {
          final cubit = ProductdetailsCubit.get(context);
          if (state is ProductdetailsSuccess) {
            cubit.productdetails = state.productModel;
            cubit.request.productId = widget.id ?? "0";
            cubit.request.branchId = widget.branchId ?? "0";
            // cubit.request.branch_id = state.productModel. ?? "0";
          }
          if (state is AddTocartSuccess) {
            NavigationHelper.popUntilRoute(Routes.layoutScreen, result: true);
            /*  Navigator.pushNamedAndRemoveUntil(
                context, Routes.layoutScreen, (r) => false); */
          }
        },
        builder: (context, state) {
          final cubit = ProductdetailsCubit.get(context);

          if (state is ProductdetailsLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is ProductdetailsFailure) {
            return Scaffold(
              body: Center(
                  child: Text(
                      LocalizationHelper.tr.failed_to_load_product_details)),
            );
          }

          final product = cubit.productdetails;
          /*   return Material(
            child: Container(
              color: Colors.red,
              height: 300,
              width: 300,
            ),
          );
 */
          return Scaffold(
            backgroundColor: LightThemeColors.primary,
            body: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    removeBottom: true,
                    child: SliverAppBar(
                      pinned: true,
                      floating: false,
                      snap: false,
                      backgroundColor: LightThemeColors.primary,
                      expandedHeight: MediaQuery.sizeOf(context).width *
                          200 /
                          400, // full slider height
                      collapsedHeight: 80, // small appbar height
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: SliderWidgets(
                          height: 283,
                          myaspecRatio: 400 / 200,
                          withleading: true,
                          withoutIcons: true,
                          images: product.images ?? [],
                        ),
                      ),
                    )),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: SliverPadding(
                    padding: const EdgeInsets.only(top: 12),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        color: LightThemeColors.primary,
                        child: SliverAppbarWidget(
                          refresh: () => cubit.getProductDetails(
                            id: widget.id,
                            branchId: widget.branchId,
                            isloading: false,
                          ),
                          productdetails: product,
                          branchId: widget.branchId,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 16,
                      right: 16,
                      left: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: LightThemeColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LocalizationHelper.tr.description,
                            style: TextStyles.font16BlackSemiBold),
                        12.ph,
                        Text(product.description ??
                            LocalizationHelper.tr.unspecified_phrase),
                        24.ph,
                      ],
                    ),
                  ),
                ),
                SliverList.separated(
                  itemCount: (product.options?.length ?? 0),
                  itemBuilder: (c, i) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: LightThemeColors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: PropertyWidget2(
                          onChange: (p0) {
                            var index = product.options?[i].id;

                            if (p0 != null && index != null) {
                              cubit.addProperties(index, [p0]);
                            }

                            // setState(() {});
                          },
                          onMultipleChange: (p0) {
                            var index = product.options?[i].id;
                            if (index != null) {
                              cubit.addProperties(index, p0);
                            }
                          },
                          option: product.options?[i],
                          withtitile: true,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (c, i) => Container(
                    height: 16,
                    decoration: const BoxDecoration(
                      color: LightThemeColors.white,
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    height: 30,
                    color: LightThemeColors.white,
                  ),
                )
              ],
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: LightThemeColors.white,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ButtonWidget(
                    onTap: () {
                      log(widget.isSchedule.toString());
                      log(widget.branchId.toString(), name: "gggggggggg");
                      cubit.request.quantity = quan.toString();
                      if (widget.isSchedule == true) {
                        cubit.request.product = product;
                        cubit.request.optionValueIds = cubit.properties.values
                            .expand((e) => e)
                            .map((e) => e.id.toString())
                            .toList();
                        NavigationHelper.popUntilRoute(
                            Routes.CreateSchedulorderScreen,
                            result: cubit.request);
                      } else {
                        cubit.addtoCart();
                      }
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              24.pw,
                              SvgPicture.asset(SvgAssets.Buy),
                              14.pw,
                              Text(
                                "${LocalizationHelper.tr.add_to_cart("${(cubit.extraPrice + num.parse(product.price ?? "0")) * quan} ₺")} ",
                                style: TextStyles.font12BlackBold.copyWith(
                                  fontWeight: FontWeights.semiBold,
                                  fontSize: 12,
                                  color: LightThemeColors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: LightThemeColors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: LightThemeColors.cardBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.remove,
                                    color: LightThemeColors.black, size: 16),
                              ).onTap(() {
                                if (quan > 1) {
                                  quan--;
                                  setState(() {});
                                }
                              }),
                              12.pw,
                              Text("$quan",
                                  style: TextStyles.font12BlackBold.copyWith(
                                    color: LightThemeColors.grey,
                                  )),
                              12.pw,
                              Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: LightThemeColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.add,
                                    color: LightThemeColors.white, size: 16),
                              ).onTap(() {
                                if (quan <
                                    int.parse(cubit.productdetails
                                            .remaining_quantity ??
                                        "0")) {
                                  quan++;
                                  setState(() {});
                                }
                              }),
                            ],
                          ),
                        ),
                        8.pw,
                      ],
                    ),
                  ),
                  12.ph,
                  ButtonWidget(
                    onTap: () {
                      NavigationHelper.popUntil(Routes.layoutScreen);
                    },
                    buttonColor: LightThemeColors.black,
                    title: LocalizationHelper.tr.continue_shopping,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class FavoriteIcon extends StatefulWidget {
  const FavoriteIcon({
    super.key,
    this.id,
    this.branchId,
    this.isFavorite,
    this.favourite_id,
    this.refresh,
    this.color,
  });

  final String? id;
  final String? branchId;
  final String? favourite_id;
  final bool? isFavorite;
  final VoidCallback? refresh;
  final Color? color;
  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  late bool isFavorite;
  String? currentFavouriteId;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite ?? false;
    currentFavouriteId = widget.favourite_id;
  }

  @override
  void didUpdateWidget(covariant FavoriteIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      isFavorite = widget.isFavorite ?? false;
    }
    if (widget.favourite_id != oldWidget.favourite_id) {
      currentFavouriteId = widget.favourite_id;
    }
  }

  Future<void> toggleFavorite() async {
    if (!isFavorite) {
      final result = await GeneralRepostioreis.instance.like(
        product_id: widget.id,
        branchid: widget.branchId,
      );
      result.fold((l) {}, (r) {
        if (mounted) {
          setState(() {
            isFavorite = true;
            currentFavouriteId = r;
          });
        }
        widget.refresh?.call();
        _syncHomeCubit(context);
      });
    } else {
      final success = await GeneralRepostioreis.instance.disLike(
        product_id: currentFavouriteId,
      );
      if (success) {
        if (mounted) {
          setState(() {
            isFavorite = false;
            currentFavouriteId = null;
          });
        }
        widget.refresh?.call();
        _syncHomeCubit(context);
      }
    }
  }

  void _syncHomeCubit(BuildContext context) {
    if (widget.id != null) {
      try {
        final generalCubit = GeneralCubit.get(context);
        generalCubit.updateProductFavoriteStatus(
          widget.id!,
          isFavorite,
          currentFavouriteId,
        );
      } catch (e) {
        debugPrint('Could not sync favorite status with GeneralCubit: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleFavorite,
      child: isFavorite
          ? SvgPicture.asset(
              SvgAssets.fillFav,
              colorFilter: ColorFilter.mode(
                  widget.color ?? LightThemeColors.primary, BlendMode.srcIn),
            )
          : SvgPicture.asset(
              SvgAssets.heart,
              color: LightThemeColors.white,
            ),
    );
  }
}
