import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getincoffee/features/auth/cubit/auth_cubit.dart';
import '../../../../core/Router/Router.dart';
import '../../../../core/generated/images.dart';
import '../../../../core/localization/localization_helper.dart';
import '../../../../core/resources/font_manager.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../core/utils/extentions.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/custom_country_code_picker.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import 'agree_policy_privacy_widget.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({
    super.key,
    this.cubit,
  });

  final AuthCubit? cubit;

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
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
            child: TextFormFieldWidget(
              validator: Utils.valid.phoneValidationByCountry(_dialCode),
              onChanged: (value) {
                widget.cubit?.authRequest.phone = value;
              },
              type: TextInputType.phone,
              borderRadius: 16,
              backgroundColor: LightThemeColors.offwhite,
              borderColor: LightThemeColors.primary.withOpacity(.12),
              activeBorderColor: LightThemeColors.primary,
              contentPadding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
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
              fixedlabel: LocalizationHelper.tr.phone_number_required,
              hintText: LocalizationHelper.tr.enter_your_number_here,
            ),
          ),
          14.ph,
          TextFormFieldWidget(
            onSaved: (value) => widget.cubit?.authRequest.password = value,
            validator: Utils.valid.defaultValidation,
            fixedlabel: LocalizationHelper.tr.password,
            password: true,
            hintText: LocalizationHelper.tr.enter_password,
            borderRadius: 16,
            backgroundColor: LightThemeColors.offwhite,
            borderColor: LightThemeColors.primary.withOpacity(.12),
            activeBorderColor: LightThemeColors.primary,
            contentPadding: const EdgeInsetsDirectional.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
          16.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: AgreePolicyPrivacyWidget(
                  title: LocalizationHelper.tr.remember_me,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.forgetPassScreen,
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  child: Text(
                    LocalizationHelper.tr.forgot_your_password,
                    style: TextStyles.font12BlackBold.copyWith(
                      fontWeight: FontWeights.semiBold,
                      fontSize: 13,
                      color: LightThemeColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
