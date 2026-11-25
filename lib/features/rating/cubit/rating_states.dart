import 'package:getincoffee/core/general/generalmodel.dart';

abstract class RatingStates {}

class RatingInitial extends RatingStates {}

class RatingLoadingState extends RatingStates {}

class RatingSuccessState extends RatingStates {
  List<GeneralModel>? keywords;

  RatingSuccessState({this.keywords});
}

class RatingFailureState extends RatingStates {}

class RatingProductLoadingState extends RatingStates {}

class RatingProductSuccessState extends RatingStates {
  String? message;

  RatingProductSuccessState({this.message});
}

class RatingProductFailureState extends RatingStates {}

class RatingDeliveryLoadingState extends RatingStates {}

class RatingDeliverySuccessState extends RatingStates {
  String? message;

  RatingDeliverySuccessState({this.message});
}

class RatingDeliveryFailureState extends RatingStates {}

class RatingBranchLoadingState extends RatingStates {}

class RatingBranchSuccessState extends RatingStates {
  String? message;

  RatingBranchSuccessState({this.message});
}

class RatingBranchFailureState extends RatingStates {}
