import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendapp/navigations/routes.gr.dart';
import 'package:spendapp/presentations/home_flow/bloc/home_bloc.dart';
import 'package:spendapp/presentations/home_flow/bloc/home_state.dart';
import 'package:spendapp/domain/entity/monthly_transaction.dart';
import 'package:spendapp/themes/colors.dart';
import 'package:spendapp/utils/helper.dart';
import 'package:spendapp/widgets/base_button/base_button.dart';
import 'package:spendapp/widgets/base_page/base_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..loadMonthlyIncome(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return BasePage(
          title: 'home.title'.tr(),
          showBackIcon: false,
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'home.period_balance'.tr(),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(height: 10.w),
                      if (state.status == HomeLoadStatus.loading ||
                          state.status == HomeLoadStatus.initial)
                        const Center(child: CircularProgressIndicator())
                      else if (state.status == HomeLoadStatus.error)
                        Text(
                          'home.load_error'.tr(),
                          style: TextStyle(color: Colors.red, fontSize: 14.sp),
                        )
                      else ...[
                        Text(
                          '${formatMoney(state.monthlyBalance.toStringAsFixed(0))} ₫',
                          style: TextStyle(
                            color: state.monthlyBalance < 0
                                ? Colors.red
                                : AppColors.primary,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.w),
                        Text(
                          '${'home.period_income'.tr()}: ${formatMoney(state.monthlyIncome.toStringAsFixed(0))} ₫',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(height: 4.w),
                        Text(
                          '${'home.period_spend'.tr()}: ${formatMoney(state.monthlySpend.toStringAsFixed(0))} ₫',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 16.w),
                Row(
                  children: [
                    Expanded(
                      child: BaseButton(
                        titleButton: 'home.add_income'.tr(),
                        height: 44.w,
                        onPress: () async {
                          await context.router.push(const MainRoute());
                          if (context.mounted) {
                            context.read<HomeBloc>().loadMonthlyIncome();
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: BaseButton.outline(
                        titleButton: 'home.add_spend'.tr(),
                        height: 44.w,
                        onPress: () async {
                          await context.router.push(const SpendRoute());
                          if (context.mounted) {
                            context.read<HomeBloc>().loadMonthlyIncome();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.w),
                Text(
                  'home.transactions'.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.w),
                Row(
                  children: [
                    _buildDateFilter(
                      label: 'home.year'.tr(),
                      value: state.selectedYear,
                      enabled: true,
                      items: [
                        DropdownMenuItem<int?>(
                          value: null,
                          child: Text(
                            'home.all_years'.tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ...List.generate(
                          106,
                          (index) => DateTime.now().year + 5 - index,
                        ).map(
                          (year) => DropdownMenuItem<int?>(
                            value: year,
                            child: Text(
                              year.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      onChanged: context.read<HomeBloc>().selectYear,
                    ),
                    SizedBox(width: 6.w),
                    _buildDateFilter(
                      label: 'home.month'.tr(),
                      value: state.selectedMonth,
                      enabled: state.selectedYear != null,
                      items: [
                        DropdownMenuItem<int?>(
                          value: null,
                          child: Text(
                            'home.all_months'.tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ...List.generate(12, (index) => index + 1).map(
                          (month) => DropdownMenuItem<int?>(
                            value: month,
                            child: Text(
                              month.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      onChanged: context.read<HomeBloc>().selectMonth,
                    ),
                    SizedBox(width: 6.w),
                    _buildTransactionFilter(context, state),
                  ],
                ),
                SizedBox(height: 8.w),
                Expanded(
                  child: ListView(
                    children: [
                      if (state.transactionStatus == HomeLoadStatus.loading ||
                          state.transactionStatus == HomeLoadStatus.initial)
                        const Center(child: CircularProgressIndicator())
                      else if (state.transactionStatus ==
                              HomeLoadStatus.loaded &&
                          state.filteredTransactions.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.w),
                          child: Text(
                            state.transactions.isEmpty
                                ? 'home.no_transactions'.tr()
                                : 'home.no_filtered_transactions'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14.sp,
                            ),
                          ),
                        )
                      else if (state.transactionStatus == HomeLoadStatus.error)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.w),
                          child: Text(
                            'home.load_error'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.sp,
                            ),
                          ),
                        )
                      else
                        ...state.visibleTransactions.map(
                          (transaction) =>
                              _TransactionTile(transaction: transaction),
                        ),
                      if (state.transactionStatus == HomeLoadStatus.loaded &&
                          state.pageCount > 1) ...[
                        SizedBox(height: 12.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: state.currentPage > 0
                                  ? () => context.read<HomeBloc>().setPage(
                                      state.currentPage - 1,
                                    )
                                  : null,
                              icon: const Icon(Icons.chevron_left),
                            ),
                            Text(
                              'home.page'.tr(
                                args: [
                                  (state.currentPage + 1).toString(),
                                  state.pageCount.toString(),
                                ],
                              ),
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            IconButton(
                              onPressed: state.currentPage < state.pageCount - 1
                                  ? () => context.read<HomeBloc>().setPage(
                                      state.currentPage + 1,
                                    )
                                  : null,
                              icon: const Icon(Icons.chevron_right),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateFilter({
    required String label,
    required int? value,
    required bool enabled,
    required List<DropdownMenuItem<int?>> items,
    required ValueChanged<int?> onChanged,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12.sp)),
          SizedBox(height: 4.w),
          DropdownButtonFormField<int?>(
            value: value,
            isExpanded: true,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 6.w,
                vertical: 7.w,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            style: TextStyle(fontSize: 12.sp, color: Colors.black87),
            items: items,
            onChanged: enabled ? onChanged : null,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionFilter(BuildContext context, HomeState state) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('home.filter_type'.tr(), style: TextStyle(fontSize: 12.sp)),
          SizedBox(height: 4.w),
          DropdownButtonFormField<TransactionFilter>(
            value: state.transactionFilter,
            isExpanded: true,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 6.w,
                vertical: 7.w,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            style: TextStyle(fontSize: 12.sp, color: Colors.black87),
            items: [
              DropdownMenuItem(
                value: TransactionFilter.all,
                child: Text(
                  'home.filter_all'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DropdownMenuItem(
                value: TransactionFilter.income,
                child: Text(
                  'home.filter_income'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DropdownMenuItem(
                value: TransactionFilter.spend,
                child: Text(
                  'home.filter_spend'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            onChanged: (filter) {
              if (filter != null) {
                context.read<HomeBloc>().setTransactionFilter(filter);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final MonthlyTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == MonthlyTransactionType.income;
    final color = isIncome ? Colors.green : Colors.red;
    final title = transaction.description.isEmpty
        ? (isIncome ? 'home.income'.tr() : 'home.spend'.tr())
        : transaction.description;

    return Container(
      margin: EdgeInsets.only(bottom: 10.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            isIncome ? Icons.add_circle_outline : Icons.remove_circle_outline,
            color: color,
            size: 28.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.w),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm', context.locale.toString())
                      .format(transaction.createdAt),
                  style: TextStyle(color: Colors.black54, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '${isIncome ? '+' : '-'}${formatMoney(transaction.amount.toStringAsFixed(0))} ₫',
            style: TextStyle(
              color: color,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
