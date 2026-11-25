import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/core/utils/utils.dart';
import 'package:getincoffee/features/addresses/cubit/addresses_cubit.dart';
import 'package:getincoffee/features/addresses/cubit/addresses_states.dart';
import 'package:getincoffee/features/addresses/domain/request/addresses_request.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:getincoffee/shared/widgets/edit_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CreateAddreessSheetBody extends StatefulWidget {
  const CreateAddreessSheetBody({super.key});

  @override
  State<CreateAddreessSheetBody> createState() =>
      _CreateAddreessSheetBodyState();
}

class _CreateAddreessSheetBodyState extends State<CreateAddreessSheetBody> {
  AddressRequest addressRequest = AddressRequest();
  final formKey = GlobalKey<FormState>();
  final locationController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressesCubit, AddressesStates>(
      listener: (context, state) {
        if (state is AddAddressSuccess) {
          Navigator.pop(context);
          Alerts.snack(
            text: LocalizationHelper.tr.address_added_successfully,
            state: SnackState.success,
          );
        }
      },
      child: Container(
        height: MediaQuery.sizeOf(context).height * .8,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
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
                    validator: Utils.valid.defaultValidation,
                    onSaved: (value) {
                      addressRequest.apartment = value;
                    },
                  ),
                  27.ph,
                  TextFormFieldWidget(
                    hintText: LocalizationHelper.tr.address_description,
                    fixedlabel: LocalizationHelper.tr.address_description,
                    validator: Utils.valid.defaultValidation,
                    onSaved: (value) {
                      addressRequest.addressDescription = value;
                    },
                  ),
                  27.ph,
                  TextFormFieldWidget(
                    hintText: LocalizationHelper.tr.address_title_examples,
                    fixedlabel: LocalizationHelper.tr.address_title_required,
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
                    title: LocalizationHelper.tr.save_my_address,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        AddressesCubit.get(context).addAddress(addressRequest);
                      }
                    },
                  ),
                  37.ph,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
