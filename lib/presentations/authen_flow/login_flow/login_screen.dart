import 'package:auto_route/auto_route.dart';
import 'package:spendapp/widgets/base_button/base_button.dart';
import 'package:spendapp/widgets/base_page/base_page.dart';
import 'package:spendapp/widgets/input/base_input.dart';
import 'package:spendapp/widgets/toast/AppToast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/assets.gen.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BasePage(
        showBackIcon: false,
        title: "login.title".tr(),
        child: Container(
          padding: EdgeInsets.all(25.w),
          color: Colors.white,
          child: Column(
            children: [
              BaseInput(
                title: "Mã đại sứ/ Số điện thoại",
                hintText: "Nhập mã đại sứ/ Số điện thoại",
              ),
              SizedBox(height: 20.w),
              BaseInput(
                title: "Mật khẩu",
                hintText: "Nhập mật khẩu",
                isPassword: true,
                leftIcon: SvgPicture.asset(Assets.icons.icEyes),
                rightIcon: SvgPicture.asset(Assets.icons.icLock),
              ),
              SizedBox(height: 50.w),
              BaseButton.outline(
                onPress: () {
                  // context.navigateTo(const SignUpRoute());
                  AppToast.showToast("Xin chao", ToastType.error);
                },
                titleButton: "Go to SignUp",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
