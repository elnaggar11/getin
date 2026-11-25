import 'dart:developer';

import 'package:flutter/material.dart';
import '../utils/Locator.dart';

class NavigationHelper {
  /// The main navigator key used throughout the app.
  static GlobalKey<NavigatorState> get navigatorKey =>
      locator<GlobalKey<NavigatorState>>();

  /// Shortcut to the current [BuildContext] from [navigatorKey].
  static BuildContext get context => navigatorKey.currentContext!;

  /// Returns the effective [NavigatorState] based on the optional custom key.
  static NavigatorState? _getNavigator(GlobalKey<NavigatorState>? navKey) =>
      (navKey ?? navigatorKey).currentState;

  /// Pushes a named route onto the navigation stack.
  static Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
    GlobalKey<NavigatorState>? navKey,
  }) async {
    log("current route ==> $routeName", name: "Route Name");
    return await _getNavigator(navKey)?.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Pops the current route if possible.
  static Future<bool> maybePop<T extends Object?>([T? result]) async {
    return await Navigator.maybePop(context, result);
  }

  /// Pops the current route with an optional result.
  static void pop<T extends Object?>({
    T? result,
    GlobalKey<NavigatorState>? navKey,
  }) {
    _getNavigator(navKey)?.pop<T>(result);
  }

  /// Pushes a replacement route.
  static Future<T?> replace<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    GlobalKey<NavigatorState>? navKey,
  }) async {
    return await _getNavigator(navKey)?.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
    );
  }

  /// Pushes a named route and removes routes until the condition is met.
  static Future<T?> pushNamedReplaceAll<T extends Object?>(
    String routeName, {
    String? until,
    Object? arguments,
    GlobalKey<NavigatorState>? navKey,
  }) async {
    return await _getNavigator(navKey)?.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => until != null ? route.settings.name == until : false,
      arguments: arguments,
    );
  }

  /// Pops routes until a specific route is reached.
  static void popUntil(
    String routeName, {
    GlobalKey<NavigatorState>? navKey,
  }) {
    _getNavigator(navKey)?.popUntil(
      (route) => route.settings.name == routeName,
    );
  }

  static void popUntilRoute<T>(
    String routeName, {
    GlobalKey<NavigatorState>? navKey,
    T? result,
  }) {
    final NavigatorState navigator = _getNavigator(navKey)!;

    // We need a way to know the current top route
    Route? currentRoute;

    while (true) {
      // Peek at the top route
      navigator.popUntil((route) {
        currentRoute = route;
        return true; // just to get the top
      });

      if (currentRoute?.settings.name == routeName || !navigator.canPop()) {
        // Stop if we reached the target route or nothing more to pop
        break;
      }

      // Pop one route
      navigator.pop<T>(result);
    }
  }

  /* static void popUntilWithArg<T>(
    String routeName, {
    GlobalKey<NavigatorState>? navKey,
    T? arguments,
  }) {
    final navigator = _getNavigator(navKey);
    final navigator2 = _getNavigator2(navKey);
    print("3");
    var name = ModalRoute.of(navigator2!.currentContext!)?.settings.name;
    print(name);

    while (name != routeName) {
      name = ModalRoute.of(navigator2.currentContext!)!.settings.name;

      navigator?.pop<T>(arguments);
    }
  }
 */
}
