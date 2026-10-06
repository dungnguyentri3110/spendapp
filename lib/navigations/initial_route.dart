import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:spendapp/navigations/routes.gr.dart';
import 'package:spendapp/storages/share_preferences.dart';
import 'package:spendapp/utils/extension.dart';

import '../core/config.dart';

class InitialRoute implements AutoRouteGuard {
  @override
  FutureOr<void> onNavigation(NavigationResolver resolver, StackRouter router) {
    final passed = getAlreadyPassIntro().isNullOrEmpty;
    if (passed) {
      resolver.next(true);
    } else {
      router.replace(LoginRoute());
    }
  }

  String? getAlreadyPassIntro() {
    final share = getIt<SharePreferences>();
    return share.getData("intro");
  }
}
