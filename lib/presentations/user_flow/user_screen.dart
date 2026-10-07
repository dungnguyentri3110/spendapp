import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendapp/core/config.dart';
import 'package:spendapp/data/remote/supabase_manager.dart';
import 'package:spendapp/navigations/routes.gr.dart';
import 'package:spendapp/widgets/base_page/base_page.dart';
import 'package:spendapp/widgets/toast/AppToast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _isSigningOut = false;

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);
    try {
      await getIt<SupabaseManager>().signOut();
      if (mounted) {
        await context.router.replaceAll([const LoginRoute()]);
      }
    } catch (error) {
      if (mounted) {
        AppToast.showToast('user.sign_out_error'.tr(), ToastType.error);
        setState(() => _isSigningOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final name = _userName(user);

    return BasePage(
      title: 'user.title'.tr(),
      showBackIcon: false,
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (name != null) ...[
              _UserInfoTile(label: 'user.name'.tr(), value: name),
              SizedBox(height: 16.w),
            ],
            _UserInfoTile(label: 'user.email'.tr(), value: user?.email ?? ''),
            SizedBox(height: 16.w),
            OutlinedButton.icon(
              onPressed: () {
                context.router.push(const YearlyStatisticsRoute());
              },
              icon: const Icon(Icons.bar_chart),
              label: Text('user.view_statistics'.tr()),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.w),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 48.w,
              child: OutlinedButton.icon(
                onPressed: _isSigningOut ? null : _signOut,
                icon: _isSigningOut
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout),
                label: Text(
                  _isSigningOut
                      ? 'user.signing_out'.tr()
                      : 'user.sign_out'.tr(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _userName(User? user) {
    final metadata = user?.userMetadata;
    for (final key in ['name', 'full_name', 'display_name']) {
      final value = metadata?[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }
}

class _UserInfoTile extends StatelessWidget {
  const _UserInfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.black54, fontSize: 13.sp),
          ),
          SizedBox(height: 6.w),
          Text(value, style: TextStyle(fontSize: 16.sp)),
        ],
      ),
    );
  }
}
