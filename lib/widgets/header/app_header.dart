import 'package:spendapp/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.showIconBack = true,
    required this.title,
    this.onBackPress,
  });
  final bool? showIconBack;
  final String title;
  final Function? onBackPress;

  @override
  Widget build(BuildContext context) {
    final sizeApp = context.screenSize;
    final safeArea = context.safeAreaSize;
    return Container(
      height: 55.w + safeArea.top,
      width: sizeApp.width,
      padding: EdgeInsets.only(top: safeArea.top, left: 12.w, right: 12.w),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showIconBack == true) ...[
            GestureDetector(
              onTap: () {
                if (onBackPress == null) {
                  Navigator.pop(context);
                } else {
                  onBackPress?.call();
                }
              },
              child: Container(
                width: 40.w,
                height: 40.w,
                alignment: Alignment.centerLeft,
                child: Icon(Icons.arrow_back),
              ),
            ),
          ] else ...[
            SizedBox(width: 40.w, height: 40.w),
          ],
          Text(
            title,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 40.w, height: 40.w),
        ],
      ),
    );
  }
}
