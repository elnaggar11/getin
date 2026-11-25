import 'package:getincoffee/core/data_source/dio_helper.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/utils/Locator.dart';
import 'package:getincoffee/core/utils/either.dart';
import 'package:getincoffee/core/utils/utils.dart';
import 'package:getincoffee/features/auth/domain/model/auth_model.dart';

class GeneralRepostioreis {
  DioService dio;
  GeneralRepostioreis._(this.dio);
  static final GeneralRepostioreis _instance =
      GeneralRepostioreis._(locator<DioService>());
  static GeneralRepostioreis get instance => _instance;

  Future<UserModel?> getProfileData() async {
    final ApiResponse response = await dio.getData(url: "profile");
    if (response.isError == false) {
      Utils.userModel = UserModel.fromMap(response.response?.data['data']);
      return UserModel.fromMap(response.response?.data['data']);
    } else {
      return null;
    }
  }

  Future<Either<String, String>> like(
      {String? product_id, String? branchid}) async {
    final ApiResponse response = await dio.postData(
      url: "favorites",
      isForm: true,
      body: {
        "product_id": product_id,
        "branch_id": branchid,
      },
    );
    if (response.isError == false) {
      Alerts.snack(
          text: response.response?.data['message'] ??
              'تم اضافة المنتج الى المفضلة',
          state: SnackState.success);

      return Right(response.response?.data['data']?["product"]?["favourite_id"]
              ?.toString() ??
          "");
    } else {
      return Left(response.response?.data['message'] ?? "");
    }
  }

  Future<bool> disLike({String? product_id}) async {
    final ApiResponse response = await dio.deleteData(
      url: "favorites/$product_id",
      // isForm: true,
      // body: {
      //   "product_id": product_id,
      // },
    );
    if (response.isError == false) {
      Alerts.snack(
          text:
              response.response?.data['message'] ?? 'تم حذف المنتج من المفضلة',
          state: SnackState.success);
      return true;
    } else {
      return false;
    }
  }

  logout() async {
    final ApiResponse response =
        await dio.postData(url: "logout", isForm: true, loading: true
            // body: {
            //   "product_id": product_id,
            // },
            );
    if (response.isError == false) {
      Utils.dataManager.deleteUserData();

      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateDeliveryType(int type) async {
    String typename = type == 0 ? "delivery" : "pickup";
    final ApiResponse response = await dio.postData(
      url: "profile/update-type-delivery",
      isForm: true,
      body: {
        "type_delivery": typename,
      },
    );
    if (response.isError == false) {
      return true;
    } else {
      return false;
    }
  }
}
