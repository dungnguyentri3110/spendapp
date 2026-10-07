// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:auto_route/auto_route.dart' as _i8;
import 'package:spendapp/presentations/app_intro/app_intro_screen.dart' as _i1;
import 'package:spendapp/presentations/authen_flow/login_flow/login_screen.dart'
    as _i2;
import 'package:spendapp/presentations/authen_flow/sign_up_flow/sign_up_screen.dart'
    as _i5;
import 'package:spendapp/presentations/main_navigation/main_navigation_screen.dart'
    as _i3;
import 'package:spendapp/presentations/main_screen/screens/main_screen.dart'
    as _i4;
import 'package:spendapp/presentations/spend_flow/spend_screen.dart' as _i6;
import 'package:spendapp/presentations/statistics_flow/yearly_statistics_screen.dart'
    as _i7;

/// generated route for
/// [_i1.AppIntroScreen]
class AppIntroRoute extends _i8.PageRouteInfo<void> {
  const AppIntroRoute({List<_i8.PageRouteInfo>? children})
    : super(AppIntroRoute.name, initialChildren: children);

  static const String name = 'AppIntroRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i1.AppIntroScreen();
    },
  );
}

/// generated route for
/// [_i2.LoginScreen]
class LoginRoute extends _i8.PageRouteInfo<void> {
  const LoginRoute({List<_i8.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.LoginScreen();
    },
  );
}

/// generated route for
/// [_i3.MainNavigationScreen]
class MainNavigationRoute extends _i8.PageRouteInfo<void> {
  const MainNavigationRoute({List<_i8.PageRouteInfo>? children})
    : super(MainNavigationRoute.name, initialChildren: children);

  static const String name = 'MainNavigationRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i3.MainNavigationScreen();
    },
  );
}

/// generated route for
/// [_i4.MainScreen]
class MainRoute extends _i8.PageRouteInfo<void> {
  const MainRoute({List<_i8.PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i4.MainScreen();
    },
  );
}

/// generated route for
/// [_i5.SignUpScreen]
class SignUpRoute extends _i8.PageRouteInfo<void> {
  const SignUpRoute({List<_i8.PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i5.SignUpScreen();
    },
  );
}

/// generated route for
/// [_i6.SpendScreen]
class SpendRoute extends _i8.PageRouteInfo<void> {
  const SpendRoute({List<_i8.PageRouteInfo>? children})
    : super(SpendRoute.name, initialChildren: children);

  static const String name = 'SpendRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i6.SpendScreen();
    },
  );
}

/// generated route for
/// [_i7.YearlyStatisticsScreen]
class YearlyStatisticsRoute extends _i8.PageRouteInfo<void> {
  const YearlyStatisticsRoute({List<_i8.PageRouteInfo>? children})
    : super(YearlyStatisticsRoute.name, initialChildren: children);

  static const String name = 'YearlyStatisticsRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.YearlyStatisticsScreen();
    },
  );
}
