import 'package:getincoffee/features/addresses/domain/model/addresses_model/addresses_model.dart';
import 'package:getincoffee/features/addresses/domain/request/addresses_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/Locator.dart';
import '../domain/repository/repository.dart';
import 'addresses_states.dart';

class AddressesCubit extends Cubit<AddressesStates> {
  AddressesCubit() : super(AddressesInitial()) {
    _getAddresses();
  }

  static AddressesCubit get(context) => BlocProvider.of(context);

  AddressesRepository addressesRepository = locator<AddressesRepository>();
  void reset() {
    emit(AddressesInitial());
    _getAddresses();
  }

  Future<void> addAddress(AddressRequest addressRequest) async {
    emit(AddAddressLoading());
    try {
      final response = await addressesRepository.addAddress(addressRequest);
      if (response != null) {
        emit(AddAddressSuccess(addressesModel));
        _getAddresses();
      } else {
        emit(AddAddressFailure("Failed to save address"));
      }
    } catch (e) {
      emit(AddAddressFailure(e.toString()));
    }
  }

  AddressesModel? addressesModel;
  Future<void> _getAddresses() async {
    emit(GetAddressesLoading());
    try {
      final response = await addressesRepository.getAddresses();
      if (response != null) {
        addressesModel = response;
        emit(GetAddressesSuccess(response));
      } else {
        emit(GetAddressesFailure("Failed to get addresses"));
      }
    } catch (e) {
      emit(GetAddressesFailure(e.toString()));
    }
  }

  Future<void> deleteAddress(int id) async {
    emit(DeleteAddressLoading());
    try {
      final response = await addressesRepository.deleteAddress(id);
      if (response != null) {
        _getAddresses();
        emit(DeleteAddressSuccess(addressesModel));
      } else {
        emit(DeleteAddressFailure("Failed to delete address"));
      }
    } catch (e) {
      emit(DeleteAddressFailure(e.toString()));
    }
  }

  Future<void> updateAddress(int id, AddressRequest addressRequest) async {
    emit(UpdateAddressLoading());
    try {
      final response =
          await addressesRepository.updateAddress(id, addressRequest);
      if (response != null) {
        _getAddresses();
        emit(UpdateAddressSuccess(addressesModel));
      } else {
        emit(UpdateAddressFailure("Failed to update address"));
      }
    } catch (e) {
      emit(UpdateAddressFailure(e.toString()));
    }
  }
}
