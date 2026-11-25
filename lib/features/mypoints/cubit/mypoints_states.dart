import 'package:getincoffee/features/mypoints/domain/model/my_star_model/current_rank.dart';
import 'package:getincoffee/features/mypoints/domain/model/my_star_model/star_model.dart';
import 'package:getincoffee/features/mypoints/domain/model/point_model.dart';
import 'package:getincoffee/features/mypoints/domain/model/ranks_list_model.dart';
import 'package:getincoffee/features/cart/domain/request/payment_data.dart';

abstract class MypointsStates {}

class MypointsInitial extends MypointsStates {}

class MypointsLoading extends MypointsStates {}

class MypointsSuccess extends MypointsStates {
  final MyStarModel? result;

  MypointsSuccess(this.result);
}

class MypointsError extends MypointsStates {}

class GetOneStarLoading extends MypointsStates {}

class GetOneStarSuccess extends MypointsStates {
  final Rank? result;

  GetOneStarSuccess(this.result);
}

class GetOneStarError extends MypointsStates {}

class GetAllRanksLoading extends MypointsStates {}

class GetAllRanksSuccess extends MypointsStates {
  final RanksListModel? ranksListModel;

  GetAllRanksSuccess(this.ranksListModel);
}

class GetAllRanksError extends MypointsStates {}

class GetPointsLoading extends MypointsStates {}

class GetPointsSuccess extends MypointsStates {
  Mypoints? pointModel;

  GetPointsSuccess(this.pointModel);
}

class GetPointsFailed extends MypointsStates {}

class BuyPointsLoading extends MypointsStates {}

class BuyPointsSuccess extends MypointsStates {
  final PaymentData data;

  BuyPointsSuccess({required this.data});
}

class BuyPointsError extends MypointsStates {}
