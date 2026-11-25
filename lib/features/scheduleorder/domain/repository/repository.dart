import 'package:getincoffee/features/scheduleorder/domain/model/scheduleorder_model.dart';
import 'package:getincoffee/features/scheduleorder/domain/request/scheduleorder_request.dart';

import '../../../../core/data_source/dio_helper.dart';

import 'package:getincoffee/features/cart/domain/request/payment_data.dart';

//put it in locators locator.registerLazySingleton(() => ScheduleorderRepository(locator<DioService>()));
//  import '../../modules/scheduleorder/domain/repository/repository.dart';
class ScheduleorderRepository {
  final DioService dioService;
  ScheduleorderRepository(this.dioService);

  Future<PaymentData?> addScheduleOrder(
      ScheduleorderRequest scheduleOrderRequest) async {
    final ApiResponse response = await dioService.postData(
      url: "orders/schedule",
      body: scheduleOrderRequest.toMap(),
      loading: true,
      isForm: true,
    );
    if (response.isError == false) {
      if (response.response?.data['data'] != null) {
        return PaymentData.fromMap(response.response?.data['data']);
      }
      return PaymentData();
    }
    return null;
  }

  Future<PagingScheduleorderModel?> getScheduleOrders({int? page}) async {
    final ApiResponse response = await dioService.getData(
      url: "orders/schedule",
      query: {"page": page},
      loading: true,
    );
    if (response.isError == false) {
      return PagingScheduleorderModel.fromMap(response.response?.data);
    }
    return null;
  }

  Future<bool> deleteScheduleOrder({required String id}) async {
    final ApiResponse response = await dioService.deleteData(
      url: "orders/schedule/$id",
      loading: true,
    );
    if (response.isError == false) {
      return true;
    }
    return false;
  }
}
