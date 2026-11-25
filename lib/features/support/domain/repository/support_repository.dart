import 'package:getincoffee/core/data_source/dio_helper.dart';
import 'package:getincoffee/features/support/domain/model/support_model.dart';

class SupportRepository {
  final DioService dio;

  SupportRepository(this.dio);

  Future<SupportModel?> getSupport() async {
    final ApiResponse response = await dio.getData(
      url: "support",
      loading: true,
    );
    if (response.isError == false) {
      final data = response.response?.data["data"];
      if (data != null) {
        return SupportModel.fromJson(data);
      }
    }
    return null;
  }
}
