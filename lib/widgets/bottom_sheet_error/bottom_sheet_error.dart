import 'package:spendapp/widgets/base_button/base_button.dart';
import 'package:spendapp/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetError extends ModalRoute<void> {
  final String? title;
  final String? content;
  final Function? onPress1;
  final Function? onPress2;
  final String? titleButton1;
  final String? titleButton2;

  BottomSheetError({
    this.title = 'Thông báo',
    this.content = 'Error',
    this.onPress1,
    this.onPress2,
    this.titleButton1,
    this.titleButton2,
  });

  static show({
    String? title,
    String? content,
    Function? onPress1,
    Function? onPress2,
    String? titleButton1,
    String? titleButton2,
  }) {
    Navigator.push(
      GlobalApp.init().appContext!,
      BottomSheetError(
        title: title,
        content: content,
        onPress1: onPress1,
        onPress2: onPress2,
        titleButton1: titleButton1,
        titleButton2: titleButton2,
      ),
    );
  }

  static hide() {
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
    return FadeTransition(
      opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              width: 300.w,
              constraints: BoxConstraints(maxHeight: 450.w, minHeight: 200.w),
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.only(bottom: 12.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 40.w,
                    color: Colors.orange,
                    child: Center(
                      child: Text(
                        title ?? '',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    margin: EdgeInsets.symmetric(vertical: 16.w),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(content ?? '', textAlign: TextAlign.center),
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 4.w,
                    ),
                    child: BaseButton(
                      onPress: () {
                        onPress1?.call();
                      },
                      titleButton: titleButton1,
                    ),
                  ),
                  if (onPress2 != null) ...[
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 4.w,
                      ),
                      child: BaseButton.outline(
                        onPress: () {
                          onPress2?.call();
                        },
                        titleButton: titleButton2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 250);
}
