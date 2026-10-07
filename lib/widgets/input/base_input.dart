import 'package:spendapp/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseInput extends StatefulWidget {
  const BaseInput({
    super.key,
    required this.title,
    required this.hintText,
    this.onChangeText,
    this.rightIcon,
    this.leftIcon,
    this.isPassword,
    this.required,
    this.keyboardType,
    this.controller,
    this.inputFormatters,
    this.errorText,
  });

  final String title;
  final String hintText;
  final Function(String text)? onChangeText;
  final Widget? rightIcon;
  final Widget? leftIcon;
  final bool? isPassword;
  final bool? required;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;

  @override
  State<BaseInput> createState() => _BaseInputState();
}

class _BaseInputState extends State<BaseInput> {
  late FocusNode _focusNode;
  bool _focus = false;
  bool _show = true;

  @override
  void initState() {
    _focusNode = FocusNode();
    if (widget.isPassword == true) {
      setState(() {
        _show = false;
      });
    }
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _focus = true;
        });
      } else {
        setState(() {
          _focus = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (widget.required == true) ...[
              Text(
                "* ",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textE53A22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.text111827,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.w),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              width: 1.w,
              color: widget.errorText != null
                  ? AppColors.textE53A22
                  : _focus
                  ? AppColors.borderInputFocus
                  : AppColors.borderInput,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(50),
                blurRadius: 10.r,
                spreadRadius: 0.5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (widget.rightIcon != null) ...[
                Container(
                  width: 20.w,
                  height: 20.w,
                  margin: EdgeInsets.only(left: 12.w),
                  child: widget.rightIcon,
                ),
              ],

              Expanded(
                child: TextField(
                  obscureText: !_show,
                  focusNode: _focusNode,
                  keyboardType: widget.keyboardType,
                  controller: widget.controller,
                  inputFormatters: widget.inputFormatters,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.text111827,
                  ),
                  onChanged: (text) {
                    widget.onChangeText?.call(text);
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: widget.hintText,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.hintTextColor,
                    ),
                    contentPadding: EdgeInsets.all(12.w),
                  ),
                ),
              ),
              if (widget.leftIcon != null) ...[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      _show = !_show;
                    });
                  },
                  child: Container(
                    width: 20.w,
                    height: 40.w,
                    margin: EdgeInsets.only(right: 12.w),
                    child: widget.leftIcon,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (widget.errorText != null) ...[
          SizedBox(height: 4.w),
          Text(
            widget.errorText!,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textE53A22,
            ),
          ),
        ],
      ],
    );
  }
}
