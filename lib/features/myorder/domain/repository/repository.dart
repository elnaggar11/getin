import 'package:getincoffee/core/utils/utils.dart';

import '../../../../core/data_source/dio_helper.dart';

//put it in locators locator.registerLazySingleton(() => MyorderRepository(locator<DioService>()));
//  import '../../modules/myorder/domain/repository/repository.dart';
class MyorderRepository {
  final DioService dioService;
  MyorderRepository(this.dioService);

  getorders({String? status}) async {
    final ApiResponse response =
        await dioService.getData(url: "user/orders/status/$status");
    //     query: {
    //   "status": status,
    // }
    // );
    if (response.isError == false) {
      return response.response?.data;
    } else {
      return null;
    }
  }

  cancellOrder({String? id}) async {
    final ApiResponse response = await dioService.postData(
      url: "orders/cancel/$id",
      isJson: true,
      loading: true,
    );

    if (response.isError == false) {
      return true;
    } else {
      return null;
    }
  }

  reOrder({String? id, String? confirm}) async {
    final ApiResponse response = await dioService.postData(
      url: "order/reorder/$id",
      loading: true,
      isForm: true,
      body: {
        if (confirm != null) "confirm": confirm,
        "branch_id": Utils.branchId,
      },
    );

    if (response.isError == false) {
      return true;
    } else if (response.response?.data['key'] == "need_confirmation") {
      return response.response?.data['data'];
    } else {
      return null;
    }
  }
}
