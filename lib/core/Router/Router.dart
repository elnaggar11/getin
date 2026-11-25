import 'package:getincoffee/features/addresses/presentation/screens/addresses_screen.dart';
import 'package:getincoffee/features/cart/qr_order/presentation/qr_screen.dart';
import 'package:getincoffee/features/cart/presentation/screens/success_screen.dart';
import 'package:getincoffee/features/edit_profile/presentation/screens/change_lang_Screen.dart';
import 'package:getincoffee/features/home/cubit/home_cubit.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/home/domain/request/filter_request.dart';
import 'package:getincoffee/features/home/presentation/screens/home_screen.dart';
import 'package:getincoffee/features/home/presentation/screens/map_screen.dart';
import 'package:getincoffee/features/layout/presentation/screens/layout_screen.dart';
import 'package:getincoffee/features/myorder/domain/model/myorder_model.dart';
import 'package:getincoffee/features/mypoints/domain/model/ranks_list_model.dart';
import 'package:getincoffee/features/mypoints/presentation/screens/my_stars_screen.dart';
import 'package:getincoffee/features/mypoints/presentation/screens/star_card_details_screen.dart';
import 'package:getincoffee/features/notification/presentation/screens/notification_screen.dart';
import 'package:getincoffee/features/paymentmethod/presentation/screens/paymentmethod_screen.dart';
import 'package:getincoffee/features/productdetails/presentation/screens/productdetails_screen.dart';
import 'package:getincoffee/features/rating/presentation/screens/rating_screen.dart';
import 'package:getincoffee/features/scheduleorder/domain/model/scheduleorder_model.dart';
import 'package:getincoffee/features/scheduleorder/presentation/screens/create_schedulorder_screen.dart';
import 'package:getincoffee/features/scheduleorder/presentation/screens/scheduleorder_detail_screen.dart';
import 'package:getincoffee/features/static_pages/presentaion/screens/terms_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../features/auth/presentation/screens/forget_password/forget_password_screen.dart';
import '../../features/auth/presentation/screens/login/login_screen.dart';
import '../../features/auth/presentation/screens/login_signUp_toggle/login_signup_toggle_screen.dart';
import '../../features/auth/presentation/screens/otp/otp_screen.dart';
import '../../features/auth/presentation/screens/reset_password/reset_password_screen.dart';
import '../../features/auth/presentation/screens/sign_up/sign_up_screen.dart';
import '../../features/cart/presentation/screens/payment_screen.dart';
import '../../features/cart/presentation/screens/trackorder/cubit/track_cubit.dart';
import '../../features/cart/presentation/screens/trackorder/trackorder_screen.dart';
import '../../features/coupons/presentation/view/copons_screen.dart';
import '../../features/home/presentation/screens/filter_screen.dart';
import '../../features/mypoints/presentation/screens/mypoints_screen.dart'
    show MypointsScreen;
import '../../features/scheduleorder/presentation/screens/scheduleorder_screen.dart'
    show ScheduleorderScreen;
import '../../features/splash/presentation/screens/on_boarding/on_boarding_screen.dart';
import '../../features/splash/presentation/screens/splash/splash.dart';
import '../../features/support/presentation/screens/support_screen.dart';

class Routes {
  static const String splashScreen = "/splashScreen";
  static const String onboardingScreen = "/onboardingScreen";
  static const String loginScreen = "loginScreen";
  static const String registerScreen = "registerScreen";
  static const String forgetPassScreen = "/forgetPassScreen";
  static const String otpScreen = "/OtpScreen";
  static const String layoutScreen = "/LayoutScreen";
  static const String ProductdetailsScreen = "/ProductdetailsScreen";
  static const String LoginSignupToggleScreen = "/LoginSignupToggleScreen";
  static const String resetPasswordScreen = "/ResetPasswordScreen";
  static const String PaymentScreen = "/PaymentScreen";
  static const String QrScreen = "/QrScreen";
  static const String TrackorderScreen = "/TrackorderScreen";
  static const String SuccessScreen = "/SuccessScreen";
  static const String FilterScreen = "/FilterScreen";
  static const String MypointsScreen = "/MypointsScreen";
  static const String MyStarsScreen = "/MyStarsScreen";
  static const String PaymentmethodScreen = "/PaymentmethodScreen";
  static const String AddressesScreen = "/AddressesScreen";
  static const String ChangeLangScreen = "/ChangeLangScreen";
  static const String TermsScreen = "/TermsScreen";
  static const String CoponsScreen = "/CoponsScreen";
  static const String ScheduleorderScreen = "/ScheduleorderScreen";
  static const String CreateSchedulorderScreen = "/CreateSchedulorderScreen";
  static const String ScheduleOrderDetailScreen = "/ScheduleOrderDetailScreen";
  static const String HomeScreen = "/HomeScreen";
  static const String StarCardDetailsScreen = "/StarCardDetailsScreen";
  static const String RatingScreen = "/RatingScreen";
  static const String SupportScreen = "/SupportScreen";

