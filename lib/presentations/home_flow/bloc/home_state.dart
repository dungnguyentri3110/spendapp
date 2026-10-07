import 'package:spendapp/domain/entity/monthly_transaction.dart';

enum HomeLoadStatus { initial, loading, loaded, error }

enum TransactionFilter { all, income, spend }

const int transactionsPerPage = 20;

class HomeState {
  const HomeState({
    this.monthlyIncome = 0,
    this.monthlySpend = 0,
    this.monthlyBalance = 0,
    this.transactions = const [],
    this.transactionFilter = TransactionFilter.all,
    this.currentPage = 0,
    this.selectedYear,
    this.selectedMonth,
    this.status = HomeLoadStatus.initial,
    this.transactionStatus = HomeLoadStatus.initial,
  });

  final double monthlyIncome;
  final double monthlySpend;
  final double monthlyBalance;
  final List<MonthlyTransaction> transactions;
  final TransactionFilter transactionFilter;
  final int currentPage;
  final int? selectedYear;
  final int? selectedMonth;
  final HomeLoadStatus status;
  final HomeLoadStatus transactionStatus;

  List<MonthlyTransaction> get filteredTransactions {
    return switch (transactionFilter) {
      TransactionFilter.all => transactions,
      TransactionFilter.income =>
        transactions
            .where(
              (transaction) =>
                  transaction.type == MonthlyTransactionType.income,
            )
            .toList(),
      TransactionFilter.spend =>
        transactions
            .where(
              (transaction) => transaction.type == MonthlyTransactionType.spend,
            )
            .toList(),
    };
  }

  int get pageCount =>
      (filteredTransactions.length / transactionsPerPage).ceil();

  List<MonthlyTransaction> get visibleTransactions {
    final start = currentPage * transactionsPerPage;
    if (start >= filteredTransactions.length) return const [];
    final end = (start + transactionsPerPage).clamp(
      0,
      filteredTransactions.length,
    );
    return filteredTransactions.sublist(start, end);
  }

  HomeState copyWith({
    double? monthlyIncome,
    double? monthlySpend,
    double? monthlyBalance,
    List<MonthlyTransaction>? transactions,
    TransactionFilter? transactionFilter,
    int? currentPage,
    int? selectedYear,
    int? selectedMonth,
    bool clearSelectedYear = false,
    bool clearSelectedMonth = false,
    HomeLoadStatus? status,
    HomeLoadStatus? transactionStatus,
  }) {
    return HomeState(
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlySpend: monthlySpend ?? this.monthlySpend,
      monthlyBalance: monthlyBalance ?? this.monthlyBalance,
      transactions: transactions ?? this.transactions,
      transactionFilter: transactionFilter ?? this.transactionFilter,
      currentPage: currentPage ?? this.currentPage,
      selectedYear: clearSelectedYear
          ? null
          : selectedYear ?? this.selectedYear,
      selectedMonth: clearSelectedMonth
          ? null
          : selectedMonth ?? this.selectedMonth,
      status: status ?? this.status,
      transactionStatus: transactionStatus ?? this.transactionStatus,
    );
  }
}
