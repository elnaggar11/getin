
import 'package:getincoffee/features/mypoints/domain/model/my_star_model/current_rank.dart';
import 'package:getincoffee/features/mypoints/domain/model/my_star_model/star_model.dart';
import 'package:getincoffee/features/mypoints/domain/model/point_model.dart';
import 'package:getincoffee/features/mypoints/domain/model/ranks_list_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/Locator.dart';
import '../domain/repository/repository.dart';
import 'mypoints_states.dart';

class MypointsCubit extends Cubit<MypointsStates> {
  MypointsCubit() : super(MypointsInitial());
  static MypointsCubit get(context) => BlocProvider.of(context);

  MypointsRepository mypointsRepository = locator<MypointsRepository>();
  MyStarModel? myStarModel;
  RanksListModel? ranksListModel;
  Rank? rank;
  Future<void> getMyStar() async {
    emit(MypointsLoading());
    final result = await mypointsRepository.getMyStar();
    if (result != null) {
      myStarModel = result;
      emit(MypointsSuccess(result));
    } else {
      emit(MypointsError());
    }
  }

  Future<void> getOneStar(String id) async {
    emit(GetOneStarLoading());
    final result = await mypointsRepository.getOneStar(id);
    if (result != null) {
      rank = result;
      emit(GetOneStarSuccess(result));
    } else {
      emit(GetOneStarError());
    }
  }

  Future<void> getAllRanks(int id) async {
    emit(GetAllRanksLoading());
    final result = await mypointsRepository.getAllStars();
    if (result != null) {
      ranksListModel = result;
      ranksListModel?.currentRankId = id;
      emit(GetAllRanksSuccess(result));
    } else {
      emit(GetAllRanksError());
    }
  }

  Mypoints? allpoints;
  Future<void> mypoints() async {
    emit(GetPointsLoading());
    final result = await mypointsRepository.getMypoints();
    if (result != null) {
      allpoints = Mypoints.fromJson(result);
      emit(GetPointsSuccess(
        Mypoints.fromJson(result),
      ));
    } else {
      emit(GetPointsFailed());
    }
  }

  Future<void> buyPoints({
    required String amount,
    required String paymentMethodId,
  }) async {
    emit(BuyPointsLoading());
    final result = await mypointsRepository.buyPoints(
      amount: amount,
      paymentMethodId: paymentMethodId,
    );
    if (result != null) {
      emit(BuyPointsSuccess(data: result));
    } else {
      emit(BuyPointsError());
    }
  }
}
