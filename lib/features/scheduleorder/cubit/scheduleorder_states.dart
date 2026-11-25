import 'package:getincoffee/features/cart/domain/request/payment_data.dart';

import '../../home/domain/model/home_model.dart';

abstract class ScheduleorderStates {}

class ScheduleorderInitial extends ScheduleorderStates {}

class ScheduleorderLoading extends ScheduleorderStates {}

class ScheduleorderSuccess extends ScheduleorderStates {
  final PaymentData? data;

  ScheduleorderSuccess({this.data});
}

class ScheduleorderFailed extends ScheduleorderStates {}

class SearchBranchLoading extends ScheduleorderStates {}

class BranchesLoadedSuccess extends ScheduleorderStates {
  List<BranchModel>? branches;

  BranchesLoadedSuccess({this.branches});
}

class BrancheesLoadedError extends ScheduleorderStates {}

class ChangeCardState extends ScheduleorderStates {}

class GetScheduleorderLoading extends ScheduleorderStates {}

class GetScheduleorderSuccess extends ScheduleorderStates {}

class GetScheduleorderFailed extends ScheduleorderStates {}

class DeleteScheduleorderLoading extends ScheduleorderStates {}

class DeleteScheduleorderSuccess extends ScheduleorderStates {}

class DeleteScheduleorderFailed extends ScheduleorderStates {}
