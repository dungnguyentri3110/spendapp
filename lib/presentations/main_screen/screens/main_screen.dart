import 'package:auto_route/auto_route.dart';
import 'package:spendapp/widgets/base_button/base_button.dart';
import 'package:spendapp/widgets/input/base_input.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendapp/presentations/main_screen/bloc/main_screen_state.dart';
import 'package:spendapp/presentations/main_screen/bloc/main_screen_bloc.dart';
import 'package:spendapp/widgets/base_page/base_page.dart';
import 'package:spendapp/widgets/toast/AppToast.dart';
import 'package:spendapp/utils/helper.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainScreenBloc(),
      child: MainScreenPage(),
    );
  }
}

class MainScreenPage extends StatelessWidget {
  const MainScreenPage({super.key});

  Widget _buildDateDropdown({
    required String label,
    required int value,
    required List<int> values,
    required ValueChanged<int?> onChanged,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          ),
          SizedBox(height: 8.w),
          DropdownButtonFormField<int>(
            value: value,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.w,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            items: values
                .map(
                  (item) => DropdownMenuItem<int>(
                    value: item,
                    child: Text(item.toString()),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainScreenBloc, MainScreenState>(
      listenWhen: (previous, current) =>
          previous.submitStatus != current.submitStatus,
      listener: (context, state) {
        switch (state.submitStatus) {
          case IncomeSubmitStatus.success:
            AppToast.showToast("income.save_success".tr(), ToastType.success);
            break;
          case IncomeSubmitStatus.error:
            AppToast.showToast("income.save_error".tr(), ToastType.error);
            break;
          case IncomeSubmitStatus.idle:
            break;
        }
      },
      builder: (context, state) {
        final bloc = context.read<MainScreenBloc>();
        return BasePage(
          title: "income.title".tr(),
          showBackIcon: true,
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BaseInput(
                      title: "income.amount".tr(),
                      hintText: "income.amount_hint".tr(),
                      required: true,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                      ),
                      controller: bloc.amountController,
                      inputFormatters: [MoneyInputFormatter()],
                      onChangeText: bloc.updateAmount,
                      errorText: switch (state.amountError) {
                        InputValidationError.required =>
                          "income.amount_required".tr(),
                        InputValidationError.invalid =>
                          "income.amount_invalid".tr(),
                        null => null,
                      },
                    ),
                    SizedBox(height: 20.w),
                    BaseInput(
                      title: "income.source".tr(),
                      hintText: "income.source_hint".tr(),
                      required: true,
                      controller: bloc.sourceController,
                      onChangeText: bloc.updateSource,
                      errorText:
                          state.sourceError == InputValidationError.required
                          ? "income.source_required".tr()
                          : null,
                    ),
                    SizedBox(height: 20.w),
                    Text(
                      "income.date".tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.w),
                    Row(
                      children: [
                        _buildDateDropdown(
                          label: "income.day".tr(),
                          value: state.day,
                          values: List.generate(
                            DateTime(state.year, state.month + 1, 0).day,
                            (index) => index + 1,
                          ),
                          onChanged: (value) {
                            if (value != null) bloc.selectDay(value);
                          },
                        ),
                        SizedBox(width: 10.w),
                        _buildDateDropdown(
                          label: "income.month".tr(),
                          value: state.month,
                          values: List.generate(12, (index) => index + 1),
                          onChanged: (value) {
                            if (value != null) bloc.selectMonth(value);
                          },
                        ),
                        SizedBox(width: 10.w),
                        _buildDateDropdown(
                          label: "income.year".tr(),
                          value: state.year,
                          values: List.generate(
                            106,
                            (index) => DateTime.now().year + 5 - index,
                          ),
                          onChanged: (value) {
                            if (value != null) bloc.selectYear(value);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 32.w),
                    BaseButton(
                      titleButton: "income.submit".tr(),
                      height: 48.w,
                      onPress: state.isSubmitting ? null : bloc.submitIncome,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
