import 'package:getincoffee/core/utils/utils.dart';
import 'package:getincoffee/features/edit_profile/domain/model/edit_profile_model.dart';
import 'package:getincoffee/features/edit_profile/domain/request/edit_profile_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/Locator.dart';
import '../domain/repository/repository.dart';
import 'edit_profile_states.dart';

class EditProfileCubit extends Cubit<EditProfileStates> {
  EditProfileCubit() : super(EditProfileInitial());
  static EditProfileCubit get(context) => BlocProvider.of(context);

  EditProfileRepository editProfileRepository =
      locator<EditProfileRepository>();
  EditProfileModel? editProfileModel;
  Future<void> getProfile() async {
    emit(GetProfileLoading());
    try {
      final response = await editProfileRepository.getProfile();
      editProfileModel = response;
      Utils.userModel.totalPoints = response?.totalPoints.toString();
      Utils.userModel.totalStars = response?.totalStars.toString();
      Utils.userModel.image = response?.image;
      Utils.userModel.firstName = response?.firstName;
      Utils.userModel.lastName = response?.lastName;
      Utils.userModel.phone = response?.phoneNumber;

      emit(GetProfileSuccess(response));
    } catch (e) {
      emit(GetProfileFailure(e.toString()));
    }
  }

  Future<void> updateProfile(
    EditProfileRequest editProfileRequest,
  ) async {
    emit(UpdateProfileLoading());
    try {
      final response =
          await editProfileRepository.updateProfile(editProfileRequest);
      emit(UpdateProfileSuccess(response));
    } catch (e) {
      emit(UpdateProfileFailure(e.toString()));
    }
  }
}
