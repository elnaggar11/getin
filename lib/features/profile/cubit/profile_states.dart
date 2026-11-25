import 'package:getincoffee/features/edit_profile/domain/model/edit_profile_model.dart';
import 'package:getincoffee/features/profile/domain/model/setting_model.dart';

abstract class ProfileStates {}

class ProfileInitial extends ProfileStates {}

class ProfileLoading extends ProfileStates {}

class ProfileError extends ProfileStates {}

class settingLoading extends ProfileStates {}

class settingLoaded extends ProfileStates {
  final SiteSettingsModel? response;

  settingLoaded(this.response);
}

class settingError extends ProfileStates {}

class LogoutSuccess extends ProfileStates {}

class DeleteAccountSuccess extends ProfileStates {}

class GetProfileLoading extends ProfileStates {}

class GetProfileSuccess extends ProfileStates {
  final EditProfileModel? response;

  GetProfileSuccess(this.response);
}

class GetProfileFailure extends ProfileStates {
  final dynamic param1;

  GetProfileFailure(this.param1);
}
