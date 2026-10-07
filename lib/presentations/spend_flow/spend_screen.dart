import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendapp/presentations/spend_flow/bloc/spend_bloc.dart';
import 'package:spendapp/presentations/spend_flow/bloc/spend_state.dart';
import 'package:spendapp/utils/helper.dart';
import 'package:spendapp/widgets/base_button/base_button.dart';
import 'package:spendapp/widgets/base_page/base_page.dart';
import 'package:spendapp/widgets/input/base_input.dart';
import 'package:spendapp/widgets/toast/AppToast.dart';

@RoutePage()
class SpendScreen extends StatelessWidget {
  const SpendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => SpendBloc(), child: const _SpendForm());
  }
}

class _SpendForm extends StatelessWidget {
  const _SpendForm();

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
          Text(label, style: TextStyle(fontSize: 14.sp)),
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
    return BlocConsumer<SpendBloc, SpendState>(
      listenWhen: (previous, current) =>
          previous.submitStatus != current.submitStatus,
      listener: (context, state) {
        if (state.submitStatus == SpendSubmitStatus.success) {
          AppToast.showToast('spend.save_success'.tr(), ToastType.success);
        } else if (state.submitStatus == SpendSubmitStatus.error) {
          AppToast.showToast('spend.save_error'.tr(), ToastType.error);
        }
      },
      builder: (context, state) {
        final bloc = context.read<SpendBloc>();
        return BasePage(
          title: 'spend.title'.tr(),
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BaseInput(
                      title: 'spend.amount'.tr(),
                      hintText: 'spend.amount_hint'.tr(),
                      required: true,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                      ),
                      controller: bloc.amountController,
                      inputFormatters: [MoneyInputFormatter()],
                      onChangeText: bloc.updateAmount,
                      errorText: switch (state.amountError) {
                        SpendFieldError.required =>
                          'spend.amount_required'.tr(),
                        SpendFieldError.invalid => 'spend.amount_invalid'.tr(),
                        null => null,
                      },
                    ),
                    SizedBox(height: 20.w),
                    BaseInput(
                      title: 'spend.message'.tr(),
                      hintText: 'spend.message_hint'.tr(),
                      required: true,
                      controller: bloc.messageController,
                      onChangeText: bloc.updateMessage,
                      errorText: state.messageError == SpendFieldError.required
                          ? 'spend.message_required'.tr()
                          : null,
                    ),
                    SizedBox(height: 20.w),
                    Text(
                      'spend.date'.tr(),
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
                          label: 'spend.day'.tr(),
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
                          label: 'spend.month'.tr(),
                          value: state.month,
                          values: List.generate(12, (index) => index + 1),
                          onChanged: (value) {
                            if (value != null) bloc.selectMonth(value);
                          },
                        ),
                        SizedBox(width: 10.w),
                        _buildDateDropdown(
                          label: 'spend.year'.tr(),
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
                      titleButton: 'spend.submit'.tr(),
                      height: 48.w,
                      onPress: state.isSubmitting ? null : bloc.submitSpend,
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
