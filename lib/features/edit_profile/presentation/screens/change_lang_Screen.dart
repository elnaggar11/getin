import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/Router/navigation_helper.dart';
import 'package:getincoffee/core/general/cubit/general_cubit.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/shared/back_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/light_theme.dart';

class ChangeLangScreen extends StatefulWidget {
  const ChangeLangScreen({super.key});

  @override
  State<ChangeLangScreen> createState() => _ChangeLangScreenState();
}

class _ChangeLangScreenState extends State<ChangeLangScreen> {
  String selectedLanguage = LocalizationHelper.currentLocalName;

  Future<void> _changeLanguage(String languageName) async {
    await LocalizationHelper.setLocale(languageName);
    setState(() {
      selectedLanguage = languageName;
    });
    // إعادة بناء التطبيق لتطبيق التغيير
    if (mounted) {
      NavigationHelper.pushNamedReplaceAll(Routes.splashScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GeneralCubit, GeneralState>(
      listener: (context, state) {
        if (state is GeneralChangeLocale) {
          NavigationHelper.popUntil(Routes.layoutScreen);
        }
      },
      child: Scaffold(
        backgroundColor: LightThemeColors.white,
        appBar: AppBar(
          leading: const BackWidget(),
          centerTitle: false,
          title: Text(
            LocalizationHelper.tr.change_language,
            style: const TextStyle(
              color: LightThemeColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
              37.ph,
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () =>
                      GeneralCubit.get(context).changeLocale('English'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 25,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: selectedLanguage == 'English'
                          ? LightThemeColors.darkwhite
                          : LightThemeColors.orange,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'English',
                          style: TextStyles.font12BlackBold.copyWith(
                            color: LightThemeColors.primary,
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: selectedLanguage == 'English'
                                ? LightThemeColors.primary
                                : Colors.transparent,
                            border: selectedLanguage == 'English'
                                ? null
                                : Border.all(
                                    width: 1, color: LightThemeColors.black),
                          ),
                          child: selectedLanguage == 'English'
                              ? const Center(
                                  child: Icon(
                                    Icons.check,
                                    color: LightThemeColors.white,
                                    size: 14,
                                  ),
                                )
                              : null,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () => GeneralCubit.get(context)
                      .changeLocale('Türkçe'), //_changeLanguage('Türkçe'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 25,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: selectedLanguage == 'Türkçe'
                          ? LightThemeColors.darkwhite
                          : LightThemeColors.orange,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Türkçe',
                          style: TextStyles.font12BlackBold.copyWith(
                            color: LightThemeColors.primary,
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: selectedLanguage == 'Türkçe'
                                ? LightThemeColors.primary
                                : Colors.transparent,
                            border: selectedLanguage == 'Türkçe'
                                ? null
                                : Border.all(
                                    width: 1, color: LightThemeColors.black),
                          ),
                          child: selectedLanguage == 'Türkçe'
                              ? const Center(
                                  child: Icon(
                                    Icons.check,
                                    color: LightThemeColors.white,
                                    size: 14,
                                  ),
                                )
                              : null,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () =>
                      GeneralCubit.get(context).changeLocale('العربية'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 25,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: selectedLanguage == 'العربية'
                          ? LightThemeColors.darkwhite
                          : LightThemeColors.orange,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'العربية',
                          style: TextStyles.font12BlackBold.copyWith(
                            color: LightThemeColors.primary,
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: selectedLanguage == 'العربية'
                                ? LightThemeColors.primary
                                : Colors.transparent,
                            border: selectedLanguage == 'العربية'
                                ? null
                                : Border.all(
                                    width: 1, color: LightThemeColors.black),
                          ),
                          child: selectedLanguage == 'العربية'
                              ? const Center(
                                  child: Icon(
                                    Icons.check,
                                    color: LightThemeColors.white,
                                    size: 14,
                                  ),
                                )
                              : null,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
