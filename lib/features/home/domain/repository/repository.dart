import 'dart:developer';

import 'package:getincoffee/core/general/generalmodel.dart';
import 'package:getincoffee/core/services/location_service.dart';
import 'package:getincoffee/features/home/domain/model/slider_model.dart';
import 'package:getincoffee/features/home/domain/request/filter_request.dart';
import 'package:getincoffee/features/home/domain/request/home_request.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/data_source/dio_helper.dart';
import '../model/home_model.dart';

//put it in locators locator.registerLazySingleton(() => HomeRepository(locator<DioService>()));
//  import '../../modules/home/domain/repository/repository.dart';
class HomeRepository {
  final DioService dioService;
  HomeRepository(this.dioService);

  Future<BranchModel?> getBranches({
    String? name,
  }) async {
    Position? position =
        await LocationService.getCurrentLocationwithoutAskPermision();
    final ApiResponse response =
        await dioService.getData(url: "get-branchs", loading: true, query: {
      if (name != null && name.isNotEmpty) "name": name,
      if (position != null) "latitude": position.latitude,
      if (position != null) "longitude": position.longitude,
    });

    if (response.isError == false) {
      final branches = BranchModel.getall(response.response?.data);
      log("get-branchs returned ${branches.branches?.length ?? 0} branches");
      return branches;
    } else {
      return null;
    }
  }

  Future<PagedProducts?> getProductsByFilter(
      {required ProductFilter filter,
      required String branchId,
      int page = 1}) async {
    final ApiResponse response = await dioService.getData(
        url: "branch/$branchId/products/filter",
        query: filter.toQuery(page: page));

    if (response.isError == false) {
      return PagedProducts.fromOneMap(response.response?.data);
    } else {
      return null;
    }
  }

  Future<BranchModel?> userBranch({Position? position}) async {
    final ApiResponse response =
        await dioService.getData(url: "branch-user", loading: false, query: {
      if (position != null) "latitude": position.latitude,
      if (position != null) "longitude": position.longitude,
    });
    if (response.isError == false) {
      log(BranchModel.getall(response.response?.data).branches.toString());
      return BranchModel.getall(response.response?.data);
    } else {
      if (response.response?.data["message"] ==
          "Please activate your location") {
        print("Please activate your location");
        return BranchModel(branches: []);
      }
      return null;
    }
  }

  Future<BranchCategory?> getBranchCategories({String? id}) async {
    final ApiResponse response = await dioService.getData(
      url: "branch/categories/$id",
    );
    if (response.isError == false) {
      return BranchCategory.getall(response.response?.data);
    } else {
      return null;
    }
  }

  getBranchproducts({String? id, ProductParams? params}) async {
    final ApiResponse response = await dioService.getData(
        url: "branch/$id/products", query: params?.toMap(), loading: false);
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }

  saveBranchtoUser({String? id}) async {
    final ApiResponse response = await dioService.postData(
      url: "branch-user",
      isFile: true,
      isForm: true,
      loading: true,
      body: {
        "branch_id": id,
      },
    );

    if (response.isError == false) {
      return true;
    } else {
      return null;
    }
  }

  deleteBranchtoUser({String? id}) async {
    final ApiResponse response = await dioService.deleteData(
      url: "branch-user/$id",
      loading: true,
    );

    if (response.isError == false) {
      return true;
    } else {
      return null;
    }
  }

  Future<List<GeneralModel>?> getHomeSliders() async {
    final ApiResponse response = await dioService.getData(
      url: "advertisement-image",
    );
    if (response.isError == false) {
      return List.from((response.response?.data["data"] as List)
          .map((e) => GeneralModel.fromMap(e)));
    } else {
      return null;
    }
  }

  Future<HomeAdsModel?> getHomeAds() async {
    final ApiResponse response = await dioService.getData(
      url: "home",
    );
    if (response.isError == false) {
      return HomeAdsModel.fromMap(response.response?.data["data"]);
    } else {
      return null;
    }
  }

  getHomeText() async {
    final ApiResponse response = await dioService.getData(
      url: "advertisement-text",
    );
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }

  getAllnotifications() async {
    final ApiResponse response = await dioService.getData(
      url: "notifications",
    );
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }
}
