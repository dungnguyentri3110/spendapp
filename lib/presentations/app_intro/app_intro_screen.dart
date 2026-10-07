import 'package:auto_route/auto_route.dart';
import 'package:spendapp/navigations/routes.gr.dart';
import 'package:spendapp/presentations/app_intro/bloc/app_intro_bloc.dart';
import 'package:spendapp/presentations/app_intro/models/PageModel.dart';
import 'package:spendapp/themes/colors.dart';
import 'package:spendapp/utils/extension.dart';
import 'package:spendapp/widgets/base_button/base_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

@RoutePage()
class AppIntroScreen extends StatelessWidget {
  const AppIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => AppIntroBloc(), child: AppIntroView());
  }
}


class AppIntroView extends StatefulWidget {
  const AppIntroView({super.key});

  @override
  State<AppIntroView> createState() => _AppIntroViewState();
}

class _AppIntroViewState extends State<AppIntroView> {

  @override
  void initState() {
    super.initState();
    final bloc = context.read<AppIntroBloc>();
    bloc.getTotalAmountPerMonth();
  }

   @override
  Widget build(BuildContext context) {
    final bloc = context.read<AppIntroBloc>();
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: context.safeAreaSize.bottom),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                onPageChanged: (index) {},
                controller: bloc.controller,
                physics: NeverScrollableScrollPhysics(),
                children: bloc.pages.map((e) {
                  return PageScence(intro: e);
                }).toList(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 24.w),
              child: SmoothPageIndicator(
                controller: bloc.controller, // PageController
                count: 3,
                effect: ExpandingDotsEffect(
                  spacing: 16.0.w,
                  radius: 4.0.r,
                  dotWidth: 6.2.w,
                  dotHeight: 1.5.w,
                  paintStyle: PaintingStyle.stroke,
                  strokeWidth: 5.6.w,
                  dotColor: Color(0xffEDEEF1),
                  activeDotColor: Color(0xffD2D5DA),
                ), // your preferred effect
                onDotClicked: (index) {},
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 36.w),
              child: BaseButton(
                titleButton: "Tiếp tục",
                onPress: () async {
                  if (bloc.state >= 2) {
                    bloc.saveViewAll().then((_) {});
                    context.replaceRoute(LoginRoute());
                  } else {
                    bloc.nextPage();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(int index, int currentPage) {
    bool isActive = currentPage == index;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      // Thời gian animation
      curve: Curves.easeInOut,
      // Kiểu chuyển động mượt mà
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      // Khi active thì dài ra (ví dụ 30), khi không thì ngắn lại (10)
      width: isActive ? 35 : 12,
      decoration: BoxDecoration(
        color: isActive ? Colors.grey[400] : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class PageScence extends StatelessWidget {
  const PageScence({super.key, required this.intro});

  final PageModel intro;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Image.asset(intro.image),
          SizedBox(height: 40.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 39.w),
            child: Column(
              children: [
                Text(
                  intro.title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.w),
                Text(
                  intro.content,
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 16.sp,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
