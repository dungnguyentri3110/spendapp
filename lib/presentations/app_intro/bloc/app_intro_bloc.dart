import 'package:spendapp/data/remote/supabase_manager.dart';
import 'package:spendapp/storages/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config.dart';
import '../../../gen/assets.gen.dart';
import '../models/PageModel.dart';

class AppIntroBloc extends Cubit<int> {
  final PageController _controller = PageController();
  final prefs = getIt<SharePreferences>();
  final supabaseManager = getIt<SupabaseManager>();
  
  var currentPage = 0;
  final List<PageModel> pages = [
    PageModel(
      image: Assets.images.intro1.path,
      title: 'Kinh doanh giáo dục "3 Không"',
      content:
          'Làm việc hiệu quả cùng Edupia Đại Sứ – người bạn đồng hành tin cậy .',
    ),
    PageModel(
      image: Assets.images.intro2.path,
      title: 'Thu nhập bứt phá',
      content:
          'Nhận hoa hồng cá nhân cực cao chỉ với 2-3 đơn hàng mỗi tháng. Đặc biệt, hưởng thêm thu nhập thụ động khi bạn quản lý đội ngũ đại sứ cấp dưới.',
    ),
    PageModel(
      image: Assets.images.intro3.path,
      title: 'Bán hàng nhàn tênh bằng dữ liệu thật',
      content:
          'Edupia tổ chức lớp học thử cho khách. Kết quả điểm số và nhận xét của giáo viên được gửi về App ngay lập tức để bạn tự tin gọi điện chốt đơn.',
    ),
  ];

  PageController get controller => _controller;

  AppIntroBloc() : super(0);

  void nextPage() {
    currentPage += 1;
    emit(state + 1);

    if (currentPage <= 2) {
      _controller.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
      );
    }
  }

  Future saveViewAll() async {
    await prefs.setData("intro", "pass");
  }

  void getTotalAmountPerMonth() async {
    await supabaseManager.getTotalAmounPermonth();
  }
}
