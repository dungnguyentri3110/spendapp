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
  int _transactionFetchPage = 0;

  static HomeState _initialState() {
    final now = DateTime.now();
    return HomeState(selectedYear: now.year, selectedMonth: now.month);
  }

  void setTransactionFilter(TransactionFilter filter) {
    emit(
      state.copyWith(
        transactionFilter: filter,
        transactions: const [],
        visibleTransactionCount: transactionsPerPage,
        hasMoreTransactions: false,
        isLoadingMoreTransactions: false,
        loadMoreTransactionsError: false,
      ),
    );
    _loadFilteredTransactions();
  }

  Future<void> loadMoreTransactions() async {
    if (state.transactionStatus != HomeLoadStatus.loaded ||
        state.isLoadingMoreTransactions ||
        (!state.hasMoreTransactions &&
            state.visibleTransactionCount >= state.transactions.length)) {
      return;
    }

    if (!state.hasMoreTransactions) {
      emit(
        state.copyWith(
          visibleTransactionCount:
              state.visibleTransactionCount + transactionsPerPage,
          loadMoreTransactionsError: false,
        ),
      );
      return;
    }

    final request = ++_transactionRequest;
    final currentState = state;
    final offset = _transactionFetchPage * transactionsPerPage;
    emit(
      state.copyWith(
        isLoadingMoreTransactions: true,
        loadMoreTransactionsError: false,
      ),
    );
    try {
      final page = await _supabaseManager.getTransactionsPage(
        startDate: _getStartDate(currentState),
        endDate: _getEndDate(currentState),
        type: _getTransactionType(currentState.transactionFilter),
        offset: offset,
        limit: transactionsPerPage,
      );
      if (isClosed || request != _transactionRequest) return;
      _transactionFetchPage++;
      final transactions = [...state.transactions, ...page.transactions]
        ..sort(_compareTransactions);
      emit(
        state.copyWith(
          transactions: transactions,
          visibleTransactionCount:
              state.visibleTransactionCount + transactionsPerPage,
          hasMoreTransactions: page.hasMore,
          isLoadingMoreTransactions: false,
        ),
      );
    } catch (_) {
      if (!isClosed && request == _transactionRequest) {
        emit(
          state.copyWith(
            isLoadingMoreTransactions: false,
            loadMoreTransactionsError: true,
          ),
        );
      }
    }
  }

  void selectYear(int? year) {
    if (year == null) {
      emit(state.copyWith(clearSelectedYear: true, clearSelectedMonth: true));
    } else {
      emit(state.copyWith(selectedYear: year));
    }
    loadMonthlyIncome();
  }

  void selectMonth(int? month) {
    if (month == null) {
      emit(state.copyWith(clearSelectedMonth: true));
    } else {
      if (state.selectedYear == null) return;
      emit(state.copyWith(selectedMonth: month));
    }
    loadMonthlyIncome();
  }

  Future<void> loadMonthlyIncome() async {
    final request = ++_loadRequest;
    final transactionRequest = ++_transactionRequest;
    final startDate = _getStartDate(state);
    final endDate = _getEndDate(state);
    _transactionFetchPage = 0;
    emit(
      state.copyWith(
        status: HomeLoadStatus.loading,
        transactionStatus: HomeLoadStatus.loading,
        transactions: const [],
        visibleTransactionCount: transactionsPerPage,
        hasMoreTransactions: false,
        isLoadingMoreTransactions: false,
        loadMoreTransactionsError: false,
      ),
    );
    try {
      final allTransactionsFuture = _supabaseManager.getTransactionsInRange(
        startDate: startDate,
        endDate: endDate,
      );
      final firstPageFuture = _supabaseManager.getTransactionsPage(
        startDate: startDate,
        endDate: endDate,
        type: _getTransactionType(state.transactionFilter),
        offset: 0,
        limit: transactionsPerPage,
      );
      final allTransactions = await allTransactionsFuture;
      final firstPage = await firstPageFuture;
      if (isClosed ||
          request != _loadRequest ||
          transactionRequest != _transactionRequest) {
        return;
      }
      final income = allTransactions
          .where(
            (transaction) => transaction.type == MonthlyTransactionType.income,
          )
          .fold<double>(0, (total, transaction) => total + transaction.amount);
      final spend = allTransactions
          .where(
            (transaction) => transaction.type == MonthlyTransactionType.spend,
          )
          .fold<double>(0, (total, transaction) => total + transaction.amount);
      _transactionFetchPage = 1;
      emit(
        state.copyWith(
          monthlyIncome: income,
          monthlySpend: spend,
          monthlyBalance: income - spend,
          transactions: firstPage.transactions,
          status: HomeLoadStatus.loaded,
          transactionStatus: HomeLoadStatus.loaded,
          hasMoreTransactions: firstPage.hasMore,
        ),
      );
    } catch (_) {
      if (!isClosed &&
          request == _loadRequest &&
          transactionRequest == _transactionRequest) {
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
    _transactionFetchPage = 0;
    emit(
      state.copyWith(
        transactionStatus: HomeLoadStatus.loading,
        transactions: const [],
        visibleTransactionCount: transactionsPerPage,
        hasMoreTransactions: false,
        isLoadingMoreTransactions: false,
        loadMoreTransactionsError: false,
      ),
    );
    try {
      final page = await _supabaseManager.getTransactionsPage(
        startDate: startDate,
        endDate: endDate,
        type: _getTransactionType(filter),
        offset: 0,
        limit: transactionsPerPage,
      );
      if (isClosed || request != _transactionRequest) return;
      _transactionFetchPage = 1;
      emit(
        state.copyWith(
          transactions: page.transactions,
          transactionStatus: HomeLoadStatus.loaded,
          hasMoreTransactions: page.hasMore,
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

  MonthlyTransactionType? _getTransactionType(TransactionFilter filter) {
    return switch (filter) {
      TransactionFilter.all => null,
      TransactionFilter.income => MonthlyTransactionType.income,
      TransactionFilter.spend => MonthlyTransactionType.spend,
    };
  }

  int _compareTransactions(MonthlyTransaction a, MonthlyTransaction b) {
    final dateOrder = b.date.compareTo(a.date);
    return dateOrder != 0 ? dateOrder : b.createdAt.compareTo(a.createdAt);
  }
}
