import 'package:getincoffee/core/general/generalmodel.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/features/rating/domain/request/rating_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/Locator.dart';
import '../domain/repository/repository.dart';
import 'rating_states.dart';

class RatingCubit extends Cubit<RatingStates> {
  RatingCubit() : super(RatingInitial());
  static RatingCubit get(context) => BlocProvider.of(context);

  RatingRepository ratingRepository = locator<RatingRepository>();

  List<GeneralModel>? keywords;
  getKeywords() async {
    emit(RatingLoadingState());

    final response = await ratingRepository.getKeywords();

    if (response != null) {
      emit(RatingSuccessState(keywords: response));
      keywords = response;
    } else {
      emit(RatingFailureState());
    }
  }

  rateProduct(RatingRequest ratingRequest, String id) async {
    if (ratingRequest.checkOrderRate() != null) {
      Alerts.snack(
          text: ratingRequest.checkOrderRate() ?? "", state: SnackState.failed);
      emit(RatingProductFailureState());
      return;
    }
    emit(RatingProductLoadingState());
    final response = await ratingRepository.rateproduct(ratingRequest, id);
    if (response != null) {
      emit(RatingProductSuccessState(
        message: response,
      ));
    } else {
      emit(RatingProductFailureState());
    }
  }

  Future<bool?> rateDelivery(RatingRequest ratingRequest, String id) async {
    emit(RatingDeliveryLoadingState());
    final response = await ratingRepository.rateDeliver(ratingRequest, id);
    if (response != null) {
      emit(RatingDeliverySuccessState(
        message: response,
      ));
      return true;
    } else {
      emit(RatingDeliveryFailureState());
      return null;
    }
  }

  rateBranch(RatingRequest ratingRequest, String id) async {
    emit(RatingBranchLoadingState());
    final response = await ratingRepository.rateBranch(ratingRequest, id);
    if (response != null) {
      emit(RatingBranchSuccessState(
        message: response,
      ));
    } else {
      emit(RatingBranchFailureState());
    }
  }
}
