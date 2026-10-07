import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendapp/core/config.dart';
import 'package:spendapp/data/remote/supabase_manager.dart';
import 'package:spendapp/presentations/home_flow/bloc/home_state.dart';
import 'package:spendapp/domain/entity/monthly_transaction.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(_initialState());

  final SupabaseManager _supabaseManager = getIt<SupabaseManager>();
  int _loadRequest = 0;
  int _transactionRequest = 0;

  static HomeState _initialState() {
    final now = DateTime.now();
    return HomeState(
      selectedYear: now.year,
      selectedMonth: now.month,
    );
  }

  void setTransactionFilter(TransactionFilter filter) {
    emit(state.copyWith(transactionFilter: filter, currentPage: 0));
    _loadFilteredTransactions();
  }

  void setPage(int page) {
    final maxPage = state.pageCount - 1;
    if (page < 0 || page > maxPage) return;
    emit(state.copyWith(currentPage: page));
  }

  void selectYear(int? year) {
    if (year == null) {
      emit(
        state.copyWith(
          clearSelectedYear: true,
          clearSelectedMonth: true,
          currentPage: 0,
        ),
      );
    } else {
      emit(
        state.copyWith(
          selectedYear: year,
          currentPage: 0,
        ),
      );
    }
    loadMonthlyIncome();
  }

  void selectMonth(int? month) {
    if (month == null) {
      emit(
        state.copyWith(
          clearSelectedMonth: true,
          currentPage: 0,
        ),
      );
    } else {
      if (state.selectedYear == null) return;
      emit(
        state.copyWith(
          selectedMonth: month,
          currentPage: 0,
        ),
      );
    }
    loadMonthlyIncome();
  }

  Future<void> loadMonthlyIncome() async {
    final request = ++_loadRequest;
    final transactionRequest = ++_transactionRequest;
    final startDate = _getStartDate(state);
    final endDate = _getEndDate(state);
    emit(
      state.copyWith(
        status: HomeLoadStatus.loading,
        transactionStatus: HomeLoadStatus.loading,
      ),
    );
    try {
      final transactions = await _supabaseManager.getTransactionsInRange(
        startDate: startDate,
        endDate: endDate,
      );
      if (isClosed ||
          request != _loadRequest ||
          transactionRequest != _transactionRequest) {
        return;
      }
      final income = transactions
          .where(
            (transaction) => transaction.type == MonthlyTransactionType.income,
          )
          .fold<double>(0, (total, transaction) => total + transaction.amount);
      final spend = transactions
          .where(
            (transaction) => transaction.type == MonthlyTransactionType.spend,
          )
          .fold<double>(0, (total, transaction) => total + transaction.amount);
      emit(
        state.copyWith(
          monthlyIncome: income,
          monthlySpend: spend,
          monthlyBalance: income - spend,
          transactions: transactions,
          status: HomeLoadStatus.loaded,
          transactionStatus: HomeLoadStatus.loaded,
        ),
      );
    } catch (_) {
      if (!isClosed && request == _loadRequest) {
        emit(
          state.copyWith(
            status: HomeLoadStatus.error,
            transactionStatus: HomeLoadStatus.error,
          ),
        );
      }
    }
  }

  Future<void> _loadFilteredTransactions() async {
    final request = ++_transactionRequest;
    final filter = state.transactionFilter;
    final startDate = _getStartDate(state);
    final endDate = _getEndDate(state);
    emit(state.copyWith(transactionStatus: HomeLoadStatus.loading));
    try {
      final transactions = await _supabaseManager.getTransactionsInRange(
        startDate: startDate,
        endDate: endDate,
        type: switch (filter) {
          TransactionFilter.all => null,
          TransactionFilter.income => MonthlyTransactionType.income,
          TransactionFilter.spend => MonthlyTransactionType.spend,
        },
      );
      if (isClosed || request != _transactionRequest) return;
      emit(
        state.copyWith(
          transactions: transactions,
          transactionStatus: HomeLoadStatus.loaded,
        ),
      );
    } catch (_) {
      if (!isClosed && request == _transactionRequest) {
        emit(state.copyWith(transactionStatus: HomeLoadStatus.error));
      }
    }
  }

  DateTime? _getStartDate(HomeState filterState) {
    final year = filterState.selectedYear;
    if (year == null) return null;
    final month = filterState.selectedMonth;
    if (month == null) return DateTime(year);
    return DateTime(year, month);
  }

  DateTime? _getEndDate(HomeState filterState) {
    final year = filterState.selectedYear;
    if (year == null) return null;
    final month = filterState.selectedMonth;
    if (month == null) return DateTime(year + 1);
    return DateTime(year, month + 1);
  }
}
