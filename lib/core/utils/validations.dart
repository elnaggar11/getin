import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/utils/phone_length_by_country.dart';

class Validation {
  String? defaultValidation(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return (LocalizationHelper.tr.valid_requiredField);
      }
      //short
      // if (value.length < (3)) //value.length < 3
      // {
      //   return ('shortField'.tr());
      // }
      return null;
    }
    return null;
  }

  /// Returns a validator function that checks phone number length
  /// based on the provided [dialCode] (e.g. '+90', '+966').
  ///
  /// If the dial code is not found in the rules map, a generic
  /// 6–15 digit range is used as fallback.
  String? Function(String?) phoneValidationByCountry(String dialCode) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return LocalizationHelper.tr.valid_requiredField;
      }
      final numRegExp = RegExp(r'^[0-9]+$');

      if (!numRegExp.hasMatch(value)) {
        return "Enter Number Only No Letters";
      }

      final digitsOnly = value.trim().replaceAll(RegExp(r'\D'), '');
      final rule = phoneLengthRules[dialCode] ?? defaultPhoneLengthRule;

      if (digitsOnly.length < rule.minLength ||
          digitsOnly.length > rule.maxLength) {
        if (rule.minLength == rule.maxLength) {
          return LocalizationHelper.tr.valid_exactLength(rule.minLength);
        }
        return LocalizationHelper.tr
            .valid_numberBetween(rule.minLength, rule.maxLength);
      }

      return null;
    };
  }

  static String? phoneValidation(String? value) {
    // String p =r'(^[+]?[(]?[0-9]{3}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{4,6}$)';
    String p = r'^5[0-9]{8}$';

    RegExp regExp = RegExp(p);
    if (value!.trim().isEmpty) {
      return (LocalizationHelper.tr.valid_requiredPhone);
    } else if (!regExp.hasMatch(value.trim())) {
      return (LocalizationHelper.tr.valid_phoneDoseNotMatch);
    } else {
      return null;
    }
  }

  static RegExp emailReg = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  /*  String? emailValidation(
    String? value,
  ) {
    if (value!.trim().isEmpty) {
      return (LocalizationHelper.tr.);
    } else if (!emailReg.hasMatch(value.trim())) {
      return (LocalizationHelper.tr.valid_wrongEmailValidation);
    } else {
      return null;
    } 
}*/

  String? passwordValidation(String? value) {
    if (value!.trim().isEmpty) {
      return (LocalizationHelper.tr.valid_requiredPassword);
    } else if (value.trim().length < 8) {
      return (LocalizationHelper.tr.valid_smallPassword);
    } else {
      return null;
    }
  }

  String? confirmPasswordValidation(value, String password) {
    if (value!.isEmpty) {
      return (LocalizationHelper.tr.valid_requiredField);
    } else if (password != value) {
      return (LocalizationHelper.tr.valid_passwordNotMatch);
    } else {
      return null;
    }
  }

/*   static bool? isValidSaudiPhoneNumber(String input) {
    // Regular expression to match Saudi phone number format
    // Note: This is a simple example and may need adjustment based on actual requirements
    RegExp regex = RegExp(r'^5[0-9]{8}$');
    return regex.hasMatch(input);
  } */
}
