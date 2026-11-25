import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getincoffee/core/utils/utils.dart';
import 'package:meta/meta.dart';

import '../../localization/localization_helper.dart';
import '../genera_repositories.dart';

part 'general_state.dart';

class GeneralCubit extends Cubit<GeneralState> {
  GeneralRepostioreis repo = GeneralRepostioreis.instance;
  GeneralCubit() : super(GeneralInitial());
  static GeneralCubit get(context) => BlocProvider.of(context);

  //change app theme
  bool isLightMode = true;
  changeAppTheme() {
    isLightMode = !isLightMode;
    emit(GeneralChangeAppTheme());
  }

  getProfileData() async {
    emit(GeneralProfileLoadingState());
    final response = await repo.getProfileData();
    if (response != null) {
      //Utils.saveUserInHive(response["data"]);
      Utils.userModel = response;
      log(Utils.userModel.typeDelivery.toString(), name: 'DeliveryToggle');
      updateDeliveryType(Utils.userModel.typeDelivery == "delivery" ? 0 : 1);

      emit(GeneralProfileSuccessState());
    } else {
      emit(GeneralProfileErrorState());
    }
  }

  changeLocale(String localeName) {
    if (LocalizationHelper.currentLocalName == localeName) return;

    LocalizationHelper.setLocale(localeName);
    emit(GeneralChangeLocale(locale: LocalizationHelper.currentLocalName));
    // NavigationHelper.pushNamedReplaceAll();
  }

  void updateProductFavoriteStatus(
      String productId, bool isLiked, String? favouriteId) {
    emit(GeneralFavoriteUpdated(
      productId: productId,
      isLiked: isLiked,
      favouriteId: favouriteId,
    ));
  }

  int cartItemsCount = 0;
  void updateCartCount(int count) {
    cartItemsCount = count;
    emit(GeneralCartCountUpdated(count: count));
  }

  void incrementCartCount([int amount = 1]) {
    cartItemsCount += amount;
    emit(GeneralCartCountUpdated(count: cartItemsCount));
  }

  int deliveryType = 1; // Default to pickup
  void updateDeliveryType(int type) {
    if (deliveryType != type) {
      deliveryType = type;
      repo.updateDeliveryType(type);
      emit(GeneralDeliveryTypeUpdated(type: type));
    }
  }
}
