import 'package:getincoffee/features/cart/qr_order/data/repository/repository.dart';
import 'package:getincoffee/features/profile/domain/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/utils/validations.dart';
import '../../features/addresses/domain/repository/repository.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/cart/domain/repository/repository.dart';
import '../../features/edit_profile/domain/repository/repository.dart';
import '../../features/favorite/domain/repository/repository.dart';
import '../../features/home/domain/repository/repository.dart';
import '../../features/myorder/domain/repository/repository.dart';
import '../../features/mypoints/domain/repository/repository.dart';
import '../../features/paymentmethod/domain/repository/repository.dart';
import '../../features/productdetails/domain/repository/repository.dart';
import '../../features/rating/domain/repository/repository.dart';
import '../../features/scheduleorder/domain/repository/repository.dart';
import '../../features/splash/domain/repository/splash_repository.dart';
import '../../features/coupons/domain/repository/coupon_repository.dart';
import '../Router/Router.dart';
import '../config/key.dart';
import '../data_source/dio_helper.dart';
import '../data_source/hive_helper.dart';
import '../general/cubit/general_cubit.dart';
import '../services/media/my_media.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => DataManager());
  locator.registerLazySingleton(() => DioService(ConstKeys.baseUrl));
  locator.registerLazySingleton(() => Routes());
  locator.registerLazySingleton(() => GeneralCubit());
  locator.registerLazySingleton(() => ProfileRepository(locator<DioService>()));
  locator
      .registerLazySingleton(() => QrReaderRepository(locator<DioService>()));
  locator.registerLazySingleton(() => Validation());
  locator.registerLazySingleton(() => MediaService());
  locator.registerLazySingleton(() => GlobalKey<ScaffoldState>());
  locator.registerLazySingleton(() => GlobalKey<NavigatorState>());
  locator.registerLazySingleton(() => AuthRepository(locator<DioService>()));
  locator.registerLazySingleton(() => SplashRepository(locator<DioService>()));
  //locator.registerLazySingleton(() => SplashRepository(locator<DioService>()));

  locator.registerLazySingleton(() => HomeRepository(locator<DioService>()));
  // locator.registerLazySingleton(() => GeneralRepostioreis(locator<DioService>()));
  locator.registerLazySingleton(
      () => EditProfileRepository(locator<DioService>()));

  locator.registerLazySingleton(() => CartRepository(locator<DioService>()));

  locator.registerLazySingleton(() => MyorderRepository(locator<DioService>()));

  locator.registerLazySingleton(
      () => ProductdetailsRepository(locator<DioService>()));

  // Coupons Feature
  locator.registerLazySingleton(() => CouponRepository(locator<DioService>()));

  locator
      .registerLazySingleton(() => FavoriteRepository(locator<DioService>()));

  locator
      .registerLazySingleton(() => MypointsRepository(locator<DioService>()));

  locator.registerLazySingleton(
      () => PaymentmethodRepository(locator<DioService>()));

  locator
      .registerLazySingleton(() => AddressesRepository(locator<DioService>()));

  locator.registerLazySingleton(
      () => ScheduleorderRepository(locator<DioService>()));

  locator.registerLazySingleton(() => RatingRepository(locator<DioService>()));
  // locator.registerLazySingleton(() => GeneralRepostioreis.instance(locator<DioService>()));
}
