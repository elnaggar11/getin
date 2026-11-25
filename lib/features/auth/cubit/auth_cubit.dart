import 'package:getincoffee/core/general/cubit/general_cubit.dart';
import 'package:getincoffee/core/utils/utils.dart';
import 'package:getincoffee/features/auth/domain/request/auth_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/data_source/dio_helper.dart';
import '../../../core/utils/Locator.dart';
import '../domain/repository/auth_repository.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);

  AuthRepository authRepository = AuthRepository(locator<DioService>());
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  AuthRequest authRequest = AuthRequest();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  String code = "";
  bool isAgree = false;
  register() async {
    emit(RegisterLoadingState());
    final response = await authRepository.register(authRequest);
    if (response != null) {
      // Utils.saveUserInHive(response);
      emit(RegisterSuccessState());
    } else {
      emit(RegisterErrorState());
    }
  }

  login() async {
    emit(LoginLoadingState());
    final response = await authRepository.login(authRequest);
    if (response != null && response is Map<String, dynamic>) {
      if (response["key"] == "verify_otp") {
        emit(LoginVerifyOtpState());
      } else if (response["status"] == true || response["key"] == "success") {
        final dynamic data = response["data"];
        if (data is Map<String, dynamic>) {
          Utils.saveUserInHive(data);
          locator<GeneralCubit>().updateDeliveryType(
              Utils.userModel.typeDelivery == "delivery" ? 0 : 1);
          emit(LoginSuccessState());
        } else if (response.containsKey("token") ||
            response.containsKey("access_token")) {
          Utils.saveUserInHive(response);
          locator<GeneralCubit>().updateDeliveryType(
              Utils.userModel.typeDelivery == "delivery" ? 0 : 1);
          emit(LoginSuccessState());
        } else {
          emit(LoginErrorState());
        }
      } else {
        emit(LoginErrorState());
      }
    } else {
      emit(LoginErrorState());
    }
  }

  resendcode() async {
    final response = await authRepository.resendCode();
    if (response != null) {
      return true;
    } else {
      return null;
    }
  }

  resetPassword() async {
    emit(ResetPassLoadingState());
    final response = await authRepository.resetPassword(
      authRequest,
    );
    if (response != null) {
      emit(ResetPassSuccessState());
    } else {
      emit(ResetPassErrorState());
    }
  }

  verifycode({String? code}) async {
    emit(ActivateCodeLoadingState());
    final response = await authRepository.verifyOtp(
      code: code,
      countryKey: authRequest.countryKey,
      phone: authRequest.phone,
    );
    if (response != null) {
      Utils.saveUserInHive(response);
      this.code = code ?? "";
      emit(ActivateCodeSuccessState());
      return true;
    } else {
      emit(ActivateCodeErrorState());
      return null;
    }
  }

  forgetPassword() async {
    emit(ForgetPassLoadingState());
    final response = await authRepository.forgetPass(
      phone: authRequest.phone,
      countryKey: authRequest.countryKey,
    );
    if (response != null) {
      emit(ForgetPassSuccessState());
    } else {
      emit(ForgetPassErrorState());
    }
  }

  @override
  Future<void> close() {
    phone.dispose();
    password.dispose();
    confirmpassword.dispose();
    return super.close();
  }
}
