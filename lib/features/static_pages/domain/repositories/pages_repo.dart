import 'package:getincoffee/core/data_source/dio_helper.dart';

class StaticRepositories {
  DioService dio;

  StaticRepositories(this.dio);
  gettermspage() async {
    final ApiResponse response = await dio.getData(
      url: "user/terms-conditions",
      loading: true,
    );
    if (response.isError == false) {
      return response.response?.data["data"];
    }
    return null;
  }
}
