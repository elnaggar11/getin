import 'package:getincoffee/features/cart/domain/model/cart_model.dart';

abstract class FavoriteStates {}

class FavoriteInitial extends FavoriteStates {}

class FavoriteLoadingState extends FavoriteStates {}

class FavoriteSuccessState extends FavoriteStates {
  List<ItemModel> items;

  FavoriteSuccessState({required this.items});
}

class FavoriteErrorState extends FavoriteStates {}

class DeleteAllLoadingState extends FavoriteStates {}

class DeleteAllSuccessState extends FavoriteStates {}

class DeleteAllErrorState extends FavoriteStates {}

class DeleteLoadingState extends FavoriteStates {}

class DeleteSuccessState extends FavoriteStates {}

class DeleteErrorState extends FavoriteStates {}

class FavoriteSearchState extends FavoriteStates {}
