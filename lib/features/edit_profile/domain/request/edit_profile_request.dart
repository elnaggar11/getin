import 'dart:io';

import 'package:dio/dio.dart';

class EditProfileRequest {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? countryKey;
  String? password;
  File? image;

  EditProfileRequest({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.countryKey,
    this.password,
    this.image,
  });

  Future<Map<String, dynamic>> toJson() async {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'country_key': countryKey,
      if (password?.isNotEmpty == true) 'new_password': password,
      if (image != null) 'image': await MultipartFile.fromFile(image!.path),
    };
  }
}
