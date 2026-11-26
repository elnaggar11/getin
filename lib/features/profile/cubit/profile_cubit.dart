import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getincoffee/core/utils/utils.dart';
import 'package:getincoffee/features/edit_profile/domain/model/edit_profile_model.dart';
import 'package:getincoffee/features/edit_profile/domain/repository/repository.dart';
import 'package:getincoffee/features/profile/domain/model/setting_model.dart';
import '../../../core/utils/Locator.dart';
import '../domain/repository/repository.dart';
import 'profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitial());
  static ProfileCubit get(context) => BlocProvider.of(context);

  ProfileRepository profileRepository = locator<ProfileRepository>();
  EditProfileRepository editProfileRepository =
      locator<EditProfileRepository>();
  SiteSettingsModel? siteSettingsModel;
  EditProfileModel? profileModel;
  Future<void> getProfile() async {
    emit(GetProfileLoading());
    try {
      final response = await editProfileRepository.getProfile();
      profileModel = response;
      Utils.userModel.totalPoints = response!.totalPoints.toString();
      Utils.userModel.totalStars = response.totalStars.toString();
      Utils.userModel.image = response.image;
      if (response.isReviewAccount != null) {
        Utils.userModel.isReviewAccount = response.isReviewAccount;
      }
      if (response.allowedPaymentMethods != null) {
        Utils.userModel.allowedPaymentMethods = response.allowedPaymentMethods;
      }
      emit(GetProfileSuccess(response));
    } catch (e) {
      emit(GetProfileFailure(e.toString()));
    }
  }

  Future<SiteSettingData?> setting() async {
    if (siteSettingsModel != null) {
      return siteSettingsModel?.data;
    }
    emit(settingLoading());
    final response = await profileRepository.getSetting();
    if (response != null) {
      siteSettingsModel = response;
      emit(settingLoaded(response));
      return response.data;
    } else {
      emit(settingError());
      return null;
    }
  }

  Future<void> logout() async {
    final response = await profileRepository.logout();
    if (response == true) {
      Utils.clearUser();
      emit(LogoutSuccess());
    }
  }

  Future<void> deleteAccount() async {
    final response = await profileRepository.deleteAccount();
    if (response == true) {
      Utils.clearUser();
      emit(DeleteAccountSuccess());
    }
  }
}
