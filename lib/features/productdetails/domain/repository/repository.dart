import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/features/productdetails/domain/request/productdetails_request.dart';

import '../../../../core/data_source/dio_helper.dart';

//put it in locators locator.registerLazySingleton(() => ProductdetailsRepository(locator<DioService>()));
//  import '../../modules/productdetails/domain/repository/repository.dart';
class ProductdetailsRepository {
  final DioService dioService;
  ProductdetailsRepository(this.dioService);
  getProductDetails({String? id, String? branchId}) async {
    final ApiResponse response = await dioService.getData(
      url: "product/$id",
      query: {
        if (branchId != null && branchId.isNotEmpty) 'branch_id': branchId,
      },
    );
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }

  addtoCart({AddtoCartRequest? request}) async {
    final ApiResponse response = await dioService.postData(
        url: "cart/add",
        body: request?.toMap(),
        isFile: true,
        isForm: true,
        loading: true);
    if (response.isError == false) {
      Alerts.snack(
          text: response.response?.data["message"] ?? "تمت اضافه المنتج بنجاح",
          state: SnackState.success);
      return true;
    } else {
      return null;
    }
  }

  likeanDislike({String? productId}) async {
    final ApiResponse response = await dioService.postData(
      url: "favorites",
      body: {
        "product_id": productId,
      },
      isForm: true,
    );
    if (response.isError == false) {
      return true;
    } else {
      return false;
    }
  }
}
