import 'package:getincoffee/features/cart/domain/model/cart_model.dart';

import '../../../../core/data_source/dio_helper.dart';

//put it in locators locator.registerLazySingleton(() => FavoriteRepository(locator<DioService>()));
//  import '../../modules/favorite/domain/repository/repository.dart';
class FavoriteRepository {
  final DioService dioService;
  FavoriteRepository(this.dioService);

  Future<List<ItemModel>?> getFavoritesProducts() async {
    final ApiResponse response = await dioService.getData(
      url: "favorites",
    );
    if (response.isError == false) {
      return List.from((response.response?.data['data'] as List)
          .map((e) => ItemModel.fromMap(e)));
    } else {
      return null;
    }
  }

  deleteAllfavorites() async {
    final ApiResponse response = await dioService.deleteData(
      url: "favorites",
      loading: true,
    );
    if (response.isError == false) {
      return true;
    } else {
      return false;
    }
  }

  deleteFavoriteProduct({String? id}) async {
    final ApiResponse response = await dioService.deleteData(
      url: "favorites/$id",
      loading: true,
    );
    if (response.isError == false) {
      return true;
    } else {
      return false;
    }
  }
}
