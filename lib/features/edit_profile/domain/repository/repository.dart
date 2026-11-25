import 'package:getincoffee/features/edit_profile/domain/request/edit_profile_request.dart';


import '../model/edit_profile_model.dart';
import '../../../../core/data_source/dio_helper.dart';

//put it in locators locator.registerLazySingleton(() => EditProfileRepository(locator<DioService>()));
//  import '../../modules/edit_profile/domain/repository/repository.dart';
class EditProfileRepository {
  final DioService dioService;
  EditProfileRepository(this.dioService);
  Future<EditProfileModel?> getProfile() async {
    final response = await dioService.getData(
      url: "profile",
    );
    if (response.isError == false) {
      return EditProfileModel.fromJson(response.response?.data['data']);
    } else {
      return null;
    }
  }

  Future<String?> updateProfile(EditProfileRequest editProfileRequest) async {
    final response = await dioService.postData(
      url: "profile/update",
      loading: true,
      isFile: (editProfileRequest.image != null),
      isForm: true,
      body: await editProfileRequest.toJson(),
    );
    if (response.isError == false) {
      return response.response?.data['message'];
    } else {
      return null;
    }
  }
}
