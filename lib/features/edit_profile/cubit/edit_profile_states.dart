import 'package:getincoffee/features/edit_profile/domain/model/edit_profile_model.dart';

abstract class EditProfileStates {}

class EditProfileInitial extends EditProfileStates {}

class GetProfileLoading extends EditProfileStates {}

class GetProfileSuccess extends EditProfileStates {
  final EditProfileModel? response;

  GetProfileSuccess(this.response);
}

class GetProfileFailure extends EditProfileStates {
  final String error;

  GetProfileFailure(this.error);
}

class UpdateProfileLoading extends EditProfileStates {}

class UpdateProfileSuccess extends EditProfileStates {
  final String? response;

  UpdateProfileSuccess(this.response);
}

class UpdateProfileFailure extends EditProfileStates {
  final String error;

  UpdateProfileFailure(this.error);
}