  // static const String homeScreen = "homeScreen";
  static const String BranchesMapScreen = "BranchesMapScreen";
  static const String NotificationScreen = "NotificationScreen";
}

class RouteGenerator {
  static String currentRoute = "";

  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    currentRoute = routeSettings.name.toString();
    switch (routeSettings.name) {
      case Routes.splashScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const SplashScreen();
          },
        );
      case Routes.layoutScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const LayoutScreen();
          },
        );
      case Routes.onboardingScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const OnboardingScreen();
          },
        );
      case Routes.loginScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const LoginScreen();
          },
        );
      case Routes.ProductdetailsScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return ProductdetailsScreen(
              id: (routeSettings.arguments as ProductDetailsargs?)?.id ?? "",
              branchId:
                  (routeSettings.arguments as ProductDetailsargs?)?.branchId ??
                      "",
              isSchedule: (routeSettings.arguments as ProductDetailsargs?)
                      ?.isSchedule ??
                  false,
            );
          },
        );
      // case Routes.layoutScreen:
      //   return CupertinoPageRoute(
      //     settings: routeSettings,
      //     builder: (_) {
      //       return const LayoutScreen();
      //     },
      //   );
      case Routes.resetPasswordScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return ResetPasswordScreen(
              code: (routeSettings.arguments as NewPasswordArgs).code,
              phone: (routeSettings.arguments as NewPasswordArgs).phone,
            );
          },
        );
      case Routes.TrackorderScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            final args = routeSettings.arguments;
            final orderModel = args is TrackorderScreenArgs
                ? args.orderItemModel
                : (args as SingleOrderModel?) ?? SingleOrderModel();
            final trackCubit =
                args is TrackorderScreenArgs ? args.trackCubit : null;

            final screen = TrackorderScreen(orderItemModel: orderModel);
            if (trackCubit != null) {
              return BlocProvider.value(value: trackCubit, child: screen);
            }
            return screen;
          },
        );

      case Routes.otpScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return OtpScreen(
              onReSend: (routeSettings.arguments as OtpArguments).onReSend,
              onSubmit: (routeSettings.arguments as OtpArguments).onSubmit,
              sendTo: (routeSettings.arguments as OtpArguments).sendTo,
              init: (routeSettings.arguments as OtpArguments).init,
            );
          },
        );
      case Routes.forgetPassScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const ForgetPasswordScreen();
          },
        );
      case Routes.LoginSignupToggleScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const LoginSignupToggleScreen();
          },
        );
      case Routes.registerScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const SignUpScreen();
          },
        );
      case Routes.PaymentScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            final args = routeSettings.arguments as Map<String, String>;
            return PaymentScreen(
              type: args['type'] as String,
              typeBack: args['typeBack'] as String,
            );
          },
        );
      case Routes.QrScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            final args = routeSettings.arguments;
            final id = args is QrScreenArgs ? args.id : args as String?;
            final trackCubit =
                args is QrScreenArgs ? args.trackCubit : null;

            final screen = QrScreen(id: id);
            if (trackCubit != null) {
              return BlocProvider.value(value: trackCubit, child: screen);
            }
            return screen;
          },
        );
      case Routes.SuccessScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const SuccessScreen();
          },
        );
      case Routes.FilterScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            final args = routeSettings.arguments as FilterScreenArgs;
            return FilterScreen(
              categories: args.categories,
              productFilter: args.productFilter,
              values: args.values,
            );
          },
        );
      case Routes.MypointsScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const MypointsScreen();
          },
        );
      case Routes.MyStarsScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const MyStarsScreen();
          },
        );
      case Routes.PaymentmethodScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const PaymentmethodScreen();
          },
        );
      case Routes.AddressesScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const AddressesScreen();
          },
        );
      case Routes.ChangeLangScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const ChangeLangScreen();
          },
        );
      case Routes.TermsScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const TermsScreen();
          },
        );
      case Routes.CoponsScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const CoponsScreen();
          },
        );
      case Routes.ScheduleorderScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const ScheduleorderScreen();
          },
        );
      case Routes.CreateSchedulorderScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const CreateSchedulorderScreen();
          },
        );
      case Routes.ScheduleOrderDetailScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return ScheduleOrderDetailScreen(
              item: routeSettings.arguments as ScheduleorderModel,
            );
          },
        );
      case Routes.HomeScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return HomeScreenWrapper(
              args: routeSettings.arguments as HomeArgs?,
            );
          },
        );
      case Routes.StarCardDetailsScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return StarCardDetailsScreen(
              ranksListModel: routeSettings.arguments as RanksListModel,
            );
          },
        );
      case Routes.RatingScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return RatingScreen(
              item: routeSettings.arguments as MyorderModel,
            );
          },
        );
      case Routes.BranchesMapScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return BranchesMapScreen(
              initialLocation: routeSettings.arguments as LatLng?,
            );
          },
        );
      case Routes.NotificationScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const NotificationScreen();
          },
        );
      case Routes.SupportScreen:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) {
            return const SupportScreen();
          },
        );
      // case Routes.SplashScreen:
      //   return CupertinoPageRoute(
      //       settings: routeSettings,
      //       builder: (_) {
      //         return const SplashScreen();
      //       });

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> getNestedRoute(RouteSettings routeSettings) {
    currentRoute = routeSettings.name.toString();
    switch (routeSettings.name) {
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return CupertinoPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("مسار غير موجود")),
        body: const Center(child: Text("مسار غير موجود")),
      ),
    );
  }
}

