import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendapp/presentations/statistics_flow/bloc/yearly_statistics_bloc.dart';
import 'package:spendapp/presentations/statistics_flow/bloc/yearly_statistics_state.dart';
import 'package:spendapp/themes/colors.dart';
import 'package:spendapp/utils/helper.dart';
import 'package:spendapp/widgets/base_page/base_page.dart';

@RoutePage()
class YearlyStatisticsScreen extends StatelessWidget {
  const YearlyStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => YearlyStatisticsBloc()..load(),
      child: const _YearlyStatisticsView(),
    );
  }
}

class _YearlyStatisticsView extends StatefulWidget {
  const _YearlyStatisticsView();

  @override
  State<_YearlyStatisticsView> createState() => _YearlyStatisticsViewState();
}

class _YearlyStatisticsViewState extends State<_YearlyStatisticsView> {
  static const double _monthChartWidth = 140;
  final ScrollController _chartScrollController = ScrollController();

  @override
  void dispose() {
    _chartScrollController.dispose();
    super.dispose();
  }

  void _focusRelevantMonth(int year) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_chartScrollController.hasClients) return;

      final month = year == DateTime.now().year ? DateTime.now().month : 1;
      final monthCenter = 52.w + (month - 0.5) * _monthChartWidth.w;
      final position = _chartScrollController.position;
      final targetOffset = (monthCenter - position.viewportDimension / 2).clamp(
        0.0,
        position.maxScrollExtent,
      );
      _chartScrollController.jumpTo(targetOffset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<YearlyStatisticsBloc, YearlyStatisticsState>(
      listenWhen: (previous, current) =>
          current.status == YearlyStatisticsStatus.loaded &&
          (previous.status != current.status ||
              previous.selectedYear != current.selectedYear),
      listener: (context, state) => _focusRelevantMonth(state.selectedYear),
      builder: (context, state) {
        final currentYear = DateTime.now().year;
        return BasePage(
          title: 'statistics.title'.tr(),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'statistics.year'.tr(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.w),
                DropdownButtonFormField<int>(
                  initialValue: state.selectedYear,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.w,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  items: List.generate(106, (index) => currentYear + 5 - index)
                      .map(
                        (year) => DropdownMenuItem(
                          value: year,
                          child: Text(year.toString()),
                        ),
                      )
                      .toList(),
                  onChanged: (year) {
                    if (year != null) {
                      context.read<YearlyStatisticsBloc>().selectYear(year);
                    }
                  },
                ),
                SizedBox(height: 20.w),
                Expanded(child: _buildContent(context, state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, YearlyStatisticsState state) {
    return switch (state.status) {
      YearlyStatisticsStatus.initial || YearlyStatisticsStatus.loading =>
        const Center(child: CircularProgressIndicator()),
      YearlyStatisticsStatus.error => Center(
        child: Text(
          'statistics.load_error'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red, fontSize: 14.sp),
        ),
      ),
      YearlyStatisticsStatus.loaded =>
        _hasNoData(state) ? _buildEmptyState() : _buildChart(state),
    };
  }

  bool _hasNoData(YearlyStatisticsState state) {
    final summary = state.summary!;
    return summary.totalIncome == 0 && summary.totalSpend == 0;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.insert_chart_outlined, size: 52.w, color: Colors.black38),
          SizedBox(height: 12.w),
          Text(
            'statistics.no_data'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 15.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(YearlyStatisticsState state) {
    final summary = state.summary!;
    final maxValue = math.max(
      1,
      summary.incomeByMonth.followedBy(summary.spendByMonth).reduce(math.max),
    );
    final maxY = maxValue * 1.5;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _Legend(
                color: AppColors.primary,
                label: 'statistics.income'.tr(),
              ),
              SizedBox(width: 20.w),
              _Legend(color: Colors.red, label: 'statistics.spend'.tr()),
            ],
          ),
          SizedBox(height: 16.w),
          SizedBox(
            height: 304.w,
            child: Padding(
              padding: EdgeInsets.only(top: 24.w),
              child: SingleChildScrollView(
                controller: _chartScrollController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: _monthChartWidth.w * 12,
                  child: BarChart(
                    BarChartData(
                      maxY: maxY,
                      alignment: BarChartAlignment.spaceAround,
                      barGroups: List.generate(
                        12,
                        (index) => BarChartGroupData(
                          x: index,
                          barsSpace: 48.w,
                          barRods: [
                            _buildRod(
                              value: summary.incomeByMonth[index],
                              color: AppColors.primary,
                            ),
                            _buildRod(
                              value: summary.spendByMonth[index],
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                      gridData: FlGridData(
                        drawVerticalLine: true,
                        verticalInterval: 0.5,
                        checkToShowVerticalLine: (value) => value % 1 != 0,
                        getDrawingVerticalLine: (_) =>
                            FlLine(color: Colors.grey.shade300, strokeWidth: 1),
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 52.w,
                            getTitlesWidget: (value, meta) => SideTitleWidget(
                              meta: meta,
                              child: Text(
                                _compactAmount(value),
                                style: TextStyle(fontSize: 9.sp),
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28.w,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final month = value.toInt() + 1;
                              if (month < 1 || month > 12) {
                                return const SizedBox.shrink();
                              }
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  month.toString(),
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            'statistics.month_axis'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 12.sp),
          ),
          SizedBox(height: 20.w),
          _SummaryTile(
            label: 'statistics.total_income'.tr(),
            value: summary.totalIncome,
            color: AppColors.primary,
          ),
          SizedBox(height: 10.w),
          _SummaryTile(
            label: 'statistics.total_spend'.tr(),
            value: summary.totalSpend,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  BarChartRodData _buildRod({required double value, required Color color}) {
    return BarChartRodData(
      toY: value,
      color: color,
      width: 22.w,
      borderRadius: BorderRadius.vertical(top: Radius.circular(3.r)),
      label: BarChartRodLabel(
        show: true,
        text: formatMoney(value.toStringAsFixed(0)),
        style: TextStyle(
          color: color,
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
        ),
        offset: Offset(0, 6.w),
      ),
    );
  }

  String _compactAmount(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B';
    }
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text(label, style: TextStyle(fontSize: 12.sp)),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14.sp)),
          Text(
            '${formatMoney(value.toStringAsFixed(0))} ₫',
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
