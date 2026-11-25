import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/Router/Router.dart';
import '../../../../../core/generated/images.dart';
import '../../../../../core/localization/localization_helper.dart';
import '../../../../../core/theme/light_theme.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/widgets/button_widget.dart';
import '../../../../../shared/widgets/custom_country_code_picker.dart';
import '../../../../../shared/widgets/edit_text_widget.dart';
import '../../../cubit/auth_cubit.dart';
import '../../../cubit/auth_states.dart';
import '../../widgets/auth_top_header.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  String _dialCode = '+90';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          final cubit = AuthCubit.get(context);
          if (state is ForgetPassSuccessState) {
            Navigator.pushNamed(
              context,
              Routes.otpScreen,
              arguments: OtpArguments(
                sendTo: cubit.authRequest.phone ??
                    LocalizationHelper.tr.unspecified_phrase,
                onSubmit: (p0) {
                  cubit.code = p0;
                  cubit.verifycode(code: p0);
                },
                onReSend: () {
                  cubit.resendcode();
                },
              ),
            );
          }
          if (state is ActivateCodeSuccessState) {
            Navigator.pushNamed(
              context,
              Routes.resetPasswordScreen,
              arguments: NewPasswordArgs(
                code: cubit.code,
                phone: cubit.authRequest.phone ??
                    LocalizationHelper.tr.unspecified_phrase,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = AuthCubit.get(context);
          final bool isLoading = state is ForgetPassLoadingState;

          return Scaffold(
            backgroundColor: LightThemeColors.primary,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  AuthTopHeader(
                    showLogo: false,
                    showBack: true,
                    title: LocalizationHelper.tr.forgot_your_password,
                    subtitle: LocalizationHelper.tr.enter_phone_linked_account,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      decoration: const BoxDecoration(
                        color: LightThemeColors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(32)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 20,
                            offset: Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              child: Column(
                                children: [
                                  32.ph,
                                  Container(
                                    width: 100,
                                    height: 100,
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF0F5F3),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: LightThemeColors.primary
                                            .withOpacity(0.08),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Image.asset(
                                      ImgAssets.forgetPassIco,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  28.ph,
                                  Form(
                                    key: formKey,
                                    child: TextFormFieldWidget(
                                      onSaved: (value) {
                                        cubit.authRequest.phone = value;
                                      },
                                      validator: Utils.valid
                                          .phoneValidationByCountry(_dialCode),
                                      type: TextInputType.phone,
                                      borderRadius: 16,
                                      backgroundColor:
                                          LightThemeColors.offwhite,
                                      borderColor: LightThemeColors.primary
                                          .withOpacity(.12),
                                      activeBorderColor:
                                          LightThemeColors.primary,
                                      contentPadding:
                                          const EdgeInsetsDirectional.symmetric(
                                        horizontal: 16,
                                        vertical: 18,
                                      ),
                                      prefixWidget: CustomCountryCodePicker(
                                        initialSelection: '+90',
                                        onChanged: (country) {
                                          setState(() {
                                            _dialCode =
                                                country.dialCode ?? '+90';
                                          });
                                          cubit.authRequest.countryKey =
                                              country.dialCode ?? '+90';
                                        },
                                      ),
                                      suffixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                end: 14),
                                        child: SvgPicture.asset(
                                          SvgAssets.phoelogin,
                                          width: 20,
                                          height: 20,
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                      fixedlabel: LocalizationHelper
                                          .tr.phone_number_required,
                                      hintText: LocalizationHelper
                                          .tr.enter_your_number_here,
                                    ),
                                  ),
                                  24.ph,
                                ],
                              ),
                            ),
                          ),
                          SafeArea(
                            top: false,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 20),
                              child: ButtonWidget(
                                witharrows: !isLoading,
                                isLoading: isLoading,
                                onTap: () {
                                  if (formKey.currentState?.validate() ??
                                      false) {
                                    formKey.currentState?.save();
                                    cubit.forgetPassword();
                                  }
                                },
                                title: LocalizationHelper.tr.get_code_now,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
