import 'dart:developer';

import 'package:getincoffee/features/mypoints/domain/model/my_star_model/current_rank.dart';
import 'package:getincoffee/features/mypoints/domain/model/my_star_model/star_model.dart';
import 'package:getincoffee/features/mypoints/domain/model/ranks_list_model.dart';
import 'package:getincoffee/features/cart/domain/request/payment_data.dart';

import '../../../../core/data_source/dio_helper.dart';
import 'endpoints.dart';

//put it in locators locator.registerLazySingleton(() => MypointsRepository(locator<DioService>()));
//  import '../../modules/mypoints/domain/repository/repository.dart';
class MypointsRepository {
  final DioService dioService;
  MypointsRepository(this.dioService);
  Future<MyStarModel?> getMyStar() async {
    try {
      final response =
          await dioService.getData(url: MypointsEndpoints.getMyStar);
      if (response.isError == false) {
        return MyStarModel.fromJson(response.response?.data["data"]);
      }
      return null;
    } catch (e, trace) {
      print(trace);
      return null;
    }
  }

  Future<Rank?> getOneStar(String id) async {
    try {
      final response =
          await dioService.getData(url: MypointsEndpoints.oneStar(id));
      if (response.isError == false) {
        return Rank.fromJson(response.response?.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<RanksListModel?> getAllStars() async {
    try {
      final response =
          await dioService.getData(url: MypointsEndpoints.allStars);
      if (response.isError == false) {
        return RanksListModel.fromJson(response.response?.data);
      }
      return null;
    } catch (e, trace) {
      print(trace);
      return null;
    }
  }

  getMypoints() async {
    try {
      final response =
          await dioService.getData(url: MypointsEndpoints.mypoints);
      if (response.isError == false) {
        // return CurrentRank.fromJson(response.response?.data);
      }
      return response.response?.data["data"];
    } catch (e, trace) {
      print(trace);
      return null;
    }
  }

  Future<PaymentData?> buyPoints({
    required String amount,
    required String paymentMethodId,
  }) async {
    try {
      final response = await dioService.postData(
        url: MypointsEndpoints.buyPoints,
        body: {
          'points': amount,
          'payment_method': paymentMethodId,
        },
        loading: true,
        isForm: true,
      );
      log(response.response?.data.toString() ?? '');
      if (response.isError == false) {
        return PaymentData.fromMap(response.response?.data["data"]);
      }
      return null;
    } catch (e, trace) {
      print(trace);
      return null;
    }
  }
}
