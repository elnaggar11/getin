import 'package:getincoffee/features/myorder/domain/model/myorder_model.dart';

abstract class MyorderStates {}

class MyorderInitial extends MyorderStates {}

class MyorderLoadingState extends MyorderStates {}

class MyorderSuccessState extends MyorderStates {
  MyorderModel? myorderModel;

  MyorderSuccessState({this.myorderModel});
}

class MyorderErrorState extends MyorderStates {}

class CancelOrderLoadingState extends MyorderStates {}

class CancelOrderSuccessState extends MyorderStates {}

class CancelOrderFailedState extends MyorderStates {}

class ReorderLoadingState extends MyorderStates {}

class ReorderSuccessState extends MyorderStates {}

class ReorderFailedState extends MyorderStates {}

class ReorderConfirmationRequiredState extends MyorderStates {
  final List<dynamic> unavailableItems;
  final String id;
  ReorderConfirmationRequiredState(
      {required this.unavailableItems, required this.id});
}
