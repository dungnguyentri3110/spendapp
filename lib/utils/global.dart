import 'package:spendapp/presentations/app_flow/app_bloc/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class GlobalApp {
  static GlobalApp? instance;
  static String _locale = LanguageLocal.vi.value;

  GlobalApp();

  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  factory GlobalApp.init() {
    instance ??= GlobalApp();
    return instance!;
  }

  BuildContext? get appContext {
    return navigationKey.currentState?.context;
  }

  void setLocale(String locale) {
    _locale = locale;
  }

  String get locale {
    return _locale;
  }
}
