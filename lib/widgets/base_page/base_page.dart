import 'package:spendapp/widgets/header/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasePage extends StatelessWidget {
  const BasePage({
    super.key,
    required this.child,
    this.title,
    this.showBackIcon = true,
  });
  final Widget child;
  final String? title;
  final bool? showBackIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.w),
        child: AppHeader(title: title ?? "", showIconBack: showBackIcon),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight),
        child: child,
      ),
    );
  }
}
