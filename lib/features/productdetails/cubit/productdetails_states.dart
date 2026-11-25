import 'package:getincoffee/features/home/domain/model/home_model.dart';

abstract class ProductdetailsStates {}

class ProductdetailsInitial extends ProductdetailsStates {}

class ProductdetailsLoading extends ProductdetailsStates {}

class ProductdetailsSuccess extends ProductdetailsStates {
  ProductModel productModel;
  ProductdetailsSuccess(this.productModel);
}

class ProductdetailsFailure extends ProductdetailsStates {}

class AddTocartLoading extends ProductdetailsStates {}

class AddTocartSuccess extends ProductdetailsStates {}

class AddTocartFailed extends ProductdetailsStates {}

class LikeLoadingState extends ProductdetailsStates {}

class LikeSuccessState extends ProductdetailsStates {}

class LikeErrorState extends ProductdetailsStates {}

class StartChangeProperites extends ProductdetailsStates {}

class EndChangeProperites extends ProductdetailsStates {}
