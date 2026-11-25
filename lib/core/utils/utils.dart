import 'dart:io';
import 'dart:math';

import 'package:getincoffee/features/auth/domain/model/auth_model.dart';
import 'package:flutter/material.dart';

import '../data_source/hive_helper.dart';
import '../services/media/my_media.dart';
import 'Locator.dart';
import 'validations.dart';

class Utils {
  static String token = '';
  static String lang = '';
  static String FCMToken = '';
  static String userType = "";
  static String branchId = "";
  static UserModel userModel = UserModel();
  static GlobalKey<NavigatorState> navigatorKey() =>
      locator<GlobalKey<NavigatorState>>();
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static Validation get valid => locator<Validation>();
  static MediaService get media => locator<MediaService>();
  static DataManager get dataManager => locator<DataManager>();

  static saveUserInHive(Map<String, dynamic> response) async {
    userModel = UserModel.fromMap(response);
    token = userModel.accessToken ?? '';
    
    await Utils.dataManager.saveUser(response);
  }

  static void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  static void fixRtlLastChar(TextEditingController? controller) {
    if (controller != null) {
      if (controller.selection ==
          TextSelection.fromPosition(
              TextPosition(offset: (controller.text.length) - 1))) {
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
      }
    }
  }

  static void clearUser() async {
    userModel = UserModel();
    token = '';
    await Utils.dataManager.clearUser();
  }

  static genrateBarcode() {
    return (Random().nextInt(99999999) + 10000000).toString();
  }

  static double getSizeOfFile(File file) {
    final size = file.readAsBytesSync().lengthInBytes;
    final kb = size / 1024;
    final mb = kb / 1024;
    print(mb);
    return mb;
  }
}

extension MySLiverBox on Widget {
  // SliverToBoxAdapter get SliverBox => SliverToBoxAdapter(
  //   child: this,
  // );
  /*  SliverToBoxAdapter get SliverBoxAnimation => SliverToBoxAdapter(
    child: Padding(
      padding:  EdgeInsets.all(16),
      child: this,
    ),
  ); */
}
