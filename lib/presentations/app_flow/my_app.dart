import 'package:spendapp/data/remote/api_manager.dart';
import 'package:spendapp/navigations/routes.dart';
import 'package:spendapp/presentations/app_flow/app_bloc/app_bloc.dart';
import 'package:spendapp/presentations/app_flow/app_bloc/app_state.dart';
import 'package:spendapp/storages/share_preferences.dart';
import 'package:spendapp/utils/app_logger.dart';
import 'package:spendapp/utils/global.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../navigations/router_observer.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  late AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    initialApp();
  }

  void initialApp() {
    GlobalApp.init();
    _appRouter = AppRouter();
    final apiManager = getIt<ApiManager>();
    apiManager.configureDio();
    final prefs = getIt<SharePreferences>();
    prefs.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        Log.d("Language: ${state.language?.value}");
        return ScreenUtilInit(
          designSize: const Size(430, 932),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return MaterialApp.router(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              builder: (context, widget) {
                final botToast = BotToastInit();
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(1.0)),
                  child: botToast(context, widget),
                );
              },
              debugShowCheckedModeBanner: false,
              routerConfig: _appRouter.config(
                navigatorObservers: () => [
                  MyObserver(),
                  BotToastNavigatorObserver(),
                ],
              ),
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                fontFamily: 'SF-Pro-Display',
              ),
            );
          },
        );
      },
    );
  }
}
