import 'package:getincoffee/features/cart/domain/model/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/Locator.dart';
import '../domain/repository/repository.dart';
import 'favorite_states.dart';

class FavoriteCubit extends Cubit<FavoriteStates> {
  FavoriteCubit() : super(FavoriteInitial()) {
    getFavoriteProducts();
  }
  static FavoriteCubit get(context) => BlocProvider.of(context);

  FavoriteRepository favoriteRepository = locator<FavoriteRepository>();
  List<ItemModel> _allItems = [];
  List<ItemModel> items = [];
  final TextEditingController searchController = TextEditingController();

  void searchFavorites(String query) {
    if (query.isEmpty) {
      items = List.from(_allItems);
    } else {
      items = _allItems
          .where((item) =>
              item.product?.name?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .toList();
    }
    emit(FavoriteSearchState());
  }

  getFavoriteProducts() async {
    emit(FavoriteLoadingState());
    final response = await favoriteRepository.getFavoritesProducts();
    if (response != null) {
      _allItems = response;
      items = response;
      emit(FavoriteSuccessState(
        items: response,
      ));
    } else {
      emit(FavoriteErrorState());
    }
  }

  deleteAllfavorites() async {
    emit(DeleteAllLoadingState());
    final response = await favoriteRepository.deleteAllfavorites();
    if (response != null) {
      emit(DeleteAllSuccessState());
    } else {
      emit(DeleteAllErrorState());
    }
  }

  deleteFavoriteProduct({String? id}) async {
    emit(DeleteLoadingState());
    final response = await favoriteRepository.deleteFavoriteProduct(id: id);
    if (response != null) {
      getFavoriteProducts();
      emit(DeleteSuccessState());
    } else {
      emit(DeleteErrorState());
    }
  }
}
