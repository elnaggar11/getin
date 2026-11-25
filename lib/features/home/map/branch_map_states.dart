import 'package:getincoffee/core/general/generalmodel.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';

abstract class BranchMapStates {}

class BranchMapInitial extends BranchMapStates {}

class SearchBranchLoading extends BranchMapStates {}

class BranchesLoadedSuccess extends BranchMapStates {
  List<BranchModel> branches;
  BranchesLoadedSuccess({required this.branches});
}

class BrancheesLoadedError extends BranchMapStates {}

class UserBranchesLoading extends BranchMapStates {}

class UserBranchesSuccess extends BranchMapStates {
  BranchModel? branches;
  UserBranchesSuccess({required this.branches});
}

class UserBranchesErroe extends BranchMapStates {}

class BranchCategoriesLoading extends BranchMapStates {}

class BranchLoadedSuccess extends BranchMapStates {
  List<BranchCategory> categories;
  BranchLoadedSuccess({required this.categories});
}

class BranchCategoriesError extends BranchMapStates {}

class ProductsLoading extends BranchMapStates {}

class ProductsLoadedSuccess extends BranchMapStates {
  HomeModel homeModel;
  bool? changeTab;
  ProductsLoadedSuccess({required this.homeModel, this.changeTab});
}

class ProductsLoadedError extends BranchMapStates {}

class SaveBranchLoading extends BranchMapStates {}

class SaveBranckSuccess extends BranchMapStates {
  String id;
  SaveBranckSuccess({required this.id});
}

class SaveBranchError extends BranchMapStates {}

class DeleteBranchLoading extends BranchMapStates {}

class DeleteBranckSuccess extends BranchMapStates {}

class DeleteBranchError extends BranchMapStates {}

class AddTocartLoading extends BranchMapStates {}

class AddTocartSuccess extends BranchMapStates {}

class AddTocartFailed extends BranchMapStates {}

class GetHomeSlidersLoading extends BranchMapStates {}

class GetHomeSlidersSuccess extends BranchMapStates {
  List<GeneralModel> sliders;
  GetHomeSlidersSuccess({required this.sliders});
}

class GetHomeSlidersError extends BranchMapStates {}

class GetHomeTextLoading extends BranchMapStates {}

class GetHomeTextSuccess extends BranchMapStates {}

class GetHomeTextError extends BranchMapStates {}

class FollowBranchLoading extends BranchMapStates {}

class FollowBranchSuccess extends BranchMapStates {
  final dynamic id;

  FollowBranchSuccess({required this.id});
}

class FollowBranchError extends BranchMapStates {}

class GetAllNotificationsLoading extends BranchMapStates {}

class GetAllNotificationsSuccess extends BranchMapStates {}

class GetAllNotificationsError extends BranchMapStates {}

class BranchLoading extends BranchMapStates {}

class BranchChanges extends BranchMapStates {}
