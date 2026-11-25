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
import '../../../../../shared/widgets/edit_text_widget.dart';
import '../../../cubit/auth_cubit.dart';
import '../../../cubit/auth_states.dart';
import '../../widgets/auth_top_header.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.code,
    required this.phone,
  });

  final String code;
  final String phone;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is ResetPassSuccessState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.LoginSignupToggleScreen,
              (r) => false,
            );
          }
        },
        builder: (context, state) {
          final cubit = AuthCubit.get(context);
          final bool isLoading = state is ResetPassLoadingState;

          return Scaffold(
            backgroundColor: LightThemeColors.primary,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  AuthTopHeader(
                    showLogo: false,
                    showBack: true,
                    title: LocalizationHelper.tr.reset_password,
                    subtitle: LocalizationHelper.tr.choose_strong_password,
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
                      child: Form(
                        key: formKey,
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
                                      width: 90,
                                      height: 90,
                                      padding: const EdgeInsets.all(22),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF0F5F3),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: LightThemeColors.primary
                                              .withOpacity(0.08),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        SvgAssets.resetIcon,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    28.ph,
                                    TextFormFieldWidget(
                                      type: TextInputType.visiblePassword,
                                      controller: passwordController,
                                      hintText: LocalizationHelper
                                          .tr.enter_new_password_here,
                                      fixedlabel: LocalizationHelper
                                          .tr.set_new_password_required,
                                      password: true,
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
                                      validator: Utils.valid.passwordValidation,
                                      onSaved: (value) {
                                        cubit.authRequest.password = value;
                                      },
                                    ),
                                    18.ph,
                                    TextFormFieldWidget(
                                      type: TextInputType.visiblePassword,
                                      hintText: LocalizationHelper
                                          .tr.enter_password_confirmation,
                                      fixedlabel: LocalizationHelper
                                          .tr.confirm_new_password_required,
                                      password: true,
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
                                      onSaved: (value) => cubit.authRequest
                                          .password_confirmation = value,
                                      validator: (value) =>
                                          Utils.valid.confirmPasswordValidation(
                                        value,
                                        passwordController.text,
                                      ),
                                      controller: confirmPasswordController,
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
                                  title:
                                      LocalizationHelper.tr.save_new_password,
                                  onTap: () async {
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      formKey.currentState?.save();
                                      cubit.authRequest
                                        ..code = widget.code
                                        ..phone = widget.phone;
                                      cubit.resetPassword();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
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
