import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/Router/Router.dart';
import '../../../../../core/localization/localization_helper.dart';
import '../../../../../shared/widgets/button_widget.dart';
import '../../../cubit/auth_cubit.dart';
import '../../../cubit/auth_states.dart';
import '../../widgets/login_body.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          final cubit = AuthCubit.get(context);
          if (state is LoginSuccessState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.layoutScreen,
              (r) => false,
            );
          } else if (state is LoginVerifyOtpState) {
            Navigator.pushNamed(
              context,
              Routes.otpScreen,
              arguments: OtpArguments(
                sendTo: cubit.authRequest.phone ??
                    LocalizationHelper.tr.unspecified_phrase,
                onSubmit: (p0) {
                  cubit.verifycode(code: p0);
                },
                onReSend: () {
                  cubit.resendcode();
                },
              ),
            );
          } else if (state is ActivateCodeSuccessState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.layoutScreen,
              (r) => false,
            );
          }
        },
        builder: (context, state) {
          final cubit = AuthCubit.get(context);
          final bool isLoading = state is LoginLoadingState;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.only(top: 10, bottom: 16),
                  child: LoginBody(cubit: cubit),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom:
                        MediaQuery.viewInsetsOf(context).bottom > 0 ? 12 : 20,
                  ),
                  child: ButtonWidget(
                    witharrows: !isLoading,
                    isLoading: isLoading,
                    title: LocalizationHelper.tr.sign_in,
                    onTap: () {
                      if (cubit.formkey.currentState?.validate() ?? false) {
                        cubit.formkey.currentState?.save();
                        cubit.login();
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
