import 'package:auto_route/auto_route.dart';
import 'package:spendapp/navigations/initial_route.dart';
import 'package:spendapp/navigations/routes.gr.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (Supabase.instance.client.auth.currentSession != null) {
      resolver.next(true);
      return;
    }

    resolver.next(false);
    router.replace(const LoginRoute());
  }
}

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: "/main",
      page: MainNavigationRoute.page,
      initial: true,
      guards: [SupabaseAuthGuard()],
    ),
    AutoRoute(
      path: "/main_screen",
      page: MainRoute.page,
      guards: [SupabaseAuthGuard()],
    ),
    AutoRoute(
      path: "/spend",
      page: SpendRoute.page,
      guards: [SupabaseAuthGuard()],
    ),
    AutoRoute(
      path: "/yearly-statistics",
      page: YearlyStatisticsRoute.page,
      guards: [SupabaseAuthGuard()],
    ),
    AutoRoute(
      path: "/intro",
      page: AppIntroRoute.page,
      guards: [InitialRoute()],
    ),
    AutoRoute(path: "/login_route", page: LoginRoute.page),
    AutoRoute(path: "/sign_up_route", page: SignUpRoute.page),
  ];
}
