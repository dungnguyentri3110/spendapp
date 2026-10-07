import 'package:spendapp/core/config.dart';
import 'package:spendapp/data/remote/supabase_manager.dart';
import 'package:spendapp/presentations/app_flow/my_app.dart';
import 'package:spendapp/presentations/app_flow/app_bloc/app_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  configureDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];
  final supabaseManager = getIt<SupabaseManager>();
  await supabaseManager.initialize();
  
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('vi')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: Locale('vi'),
      startLocale: Locale('vi'),
      child: MainApplication(),
    ),
  );
}

class MainApplication extends StatelessWidget {
  const MainApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => AppBloc(), child: MyApp());
  }
}
