import '../../../../core/data_source/dio_helper.dart';
import '../request/paymentmethod_request.dart';

//put it in locators locator.registerLazySingleton(() => PaymentmethodRepository(locator<DioService>()));
//  import '../../modules/paymentmethod/domain/repository/repository.dart';
class PaymentmethodRepository {
  final DioService dioService;
  PaymentmethodRepository(this.dioService);

  getAllpaymentmethod() async {
    final ApiResponse response = await dioService.getData(
      url: "stripe/payment-method",
    );
    if (response.isError == false) {
      return response.response?.data;
    } else {
      return null;
    }
  }

  savePaymentmethod({PaymentmethodRequest? request}) async {
    final response = await dioService.postData(
      url: "stripe/payment-method/attach",
      isJson: true,
      body: {'payment_method': request?.id},
    );
    if (response.isError == false) {
      return true;
    } else {
      return null;
    }
  }

  detachPaymentMethod({required String paymentMethodId}) async {
    final response = await dioService.deleteData(
      url: "stripe/payment-method/detach",
      isJson: true,
      body: {'payment_method': paymentMethodId},
    );
    if (response.isError == false) {
      return true;
    } else {
      return null;
    }
  }
}
