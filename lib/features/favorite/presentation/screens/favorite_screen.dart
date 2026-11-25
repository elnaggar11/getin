import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/home/presentation/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;

import '../../../../core/localization/localization_helper.dart';
import '../../../../core/resources/font_manager.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import '../../cubit/favorite_cubit.dart';
import '../../cubit/favorite_states.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteCubit()..getFavoriteProducts(),
      child: BlocConsumer<FavoriteCubit, FavoriteStates>(
        listener: (context, state) {
          if (state is FavoriteSuccessState) {
            // FavoriteCubit.get(context).items = state.items;
          }
          if (state is DeleteAllSuccessState) {
            FavoriteCubit.get(context).getFavoriteProducts;
          }
        },
        builder: (context, state) {
          final cubit = FavoriteCubit.get(context);
          return Scaffold(
            backgroundColor: LightThemeColors.primary,
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocalizationHelper.tr.favorites,
                    style: TextStyles.font20WhiteSemiBold.copyWith(
                      color: LightThemeColors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        LocalizationHelper.tr.clear_all,
                        style: TextStyles.font14BlackMedium.copyWith(
                          color: LightThemeColors.error,
                          fontWeight: FontWeights.regular,
                        ),
                      ),
                      7.pw,
                      SvgPicture.asset(
                        SvgAssets.delete,
                      ),
                    ],
                  ).onTap(() {
                    cubit.deleteAllfavorites();
                  })
                ],
              ),
              toolbarHeight: 109,
              backgroundColor: LightThemeColors.primary,
              automaticallyImplyLeading: false,
              // leading: const Icon(
              //   Icons.arrow_back_sharp,
              //   color: LightThemeColors.white,
              // ).onTap(
              //   () {
              //     Navigator.pop(context);
              //   },
              // ),
            ),
            body: Container(
              // height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: LightThemeColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    40,
                  ),
                  topRight: Radius.circular(
                    40,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                children: [
                  16.ph,
                  TextFormFieldWidget(
                    controller: cubit.searchController,
                    onChanged: (value) => cubit.searchFavorites(value),
                    hintText: LocalizationHelper.tr.search_branches,
                    prefixWidget:
                        // "sheet_search",
                        Padding(
                      padding: const EdgeInsets.only(
                        right: 16,
                      ),
                      child: Transform.scale(
                        scale: .6,
                        child: SvgPicture.asset(
                          SvgAssets.sheetSearch,
                        ),
                      ),
                    ),
                  ),
                  16.ph,
                  Expanded(
                    child: cubit.items.isEmpty
                        ? const EmptyFavouriteList()
                        : ListView.separated(
                            separatorBuilder: (context, index) => 10.ph,
                            itemBuilder: (context, index) => ProductWidget(
                              key: ValueKey(cubit.items[index].product?.id),
                              refresh: () => cubit.getFavoriteProducts(),
                              product: cubit.items[index].product,
                              showAddButton: false,
                              isSchedule: false,
                              branchId: cubit.items[index].branchId,
                              onDeleted: (ProductModel product) {
                                cubit.deleteFavoriteProduct(
                                  id: product.id,
                                );
                              },
                            ),
                            itemCount: cubit.items.length,
                          ),
                  ),
                  10.ph,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class EmptyFavouriteList extends StatelessWidget {
  const EmptyFavouriteList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            SvgAssets.heart,
            width: 80,
            height: 80,
            colorFilter: ColorFilter.mode(
              LightThemeColors.grey.withOpacity(0.5),
              BlendMode.srcIn,
            ),
          ),
          16.ph,
          Text(
            LocalizationHelper.tr.empty_favorites,
            style: TextStyles.font14BlackMedium.copyWith(
              color: LightThemeColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
