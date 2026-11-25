import 'dart:developer';

import 'package:getincoffee/features/addresses/domain/model/addresses_model/addresses_model.dart';
import 'package:getincoffee/features/addresses/domain/model/addresses_model/datum.dart';
import 'package:getincoffee/features/addresses/domain/request/addresses_request.dart';

import '../../../../core/data_source/dio_helper.dart';

//put it in locators locator.registerLazySingleton(() => AddressesRepository(locator<DioService>()));
//  import '../../modules/addresses/domain/repository/repository.dart';
class AddressesRepository {
  final DioService dioService;
  AddressesRepository(this.dioService);
  Future<AddressesModel?> getAddresses() async {
    try {
      final response = await dioService.getData(url: "user-locations");
      if (response.isError == false) {
        return AddressesModel.fromJson(response.response?.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<AddresseData?> addAddress(AddressRequest addressRequest) async {
    try {
      final response = await dioService.postData(
        url: "user-locations",
        body: addressRequest.toFormData(),
        loading: true,
      );
      if (response.isError == false) {
        return AddresseData.fromJson(response.response?.data["data"]);
      } else {
        return null;
      }
    } catch (e, t) {
      log(t.toString(), name: "addAddress");
      log(e.toString(), name: "addAddress");

      return null;
    }
  }

  Future<dynamic> deleteAddress(int id) async {
    try {
      final response = await dioService.deleteData(
        url: "user-locations/$id",
        loading: true,
      );
      if (response.isError == false) {
        return response.response?.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> updateAddress(int id, AddressRequest addressRequest) async {
    try {
      final response = await dioService.postData(
        url: "user-locations/$id/edit",
        body: addressRequest.toFormData(),
      );
      if (response.isError == false) {
        return response.response?.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
