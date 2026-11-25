import 'package:getincoffee/features/auth/domain/request/auth_request.dart';

import '../../../../core/data_source/dio_helper.dart';

class AuthRepository {
  final DioService dioService;
  AuthRepository(this.dioService);

  login(AuthRequest login) async {
    final ApiResponse response = await dioService.postData(
      url: "auth/login",
      isJson: true,
      body: login.login(),
      loading: true,
    );
    if (response.isError == false) {
      return response.response?.data;
    } else {
      return response.response?.data;
    }
  }

  register(AuthRequest register) async {
    final ApiResponse response = await dioService.postData(
      url: "auth/register",
      isForm: true,
      body: register.register(),
      loading: true,
    );
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }

  verifyOtp({String? code, String? phone, String? countryKey}) async {
    final ApiResponse response = await dioService.postData(
      url: "auth/verify-otp",
      isForm: true,
      body: {
        "phone_number": phone,
        "country_key": countryKey,
        "otp": code,
      },
      loading: true,
    );
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }

  forgetPass({String? phone, String? countryKey}) async {
    final ApiResponse response = await dioService.postData(
      url: "auth/forget-password",
      isForm: true,
      body: {
        "phone_number": phone,
        "country_key": countryKey,
        // "otp": code,
      },
      loading: true,
    );
    if (response.isError == false) {
      return true;
    } else {
      return null;
    }
  }

  resendCode() async {
    final ApiResponse response = await dioService.postData(
      url: "auth/resend-otp",
      isForm: true,
      loading: true,
    );
    if (response.isError == false) {
      return true;
    } else {
      return null;
    }
  }

  resetPassword(AuthRequest request) async {
    final ApiResponse response = await dioService.postData(
      url: "auth/reset-password",
      isForm: true,
      loading: true,
      body: request.resertPassword(),
    );
    if (response.isError == false) {
      return true;
    } else {
      return null;
    }
  }
}
