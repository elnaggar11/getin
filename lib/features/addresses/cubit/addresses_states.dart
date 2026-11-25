import 'package:getincoffee/features/addresses/domain/model/addresses_model/addresses_model.dart';

abstract class AddressesStates {}

class AddressesInitial extends AddressesStates {}

class AddAddressLoading extends AddressesStates {}

class AddAddressSuccess extends AddressesStates {
  final AddressesModel? response;

  AddAddressSuccess(this.response);
}

class AddAddressFailure extends AddressesStates {
  final String error;

  AddAddressFailure(this.error);
}

class GetAddressesLoading extends AddressesStates {}

class GetAddressesSuccess extends AddressesStates {
  final AddressesModel? response;

  GetAddressesSuccess(this.response);
}

class GetAddressesFailure extends AddressesStates {
  final String error;

  GetAddressesFailure(this.error);
}

class DeleteAddressLoading extends AddressesStates {}

class DeleteAddressSuccess extends AddressesStates {
  final dynamic addressesModel;

  DeleteAddressSuccess(this.addressesModel);
}

class DeleteAddressFailure extends AddressesStates {
  final String error;

  DeleteAddressFailure(this.error);
}

class UpdateAddressLoading extends AddressesStates {}

class UpdateAddressSuccess extends AddressesStates {
  final dynamic addressesModel;

  UpdateAddressSuccess(this.addressesModel);
}

class UpdateAddressFailure extends AddressesStates {
  final String error;

  UpdateAddressFailure(this.error);
}
