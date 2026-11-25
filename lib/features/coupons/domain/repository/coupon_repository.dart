import 'package:getincoffee/core/data_source/dio_helper.dart';
import 'package:getincoffee/features/coupons/domain/model/coupon_model.dart';

class CouponRepository {
  final DioService dioService;

  CouponRepository(this.dioService);

  Future<List<CouponModel>?> getCoupons() async {
    final response = await dioService.getData(
      url: "coupons",
    );

    if (response.isError == false) {
      try {
        final couponsResponse =
            CouponsResponse.fromJson(response.response?.data);
        return couponsResponse.data;
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }
}
