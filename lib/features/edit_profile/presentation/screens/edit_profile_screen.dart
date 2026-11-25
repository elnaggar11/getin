import 'package:getincoffee/core/localization/localization_helper.dart';
import 'dart:io';

import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/utils.dart';
import 'package:getincoffee/features/edit_profile/domain/request/edit_profile_request.dart';
import 'package:getincoffee/features/edit_profile/presentation/widgets/edit_profile_image.dart';
import 'package:getincoffee/shared/widgets/custom_country_code_picker.dart';
import 'package:getincoffee/shared/widgets/edit_text_widget.dart';
import 'package:getincoffee/shared/widgets/loadinganderror.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/colored_container.dart';
import '../../cubit/edit_profile_cubit.dart';
import '../../cubit/edit_profile_states.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  File? image;
  String countryKey = "+90";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileCubit()..getProfile(),
      child: BlocConsumer<EditProfileCubit, EditProfileStates>(
        listener: (context, state) {
          if (state is GetProfileSuccess) {
            firstNameController.text = state.response!.firstName;
            lastNameController.text = state.response!.lastName;

            String phone = state.response!.phoneNumber;
            countryKey = state.response!.countryKey;

            phoneNumberController.text = phone;
          }
          if (state is UpdateProfileSuccess) {
            // Navigator.pop(context);
            Alerts.snack(
              text: state.response ??
                  LocalizationHelper.tr.update_profile_success,
              state: SnackState.success,
            );
          }
        },
        builder: (context, state) {
          final cubit = EditProfileCubit.get(context);
          return Scaffold(
            // key: scafoldKey,
            backgroundColor: LightThemeColors.white,
            appBar: AppBar(
              actions: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Icon(
                    Icons.menu,
                  ),
                ).onTap(
                  () {
                    Utils.scaffoldKey.currentState?.openDrawer();
                  },
                )
              ],
              // leading: const BackWidget(),
              centerTitle: false,
              title: Text(
                LocalizationHelper.tr.profile_settings,
                style: const TextStyle(
                  color: LightThemeColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            body: LoadingAndError(
              isLoading: state is GetProfileLoading,
              isError: state is GetProfileFailure,
              function: () {
                cubit.getProfile();
              },
              child: Form(
                key: formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const SizedBox(height: 16),
                    EditProfileImage(
                      onImageSelected: (selectedImage) {
                        image = selectedImage;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 60,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormFieldWidget(
                              fixedlabel: LocalizationHelper.tr.first_name_R,
                              hintText: LocalizationHelper.tr.first_name,
                              controller: firstNameController,
                              onChanged: (value) {},
                              validator: Utils.valid.defaultValidation,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormFieldWidget(
                              fixedlabel: LocalizationHelper.tr.last_name_R,
                              hintText: LocalizationHelper.tr.last_name,
                              controller: lastNameController,
                              validator: Utils.valid.defaultValidation,

                              //   hintText: 'Enter your name',
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35),
                    TextFormFieldWidget(
                      fixedlabel: LocalizationHelper.tr.phone_number_R,
                      hintText: LocalizationHelper.tr.enter_your_number_here,
                      //  suffixIcon:SvgAssets.phone.toSvg(),
                      validator: Utils.valid.phoneValidationByCountry(countryKey),

                      prefixWidget: CustomCountryCodePicker(
                        initialSelection: countryKey,
                        onChanged: (country) {
                          setState(() {
                            countryKey = country.dialCode ?? '+90';
                          });
                        },
                      ),
                      type: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: phoneNumberController,
                      //   hintText: 'Enter your name',
                      onChanged: (value) {},
                    ),
                    //  const SizedBox(height: 35),

                    const SizedBox(height: 35),
                    /*  TextFormFieldWidget(
                      fixedlabel: LocalizationHelper.tr.password_R,
                      hintText: LocalizationHelper.tr.enter_your_password_here,
                      controller: passwordController,
                      //   hintText: 'Enter your name',
                      onChanged: (value) {},

                      password: true,
                    ), */
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          cubit.updateProfile(
                            EditProfileRequest(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              phoneNumber: phoneNumberController.text,
                              countryKey: countryKey,
                              password: passwordController.text,
                              image: image,
                            ),
                          );
                        }
                      },
                      child: ColoredContainer(
                        height: 58,
                        color: LightThemeColors.primary,
                        child: Center(
                          child: Text(
                            LocalizationHelper.tr.save_action,
                            style: const TextStyle(
                              color: LightThemeColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
