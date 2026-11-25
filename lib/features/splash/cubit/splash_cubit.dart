import 'dart:developer';

import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/general/genera_repositories.dart';
import 'package:getincoffee/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getincoffee/features/profile/domain/model/setting_model.dart';
import 'package:getincoffee/features/profile/domain/repository/repository.dart';
import '../domain/repository/splash_repository.dart';
import 'splash_states.dart';

class SplashCubit extends Cubit<SplashStates> {
  final ProfileRepository repository;
  final SplashRepository splashRepository;

  SplashCubit({required this.repository, required this.splashRepository})
      : super(SplashInitial());
  static SplashCubit get(context) => BlocProvider.of(context);

  SiteSettingsModel? siteSettingsModel;

  /// Fetches site settings (including onboarding features) from the API.
  Future<void> getSettings() async {
    emit(GetSettingsLoading());
    final response = await repository.getSetting();
    if (response != null) {
      siteSettingsModel = response;
      emit(GetSettingsSuccess());
    } else {
      emit(GetSettingsError());
    }
  }

  /// Returns the features list from [siteSettingsModel] to be used as
  /// onboarding pages. Falls back to an empty list if settings haven't
  /// been loaded yet.
  List<FeaturesModel> get onboardingFeatures =>
      siteSettingsModel?.data.features ?? [];

  int sliderIndex = 0;
  late PageController controller;

  void updateSliderIndex(int index) {
    sliderIndex = index;
    emit(ChangeIntroState());
  }

  Future<String> checkLogin() async {
    await Utils.dataManager.getUserData();

    // Fetch settings so onboarding features are available before navigation.
    await getSettings();

    // Check if user has seen onboarding
    final hasSeenOnboarding = Utils.dataManager.hasSeenOnboarding();
    if (!hasSeenOnboarding) {
      return Routes.onboardingScreen;
    }

    log(Utils.token.isNotEmpty.toString());
    if (Utils.token.isNotEmpty == true) {
      final response = await GeneralRepostioreis.instance.getProfileData();
      if (response != null) {
        return Routes.layoutScreen;
      } else {
        return Routes.LoginSignupToggleScreen;
      }
    } else {
      return Routes.LoginSignupToggleScreen;
    }
  }
}
