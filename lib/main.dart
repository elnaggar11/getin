import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:getincoffee/core/utils/firebase_message.dart';
import 'package:getincoffee/firebase_options.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'core/Router/Router.dart';
import 'core/Router/logging_route_observer.dart';
import 'core/Router/navigation_helper.dart';
import 'core/data_source/hive_service.dart';
import 'core/general/cubit/general_cubit.dart';
import 'core/localization/generated/app_localizations.dart';
import 'core/localization/localization_helper.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/utils/Locator.dart';
import 'core/utils/general_constants.dart';
import 'core/utils/responsive_framework_widget.dart';
import 'core/utils/utils.dart';
import 'core/services/stripe_service.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Bloc.observer = MyBlocObserver();
    await HiveService.init([GeneralConstants.appBoxName]); // bloc observer

    await Future.wait([
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      StripeService.init(),
    ]);
    await setupLocator();
    await FBMessaging.initialize();
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    // dotenv.load();

    await Utils.dataManager.initHive();
    runApp(const MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
    log('Caught error in main.dart: $error\n$stackTrace');
    log('$stackTrace', name: 'main.dart');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocProvider(
        create: (context) => locator<GeneralCubit>(),
        child: BlocConsumer<GeneralCubit, GeneralState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          // listenWhen: (previous, current)=>cubit. ,
          builder: (context, state) {
            final cubit = GeneralCubit.get(context);
            Utils.rebuildAllChildren(context);

            return MaterialApp(
              title: 'Get In Coffee',
              navigatorObservers: [LoggingRouteObserver()],
              themeAnimationDuration: const Duration(milliseconds: 700),
              themeAnimationCurve: Curves.easeInOutCubic,
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                final botToastBuilder = BotToastInit();
                final smartDialog = FlutterSmartDialog.init();
                child = smartDialog(context, child);
                child = botToastBuilder(context, child);

                SystemChrome.setSystemUIOverlayStyle(
                  cubit.isLightMode
                      ? SystemUiOverlayStyle.dark
                      : SystemUiOverlayStyle.light,
                );

                return Directionality(
                  textDirection: LocalizationHelper.textDirection,
                  child: AppResponsiveWrapper(child: child),
                );
              },

              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                ...AppLocalizations.localizationsDelegates,
                LocalizationHelper.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              locale: LocalizationHelper.currentLocale,
              localeResolutionCallback: (locale, supportedLocales) {
                // Check if the device locale is supported
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode) {
                    return supportedLocale;
                  }
                }
                // Return the saved locale or default to first supported locale
                return LocalizationHelper.currentLocale;
              },
              navigatorKey: NavigationHelper.navigatorKey,
// scaffoldMessengerKey: Utils.scaffoldKey,
              onGenerateRoute: RouteGenerator.getRoute,
              // themeMode: cubit.isLightMode ? ThemeMode.light : ThemeMode.dark,
              // theme: cubit.isLightMode ? LightTheme.getTheme() : DarkTheme.getTheme(),
              themeMode: ThemeMode.light,
              theme: LightTheme.getTheme(),
              darkTheme: DarkTheme.getTheme(),
              initialRoute: Routes.splashScreen,
            );
          },
        ),
      ),
    );
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('onEvent -- ${bloc.runtimeType} -- $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType} -- $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('onTransition -- ${bloc.runtimeType} -- $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType} -- $error -- $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    print('onClose -- ${bloc.runtimeType}');
    super.onClose(bloc);
  }
}
