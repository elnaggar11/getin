import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:getincoffee/features/auth/domain/model/auth_model.dart';

// import '../../modules/auth/domain/model/auth_model.dart';
import '../utils/utils.dart';

class DataManager {
  late BoxCollection collection;
  late Box userData;

  static const USER = "USER";
  static const ONBOARDING_SEEN = "ONBOARDING_SEEN";

  Future initHive() async {
    await Hive.initFlutter();
    userData = await Hive.openBox('dataUser');
    getUserData();
    // final directory = await getApplicationDocumentsDirectory();
    // collection = await BoxCollection.open(
    //   'dataManager', // Name of your database
    //   {'data'}, // Names of your boxes
    //   path: directory
    //       .path, // Path where to store your boxes (Only used in Flutter / Dart IO)
    // );
  }

  Future<void> saveData(String key, dynamic value) async {
    final box = await Hive.openBox('data');
    await box.put(key, value);
    box.close();
  }

  saveUser(Map<String, dynamic> value) async {
    // await Hive.initFlutter();
    // final userData = await Hive.openBox('dataUser');
    await userData.put(USER, value);
//    userData.close();
  }

  clearUser() async {
    userData.delete(USER);
  }

  getData(String key) async {
    // await Hive.initFlutter();
    final box = await Hive.openBox('data');

    return box.get(key);
  }

  getUserData() async {
    // final userData = await Hive.openBox('dataUser');

    try {
      final user = (Map<String, dynamic>.from(userData.get(USER)));

      Utils.userModel = UserModel.fromMap(user);
      Utils.token = Utils.userModel.accessToken ?? '';

      return userData.get(USER);
    } catch (e) {
      log(e.toString());
      //  userData.clear();
    }
  }

  deleteUserData() async {
    // final userData = await Hive.openBox('dataUser');

    return userData.delete(USER);
  }

  deleteAllData() async {
    final userData = await Hive.openBox('data');

    return userData.delete(USER);
  }

  /// Mark that user has seen onboarding
  Future<void> setOnboardingSeen() async {
    await userData.put(ONBOARDING_SEEN, true);
  }

  /// Check if user has seen onboarding
  bool hasSeenOnboarding() {
    return userData.get(ONBOARDING_SEEN, defaultValue: false) ?? false;
  }
}
