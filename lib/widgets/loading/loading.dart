import 'package:spendapp/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loading extends ModalRoute<void> {
  static void show() {
    Navigator.push(GlobalApp.init().appContext!, Loading());
  }

  static void hide() {
    Navigator.pop(GlobalApp.init().appContext!);
  }

  @override
  Color? get barrierColor => Colors.black.withValues(alpha: 0.3);

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: CircularProgressIndicator(color: Colors.red, strokeWidth: 5.w),
      ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration.zero;
}
