import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';

class CustomCountryCodePicker extends StatelessWidget {
  const CustomCountryCodePicker({
    super.key,
    required this.onChanged,
    this.initialSelection = '+90',
  });

  final ValueChanged<CountryCode> onChanged;
  final String initialSelection;

  @override
  Widget build(BuildContext context) {
    return CountryCodePicker(
      initialSelection: initialSelection,
      favorite: const ['+90', '+966', '+971', '+20'],
      showCountryOnly: false,
      showOnlyCountryWhenClosed: false,
      alignLeft: false,
      showFlag: true,
      padding: EdgeInsets.zero,
      showFlagDialog: true,
      onChanged: onChanged,
      builder: (country) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(start: 14, end: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (country?.flagUri != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Image.asset(
                    country!.flagUri!,
                    package: 'country_code_picker',
                    width: 22,
                  ),
                ),
              const SizedBox(width: 6),
              Text(
                country?.dialCode ?? '+90',
                textDirection: TextDirection.ltr,
                style: TextStyles.font12BlackBold.copyWith(
                  color: LightThemeColors.black,
                  fontWeight: FontWeights.semiBold,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: LightThemeColors.grey,
                size: 18,
              ),
              Container(
                height: 22,
                width: 1,
                margin: const EdgeInsetsDirectional.only(start: 6, end: 6),
                color: LightThemeColors.primary.withOpacity(0.12),
              ),
            ],
          ),
        );
      },
    );
  }
}
