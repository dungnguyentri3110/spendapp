import 'package:spendapp/domain/entity/yearly_transaction_summary.dart';

enum YearlyStatisticsStatus { initial, loading, loaded, error }

class YearlyStatisticsState {
  const YearlyStatisticsState({
    required this.selectedYear,
    this.summary,
    this.status = YearlyStatisticsStatus.initial,
  });

  final int selectedYear;
  final YearlyTransactionSummary? summary;
  final YearlyStatisticsStatus status;

  YearlyStatisticsState copyWith({
    int? selectedYear,
    YearlyTransactionSummary? summary,
    YearlyStatisticsStatus? status,
  }) {
    return YearlyStatisticsState(
      selectedYear: selectedYear ?? this.selectedYear,
      summary: summary ?? this.summary,
      status: status ?? this.status,
    );
  }
}
