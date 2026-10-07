import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendapp/core/config.dart';
import 'package:spendapp/data/remote/supabase_manager.dart';
import 'package:spendapp/presentations/statistics_flow/bloc/yearly_statistics_state.dart';

class YearlyStatisticsBloc extends Cubit<YearlyStatisticsState> {
  YearlyStatisticsBloc()
    : super(YearlyStatisticsState(selectedYear: DateTime.now().year));

  final SupabaseManager _supabaseManager = getIt<SupabaseManager>();
  int _requestId = 0;

  Future<void> selectYear(int year) async {
    emit(
      state.copyWith(
        selectedYear: year,
        status: YearlyStatisticsStatus.loading,
      ),
    );
    final requestId = ++_requestId;
    try {
      final summary = await _supabaseManager.getYearlyTransactionSummary(year);
      if (isClosed || requestId != _requestId) return;
      emit(
        state.copyWith(
          summary: summary,
          status: YearlyStatisticsStatus.loaded,
        ),
      );
    } catch (_) {
      if (isClosed || requestId != _requestId) return;
      emit(state.copyWith(status: YearlyStatisticsStatus.error));
    }
  }

  Future<void> load() => selectYear(state.selectedYear);
}
