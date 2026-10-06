import 'package:auto_route/annotations.dart';
import 'package:spendapp/widgets/base_page/base_page.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "SignUpScreen",
      child: Column(children: [Text("Hello this is Sign Up screen")]),
    );
  }
}
