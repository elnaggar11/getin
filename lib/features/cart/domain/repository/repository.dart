import 'dart:developer';

import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/features/cart/domain/model/summary_model.dart';
import 'package:getincoffee/features/cart/domain/request/payment_data.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/myorder/domain/model/myorder_model.dart';

import '../../../../core/data_source/dio_helper.dart';
import '../../../../core/utils/either.dart';
import '../request/cart_request.dart';

//put it in locators locator.registerLazySingleton(() => CartRepository(locator<DioService>()));
//  import '../../modules/cart/domain/repository/repository.dart';
class CartRepository {
  final DioService dioService;
  CartRepository(this.dioService);

  Future<PagedProducts?> getCartProducts({int? page}) async {
    final ApiResponse response = await dioService.getData(
      url: "product-in-cart",
      query: {
        "page": page,
      },
    );
    if (response.isError == false) {
      try {
        return PagedProducts.fromMap(response.response?.data);
      } catch (e, tr) {
        log(e.toString(), error: e, stackTrace: tr, name: "getCartProductss");
        return null;
      }
    } else {
      return null;
    }
  }

  getAllcart() async {
    final ApiResponse response = await dioService.getData(
      url: "cart",
    );
    if (response.isError == false) {
      if (response.response?.data["data"] is! List) {
        return response.response?.data["data"];
      } else {
        return [];
      }
    } else {
      return null;
    }
  }

  deleteAllItems() async {
    final ApiResponse response = await dioService.deleteData(
      url: "cart/clear",
    );
    if (response.isError == false) {
      Alerts.snack(
          text: response.response?.data['message'] ?? 'DeleteAllSuccess',
          state: SnackState.success);
      return true;
    } else {
      return null;
    }
  }

  deleteItem({String? id}) async {
    try {
      final ApiResponse response = await dioService.deleteData(
        url: "cart/remove-item/$id",
      );
      if (response.isError == false) {
        return true;
      } else {
        return null;
      }
    } catch (w) {
      return null;
    }
  }

  updateQuan({String? id, String? quantity}) async {
    final ApiResponse response =
        await dioService.postData(url: "cart/update-quantity/$id", body: {
      "quantity": quantity,
    });
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }

  Future<PaymentData?> checkout({
    CheckOutRequest? request,
    String payWith = 'money',
  }) async {
    try {
      final ApiResponse response = await dioService.postData(
        url: "order/checkout",
        body: request?.toMap(payWith: payWith),
        loading: true,
        isJson: true,
      );

      if (response.isError == false) {
        final dynamic data = response.response?.data["data"];
        if (data is Map<String, dynamic>) return PaymentData.fromMap(data);
        return null;
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  Future<Either<String, String>> payWithPoints(
      {CheckOutRequest? request}) async {
    final ApiResponse response = await dioService.postData(
      url: "order/checkout",
      body: request?.toMapPoints(),
      loading: true,
      isJson: true,
    );
    if (response.isError == false) {
      return Right(
          response.response?.data["data"]?["order"]?["id"]?.toString() ?? "");
    } else {
      return Left(
          response.response?.data?["message"]?.toString() ?? "Payment Failed");
    }
  }

  verifyCopon({String? copon, String? type}) async {
    final ApiResponse response = await dioService.postData(
      url: "verify-coupon",
      body: {
        "coupon_code": copon,
        "type":
            (type == "Pickup" || type == "pick-up") ? "pick_up" : "delivery",
      },
      loading: true,
      isForm: true,
    );
    if (response.isError == false) {
      return response.response?.data["data"]?["value"].toString();
    } else {
      return null;
    }
  }

  summarydata({String? copon, String? type}) async {
    final ApiResponse response = await dioService.postData(
      url: "order/summary",
      body: {
        "coupon_code": copon,
        "type":
            (type == "Pickup" || type == "pick-up") ? "pick_up" : "delivery",
      },
      loading: true,
      isForm: true,
    );
    if (response.isError == false) {
      return SummaryModel.fromMap(response.response?.data["data"]);
    } else {
      return null;
    }
  }

  Future<SingleOrderModel?> getSingleOrder({String? id}) async {
    final ApiResponse response =
        await dioService.getData(url: "user/orders/$id");
    if (response.isError == false) {
      return SingleOrderModel.fromMap(response.response?.data["data"]);
    } else {
      return null;
    }
  }
}
