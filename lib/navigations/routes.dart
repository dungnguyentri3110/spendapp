import 'package:auto_route/auto_route.dart';
import 'package:spendapp/navigations/initial_route.dart';
import 'package:spendapp/navigations/routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: "/intro",
      page: AppIntroRoute.page,
      initial: true,
      guards: [InitialRoute()],
    ),
    AutoRoute(path: "/login_route", page: LoginRoute.page),
    AutoRoute(path: "/sign_up_route", page: SignUpRoute.page),
  ];
}
