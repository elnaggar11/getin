import 'package:getincoffee/core/general/generalmodel.dart';

import '../../../../core/data_source/dio_helper.dart';
import '../request/rating_request.dart';

//put it in locators locator.registerLazySingleton(() => RatingRepository(locator<DioService>()));
//  import '../../modules/rating/domain/repository/repository.dart';
class RatingRepository {
  final DioService dioService;
  RatingRepository(this.dioService);

  Future<List<GeneralModel>?> getKeywords() async {
    final ApiResponse response = await dioService.getData(
      url: "keywords",
    );
    if (response.isError == false) {
      return (response.response?.data['data'] as List)
          .map((e) => GeneralModel.fromMap(e))
          .toList();
    } else {
      return null;
    }
  }

  rateDeliver(RatingRequest? requets, String id) async {
    final ApiResponse response = await dioService.postData(
      url: "orders/$id/review/driver",
      body: requets?.toMap(),
      loading: true,
      isForm: true,
      // data: {},
    );
    if (response.isError == false) {
      return response.response?.data['message'];
    } else {
      return null;
    }
  }

  rateproduct(RatingRequest? requets, String id) async {
    final ApiResponse response = await dioService.postData(
      url: "orders/$id/review/products",
      body: requets?.toMap(),
      loading: true,
      isForm: true,
      // data: {},
    );
    if (response.isError == false) {
      return response.response?.data['message'];
    } else {
      return null;
    }
  }

  rateBranch(RatingRequest? requets, String id) async {
    final ApiResponse response = await dioService.postData(
      url: "orders/$id/review/branch",
      body: requets?.toMap(),
      loading: true,
      isForm: true,
      // data: {},
    );
    if (response.isError == false) {
      return response.response?.data['message'];
    } else {
      return null;
    }
  }
}