/// Arguments for [QrScreen]. Carries an optional [TrackCubit] to share
/// across the Payment → QR → TrackOrder navigation stack.
class QrScreenArgs {
  final String id;
  final TrackCubit? trackCubit;

  const QrScreenArgs({required this.id, this.trackCubit});
}

/// Arguments for [TrackorderScreen]. Carries an optional [TrackCubit] to
/// reuse the same instance provided by [PaymentScreen].
class TrackorderScreenArgs {
  final SingleOrderModel? orderItemModel;
  final TrackCubit? trackCubit;

  const TrackorderScreenArgs({
    this.orderItemModel,
    this.trackCubit,
  });
}

class OtpArguments {
  final String sendTo;
  final bool? init;
  final dynamic Function(String) onSubmit;
  final void Function() onReSend;

  OtpArguments({
    required this.sendTo,
    required this.onSubmit,
    required this.onReSend,
    this.init,
  });
}

class NewPasswordArgs {
  final String code;
  final String phone;
  const NewPasswordArgs({required this.code, required this.phone});
}

class ProductDetailsargs {
  final String id;
  final String branchId;
  final bool isSchedule;

  const ProductDetailsargs(
      {required this.id, required this.branchId, this.isSchedule = false});
}

class HomeArgs {
  final bool? fromsch;
  final BranchModel? branch;
  final bool canchangeBranch;
  final bool isSchedule;

  const HomeArgs(
      {this.branch,
      this.fromsch,
      this.canchangeBranch = true,
      this.isSchedule = false});
}

class FilterScreenArgs {
  final List<BranchCategory> categories;
  final ProductFilter productFilter;
  final RangeValues values;

  const FilterScreenArgs(
      {required this.categories,
      required this.productFilter,
      required this.values});
}

class HomeScreenWrapper extends StatefulWidget {
  final HomeArgs? args;
  const HomeScreenWrapper({super.key, this.args});

  @override
  State<HomeScreenWrapper> createState() => _HomeScreenWrapperState();
}

class _HomeScreenWrapperState extends State<HomeScreenWrapper>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()
        ..init(
          context,
          vsync: this,
          withsheet: widget.args?.fromsch,
          branch: widget.args?.branch,
        ),
      child: HomeScreen(
        withbottom: widget.args?.fromsch,
        branch: widget.args?.branch,
        canchangeBranch: widget.args?.canchangeBranch ?? true,
        isSchedule: widget.args?.isSchedule ?? false,
      ),
    );
  }
}
