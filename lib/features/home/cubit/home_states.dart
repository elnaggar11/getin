import 'package:getincoffee/core/general/generalmodel.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/home/domain/model/slider_model.dart';

abstract class HomeStates {}

class HomeInitial extends HomeStates {}

class SearchBranchLoading extends HomeStates {}

class BranchesLoadedSuccess extends HomeStates {
  List<BranchModel> branches;
  BranchesLoadedSuccess({required this.branches});
}

class BrancheesLoadedError extends HomeStates {}

class UserBranchesLoading extends HomeStates {}

class UserBranchesSuccess extends HomeStates {
  BranchModel? branches;
  UserBranchesSuccess({required this.branches});
}

class UserBranchesErroe extends HomeStates {}

class BranchCategoriesLoading extends HomeStates {}

class BranchLoadedSuccess extends HomeStates {
  List<BranchCategory> categories;
  BranchLoadedSuccess({required this.categories});
}

class BranchCategoriesError extends HomeStates {}

class ProductFilterChangesSuccess extends HomeStates {}

class ProductFilterChangesStart extends HomeStates {}

class ProductsLoading extends HomeStates {}
class ProductFilterChangesFail extends HomeStates {}

class ProductsLoadedSuccess extends HomeStates {
  HomeModel homeModel;
  bool? changeTab;
  ProductsLoadedSuccess({required this.homeModel, this.changeTab});
}

class ProductsLoadedError extends HomeStates {}

class ProductsLoadedEmpty extends HomeStates {}

class SaveBranchLoading extends HomeStates {}

class SaveBranckSuccess extends HomeStates {
  String id;
  SaveBranckSuccess({required this.id});
}

class SaveBranchError extends HomeStates {}

class DeleteBranchLoading extends HomeStates {}

class DeleteBranckSuccess extends HomeStates {}

class DeleteBranchError extends HomeStates {}

class AddTocartLoading extends HomeStates {}

class AddTocartSuccess extends HomeStates {}

class AddTocartFailed extends HomeStates {}

class GetHomeSlidersLoading extends HomeStates {}

class GetHomeSlidersSuccess extends HomeStates {
  List<GeneralModel> sliders;
  GetHomeSlidersSuccess({required this.sliders});
}

class GetHomeSlidersError extends HomeStates {}

class GetHomeTextLoading extends HomeStates {}

class GetHomeTextSuccess extends HomeStates {}

class GetHomeTextError extends HomeStates {}

class FollowBranchLoading extends HomeStates {}

class FollowBranchSuccess extends HomeStates {
  final dynamic id;

  FollowBranchSuccess({required this.id});
}

class FollowBranchError extends HomeStates {}

class GetAllNotificationsLoading extends HomeStates {}

class GetAllNotificationsSuccess extends HomeStates {}

class GetAllNotificationsError extends HomeStates {}

class BranchLoading extends HomeStates {}

class BranchChanges extends HomeStates {}

class BranchBottomSheetState extends HomeStates {
  HomeAdsModel? homeSlider;
  BranchModel? branch;
  BranchBottomSheetState({this.homeSlider, this.branch});
}


      class HomeBranchChanges extends HomeStates {}
      class ProductFavoriteUpdated extends HomeStates {}
