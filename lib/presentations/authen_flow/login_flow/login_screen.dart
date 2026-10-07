import 'package:auto_route/auto_route.dart';
import 'package:spendapp/navigations/routes.gr.dart';
import 'package:spendapp/widgets/base_button/base_button.dart';
import 'package:spendapp/widgets/base_page/base_page.dart';
import 'package:spendapp/widgets/input/base_input.dart';
import 'package:spendapp/widgets/toast/AppToast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spendapp/presentations/authen_flow/login_flow/bloc/login_bloc.dart';
import 'package:spendapp/presentations/authen_flow/login_flow/bloc/login_state.dart';

import '../../../gen/assets.gen.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
        context.router.replace(const MainNavigationRoute());
        } else if (state.status == LoginStatus.error) {
          AppToast.showToast("login.sign_in_error".tr(), ToastType.error);
        }
      },
      builder: (context, state) {
        final bloc = context.read<LoginBloc>();
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: BasePage(
            showBackIcon: false,
            title: "login.title".tr(),
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(25.w),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 24.w),
                    Text(
                      "login.subtitle".tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 28.w),
                    BaseInput(
                      title: "login.email".tr(),
                      hintText: "login.email_hint".tr(),
                      required: true,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      onChangeText: bloc.updateEmail,
                      errorText: switch (state.emailError) {
                        LoginFieldError.required =>
                          "login.email_required".tr(),
                        LoginFieldError.invalid => "login.email_invalid".tr(),
                        null => null,
                      },
                    ),
                    SizedBox(height: 20.w),
                    BaseInput(
                      title: "login.password".tr(),
                      hintText: "login.password_hint".tr(),
                      required: true,
                      controller: _passwordController,
                      isPassword: true,
                      leftIcon: SvgPicture.asset(Assets.icons.icEyes),
                      rightIcon: SvgPicture.asset(Assets.icons.icLock),
                      onChangeText: bloc.updatePassword,
                      errorText: state.passwordError == LoginFieldError.required
                          ? "login.password_required".tr()
                          : null,
                    ),
                    SizedBox(height: 36.w),
                    BaseButton(
                      onPress: state.isSubmitting ? null : bloc.signIn,
                      titleButton: state.isSubmitting
                          ? "login.signing_in".tr()
                          : "login.submit".tr(),
                      height: 48.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
