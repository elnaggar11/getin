import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getincoffee/features/auth/cubit/auth_cubit.dart';
import '../../../../core/Router/Router.dart';
import '../../../../core/generated/images.dart';
import '../../../../core/localization/localization_helper.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../core/utils/extentions.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/custom_country_code_picker.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import 'clickable_agree_policy_privacy_widget.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({
    super.key,
    this.cubit,
  });

  final AuthCubit? cubit;

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  String _dialCode = '+90';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.cubit?.formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormFieldWidget(
                    onSaved: (value) =>
                        widget.cubit?.authRequest.firstName = value,
                    fixedlabel: LocalizationHelper.tr.first_name_R,
                    hintText: LocalizationHelper.tr.first_name,
                    validator: Utils.valid.defaultValidation,
                    borderRadius: 16,
                    backgroundColor: LightThemeColors.offwhite,
                    borderColor: LightThemeColors.primary.withOpacity(.12),
                    activeBorderColor: LightThemeColors.primary,
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 14,
                      vertical: 18,
                    ),
                  ),
                ),
                10.pw,
                Expanded(
                  child: TextFormFieldWidget(
                    onSaved: (value) =>
                        widget.cubit?.authRequest.lastName = value,
                    fixedlabel: LocalizationHelper.tr.last_name_R,
                    hintText: LocalizationHelper.tr.last_name,
                    validator: Utils.valid.defaultValidation,
                    borderRadius: 16,
                    backgroundColor: LightThemeColors.offwhite,
                    borderColor: LightThemeColors.primary.withOpacity(.12),
                    activeBorderColor: LightThemeColors.primary,
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 14,
                      vertical: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          14.ph,
          TextFormFieldWidget(
            onSaved: (value) => widget.cubit?.authRequest.phone = value,
            type: TextInputType.phone,
            validator: Utils.valid.phoneValidationByCountry(_dialCode),
            prefixWidget: CustomCountryCodePicker(
              initialSelection: '+90',
              onChanged: (country) {
                setState(() {
                  _dialCode = country.dialCode ?? '+90';
                });
                widget.cubit?.authRequest.countryKey =
                    country.dialCode ?? '+90';
              },
            ),
            suffixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 14),
              child: SvgPicture.asset(
                SvgAssets.phoelogin,
                width: 20,
                height: 20,
                fit: BoxFit.scaleDown,
              ),
            ),
            fixedlabel: LocalizationHelper.tr.phone_number_R,
            hintText: LocalizationHelper.tr.enter_your_number_here,
            borderRadius: 16,
            backgroundColor: LightThemeColors.offwhite,
            borderColor: LightThemeColors.primary.withOpacity(.12),
            activeBorderColor: LightThemeColors.primary,
            contentPadding: const EdgeInsetsDirectional.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
          18.ph,
          TextFormFieldWidget(
            controller: widget.cubit?.password,
            onSaved: (value) => widget.cubit?.authRequest.password = value,
            fixedlabel: LocalizationHelper.tr.password_R,
            password: true,
            hintText: LocalizationHelper.tr.enter_your_password_here,
            borderRadius: 16,
            backgroundColor: LightThemeColors.offwhite,
            borderColor: LightThemeColors.primary.withOpacity(.12),
            activeBorderColor: LightThemeColors.primary,
            contentPadding: const EdgeInsetsDirectional.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            validator: (val) {
              if (val?.isEmpty == true) {
                return LocalizationHelper.tr.required;
              }
              return null;
            },
          ),
          18.ph,
          TextFormFieldWidget(
            controller: widget.cubit?.confirmpassword,
            onSaved: (value) =>
                widget.cubit?.authRequest.password_confirmation = value,
            fixedlabel: LocalizationHelper.tr.confirm_password_R,
            password: true,
            hintText: LocalizationHelper.tr.enter_your_confirm_password_here,
            borderRadius: 16,
            backgroundColor: LightThemeColors.offwhite,
            borderColor: LightThemeColors.primary.withOpacity(.12),
            activeBorderColor: LightThemeColors.primary,
            contentPadding: const EdgeInsetsDirectional.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            validator: (val) {
              if (val != widget.cubit?.password.text) {
                return LocalizationHelper.tr.password_not_match;
              }
              if (val?.isEmpty == true) {
                return LocalizationHelper.tr.required;
              }
              return null;
            },
          ),
          18.ph,
          ClickableAgreePolicyPrivacyWidget(
            onChange: (val) {
              widget.cubit?.isAgree = val ?? false;
            },
            onPrivacyTap: () {
              Navigator.pushNamed(context, Routes.TermsScreen);
            },
            onTermsTap: () {
              Navigator.pushNamed(context, Routes.TermsScreen);
            },
          ),
        ],
      ),
    );
  }
}
