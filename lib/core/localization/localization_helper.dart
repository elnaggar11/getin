import 'package:flutter/material.dart';

import '../Router/navigation_helper.dart';
import '../data_source/hive_service.dart';
import '../utils/general_constants.dart';
import 'generated/app_localizations.dart';

class LocalizationHelper {
  LocalizationHelper._();
  static final LocalizationHelper _instance = LocalizationHelper._();
  factory LocalizationHelper() => _instance;

  static final GlobalKey<NavigatorState> _navigatorKey =
      NavigationHelper.navigatorKey;
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  static AppLocalizations get tr =>
      AppLocalizations.of(navigatorKey.currentContext!);

  static const String _localeKey = 'app_locale';

  static Locale currentLocale = Locale(
    HiveService.getRaw(boxName: GeneralConstants.appBoxName, key: _localeKey) ??
        'en',
  );

  static final List<String> localNames = ['العربية', 'English', 'Türkçe'];
  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizations.delegate;

  // RTL support
  static bool get isRTL => currentLocale.languageCode == 'ar';

  static TextDirection get textDirection => currentLocale.languageCode == 'ar'
      ? TextDirection.rtl
      : TextDirection.ltr;

  static CrossAxisAlignment get crossAxisAlignment =>
      currentLocale.languageCode == 'ar'
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start;

  static MainAxisAlignment get mainAxisAlignment =>
      currentLocale.languageCode == 'ar'
          ? MainAxisAlignment.end
          : MainAxisAlignment.start;

  static EdgeInsetsGeometry getEdgeInsets({
    double left = 0,
    double right = 0,
    double top = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: currentLocale.languageCode == 'ar' ? right : left,
      right: currentLocale.languageCode == 'ar' ? left : right,
      top: top,
      bottom: bottom,
    );
  }

  static EdgeInsetsGeometry getStartEndPadding({
    double start = 0,
    double end = 0,
    double top = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: currentLocale.languageCode == 'ar' ? end : start,
      right: currentLocale.languageCode == 'ar' ? start : end,
      top: top,
      bottom: bottom,
    );
  }

  static BorderRadiusGeometry getBorderRadius({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(
          currentLocale.languageCode == 'ar' ? topRight : topLeft),
      topRight: Radius.circular(
          currentLocale.languageCode == 'ar' ? topLeft : topRight),
      bottomLeft: Radius.circular(
          currentLocale.languageCode == 'ar' ? bottomRight : bottomLeft),
      bottomRight: Radius.circular(
          currentLocale.languageCode == 'ar' ? bottomLeft : bottomRight),
    );
  }

  static String formatNumber(double number) {
    return number.toStringAsFixed(2);
  }

  static String getCurrencySymbol() {
    return currentLocale.languageCode == 'ar' ? 'ر.س' : 'SAR';
  }

  static String getDateFormat() {
    return DateTime.now().toIso8601String().split('T').first;
  }

  static String get currentLocalName {
    int index = AppLocalizations.supportedLocales.indexWhere((e) {
      return e.languageCode == currentLocale.languageCode;
    });
    return localNames[index];
  }

  static Future<void> setLocale(String languageName) async {
    int index = localNames.indexOf(languageName);

    await HiveService.putRaw(GeneralConstants.appBoxName, _localeKey,
        AppLocalizations.supportedLocales[index].languageCode);
    LocalizationHelper.currentLocale = AppLocalizations.supportedLocales[index];
  }
}
