import 'package:getincoffee/core/utils/utils.dart';

class AuthRequest {
  String? firstName;
  String? lastName;

  String? phone;
  String countryKey = '+90';

  String? token;
  String? password;
  String? code;

  String? fcm_token;
  String? password_confirmation;
  AuthRequest({
    this.firstName,
    this.lastName,
    this.phone,
    this.fcm_token,
    this.token,
    this.password,
    this.password_confirmation,
  }) {
    fcm_token = Utils.FCMToken;
  }

  Map<String, dynamic> register() {
    return <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      "phone_number": phone,
      'country_key': countryKey,
      'password': password,

      'password_confirmation': password_confirmation,
      // 'fcm_token': fcm_token,
    };
  }

  Map<String, dynamic> login() {
    return <String, dynamic>{
      'fcm_token': Utils.FCMToken,
      "phone_number": phone,
      'country_key': countryKey,
      'password': password,
    };
  }

  Map<String, dynamic> resertPassword() {
    return <String, dynamic>{
      'phone_number': phone,
      "otp": code,
      'new_password': password,
      'new_password_confirmation': password_confirmation,
    };
  }
}
