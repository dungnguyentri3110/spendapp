import 'package:spendapp/presentations/app_flow/app_bloc/app_action.dart';
import 'package:spendapp/presentations/app_flow/app_bloc/app_bloc.dart';
import 'package:spendapp/presentations/app_flow/app_bloc/app_state.dart';
import 'package:spendapp/presentations/main_flow/home_flow/blocs/home_bloc.dart';
import 'package:spendapp/widgets/base_button/base_button.dart';
import 'package:spendapp/widgets/base_page/base_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => HomeBloc(), child: _HomeScreenPage());
  }
}

class _HomeScreenPage extends StatefulWidget {
  const _HomeScreenPage();

  @override
  State<_HomeScreenPage> createState() => __HomeScreenPageState();
}

class __HomeScreenPageState extends State<_HomeScreenPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   context.read<HomeBloc>().getListMusic();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "HomeScreen",
      showBackIcon: false,
      child: Container(
        alignment: Alignment.center,
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            return Column(
              children: [
                Text('hello'.tr()),
                BaseButton(
                  titleButton: 'Change language',
                  onPress: () {
                    context.setLocale(
                      Locale(
                        state.language == LanguageLocal.en
                            ? LanguageLocal.vi.name
                            : LanguageLocal.en.name,
                      ),
                    );
                    context.read<AppBloc>().add(
                      ChangeAppLanguage(
                        language:
                            state.language == LanguageLocal.en
                                ? LanguageLocal.vi
                                : LanguageLocal.en,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
