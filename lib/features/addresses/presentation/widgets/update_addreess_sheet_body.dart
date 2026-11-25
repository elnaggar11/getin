import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/core/utils/utils.dart';
import 'package:getincoffee/features/addresses/cubit/addresses_cubit.dart';
import 'package:getincoffee/features/addresses/cubit/addresses_states.dart';
import 'package:getincoffee/features/addresses/domain/model/addresses_model/datum.dart';
import 'package:getincoffee/features/addresses/domain/request/addresses_request.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:getincoffee/shared/widgets/edit_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class UpdateAddreessSheetBody extends StatefulWidget {
  const UpdateAddreessSheetBody({super.key, required this.addressModel});
  final AddresseData addressModel;
  @override
  State<UpdateAddreessSheetBody> createState() =>
      _UpdateAddreessSheetBodyState();
}

class _UpdateAddreessSheetBodyState extends State<UpdateAddreessSheetBody> {
  AddressRequest addressRequest = AddressRequest();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController buildingNumberController =
      TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController addressDescriptionController =
      TextEditingController();
  final TextEditingController addressTitleController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  @override
  void initState() {
    locationController.text = widget.addressModel.nameAddress?.toString() ??
        LocalizationHelper.tr.unspecified_phrase;
    nameController.text = widget.addressModel.nameAddress ??
        LocalizationHelper.tr.unspecified_phrase;
    buildingNumberController.text = widget.addressModel.buildingNumber ??
        LocalizationHelper.tr.unspecified_phrase;
    floorController.text =
        widget.addressModel.floor ?? LocalizationHelper.tr.unspecified_phrase;
    apartmentController.text = widget.addressModel.apartment ??
        LocalizationHelper.tr.unspecified_phrase;
    addressDescriptionController.text =
        widget.addressModel.addressDescription ??
            LocalizationHelper.tr.unspecified_phrase;
    addressTitleController.text = widget.addressModel.addressTitle ??
        LocalizationHelper.tr.unspecified_phrase;
    latitudeController.text = widget.addressModel.latitude?.toString() ??
        LocalizationHelper.tr.unspecified_phrase;
    longitudeController.text = widget.addressModel.longitude?.toString() ??
        LocalizationHelper.tr.unspecified_phrase;
    firstNameController.text = widget.addressModel.firstName ??
        LocalizationHelper.tr.unspecified_phrase;
    lastNameController.text = widget.addressModel.lastName ??
        LocalizationHelper.tr.unspecified_phrase;
    phoneNumberController.text = widget.addressModel.phoneNumber ??
        LocalizationHelper.tr.unspecified_phrase;
    addressRequest = AddressRequest(
      nameAddress: widget.addressModel.nameAddress,
      buildingNumber: widget.addressModel.buildingNumber,
      floor: widget.addressModel.floor,
      apartment: widget.addressModel.apartment,
      addressDescription: widget.addressModel.addressDescription,
      addressTitle: widget.addressModel.addressTitle,
      latitude: widget.addressModel.latitude?.toDouble(),
      longitude: widget.addressModel.longitude?.toDouble(),
      firstName: widget.addressModel.firstName,
      lastName: widget.addressModel.lastName,
      phoneNumber: widget.addressModel.phoneNumber,
    );
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    buildingNumberController.dispose();
    floorController.dispose();
    apartmentController.dispose();
    addressDescriptionController.dispose();
    addressTitleController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressesCubit, AddressesStates>(
      listener: (context, state) {
        if (state is UpdateAddressSuccess) {
          Navigator.pop(context);
          Alerts.snack(
            text: LocalizationHelper.tr.address_updated_successfully,
            state: SnackState.success,
          );
        }
      },
      child: Container(
        height: MediaQuery.sizeOf(context).height * .8,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                61.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocalizationHelper.tr.address_information,
                      style: TextStyles.font14BlackMedium.copyWith(
                        color: LightThemeColors.black,
                        fontWeight: FontWeights.extraBold,
                      ),
                    ),
                    SvgPicture.asset(
                      SvgAssets.cannerIcon,
                    ),
                  ],
                ),
                20.ph,
                const Divider(
                  thickness: 1,
                  height: 0,
                  color: LightThemeColors.darkwhite,
                ),
                30.ph,
                Container(
                  padding: const EdgeInsets.all(
                    10,
                  ),
                  decoration: BoxDecoration(
                    color: LightThemeColors.orange,
                    borderRadius: BorderRadius.circular(
                      40,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: LightThemeColors.white,
                              borderRadius: BorderRadius.circular(
                                24,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 18,
                                height: 18,
                                color: LightThemeColors.primary,
                              ),
                            ),
                          ),
                          10.pw,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocalizationHelper.tr.sample_address,
                                style: TextStyles.font12BlackBold.copyWith(
                                  color: LightThemeColors.primary,
                                  fontWeight: FontWeights.semiBold,
                                ),
                              ),
                              10.ph,
                              Text(
                                LocalizationHelper.tr.deliver_to_home,
                                style: TextStyles.font12BlackBold.copyWith(
                                  color: LightThemeColors.grey,
                                  fontWeight: FontWeights.regular,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                15.ph,
                Text(
                  LocalizationHelper.tr.address_information,
                  style: TextStyles.font14BlackBold.copyWith(
                    fontWeight: FontWeights.extraBold,
                    color: LightThemeColors.black,
                  ),
                ),
                32.ph,
                TextFormFieldWidget.mapPicker(
                  hintText: LocalizationHelper.tr.enter_your_location,
                  fixedlabel: LocalizationHelper.tr.location,
                  controller: locationController,
                  // validator: Utils.valid.defaultValidation,
                  onLocationSelected: (latLang, placeMark) {
                    addressRequest.latitude = latLang?.latitude;
                    addressRequest.longitude = latLang?.longitude;
                  },
                ),
                27.ph,
                TextFormFieldWidget(
                  hintText: LocalizationHelper.tr.enter_name_address,
                  fixedlabel: LocalizationHelper.tr.name_address,
                  controller: nameController,
                  validator: Utils.valid.defaultValidation,
                  onSaved: (value) {
                    addressRequest.nameAddress = value;
                  },
                ),
                27.ph,
                Row(
                  children: [
                    Expanded(
                      child: TextFormFieldWidget(
                        hintText: LocalizationHelper.tr.building_number,
                        controller: buildingNumberController,
                        fixedlabel: LocalizationHelper.tr.building_number,
                        validator: Utils.valid.defaultValidation,
                        type: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onSaved: (value) {
                          addressRequest.buildingNumber = value;
                        },
                      ),
                    ),
                    10.pw,
                    Expanded(
                      child: TextFormFieldWidget(
                        hintText: LocalizationHelper.tr.floor,
                        controller: floorController,
                        fixedlabel: LocalizationHelper.tr.floor,
                        validator: Utils.valid.defaultValidation,
                        type: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onSaved: (value) {
                          addressRequest.floor = value;
                        },
                      ),
                    ),
                  ],
                ),
                27.ph,
                TextFormFieldWidget(
                  hintText: LocalizationHelper.tr.apartment,
                  fixedlabel: LocalizationHelper.tr.apartment,
                  controller: apartmentController,
                  validator: Utils.valid.defaultValidation,
                  onSaved: (value) {
                    addressRequest.apartment = value;
                  },
                ),
                27.ph,
                TextFormFieldWidget(
                  hintText: " Address Description",
                  fixedlabel: " Address Description",
                  controller: addressDescriptionController,
                  validator: Utils.valid.defaultValidation,
                  onSaved: (value) {
                    addressRequest.addressDescription = value;
                  },
                ),
                27.ph,
                TextFormFieldWidget(
                  hintText: "(My Home Address, My Work Address)",
                  fixedlabel: LocalizationHelper.tr.address_description,
                  controller: addressTitleController,
                  validator: Utils.valid.defaultValidation,
                  onSaved: (value) {
                    addressRequest.addressTitle = value;
                  },
                ),
                15.ph,
                Text(
                  LocalizationHelper.tr.address_information,
                  style: TextStyles.font14BlackBold.copyWith(
                    fontWeight: FontWeights.extraBold,
                    color: LightThemeColors.black,
                  ),
                ),
                27.ph,
                Row(
                  children: [
                    Expanded(
                      child: TextFormFieldWidget(
                        hintText: LocalizationHelper.tr.first_name,
                        fixedlabel: LocalizationHelper.tr.first_name,
                        controller: firstNameController,
                        validator: Utils.valid.defaultValidation,
                        onSaved: (value) {
                          addressRequest.firstName = value;
                        },
                      ),
                    ),
                    10.pw,
                    Expanded(
                      child: TextFormFieldWidget(
                        hintText: LocalizationHelper.tr.last_name,
                        fixedlabel: LocalizationHelper.tr.last_name,
                        controller: lastNameController,
                        validator: Utils.valid.defaultValidation,
                        onSaved: (value) {
                          addressRequest.lastName = value;
                        },
                      ),
                    ),
                  ],
                ),
                27.ph,
                TextFormFieldWidget(
                  hintText: LocalizationHelper.tr.mobile_phone,
                  fixedlabel: LocalizationHelper.tr.mobile_phone,
                  controller: phoneNumberController,
                  validator: Utils.valid.defaultValidation,
                  type: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onSaved: (value) {
                    addressRequest.phoneNumber = value;
                  },
                ),
                15.ph,
                ButtonWidget(
                  title: LocalizationHelper.tr.save_address,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      AddressesCubit.get(context).updateAddress(
                          widget.addressModel.id!, addressRequest);
                    }
                  },
                ),
                37.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
