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
    this.visibleTransactionCount = transactionsPerPage,
    this.hasMoreTransactions = false,
    this.isLoadingMoreTransactions = false,
    this.loadMoreTransactionsError = false,
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
  final int visibleTransactionCount;
  final bool hasMoreTransactions;
  final bool isLoadingMoreTransactions;
  final bool loadMoreTransactionsError;
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

  List<MonthlyTransaction> get visibleTransactions {
    final end = visibleTransactionCount.clamp(0, filteredTransactions.length);
    return filteredTransactions.sublist(0, end);
  }

  HomeState copyWith({
    double? monthlyIncome,
    double? monthlySpend,
    double? monthlyBalance,
    List<MonthlyTransaction>? transactions,
    TransactionFilter? transactionFilter,
    int? visibleTransactionCount,
    bool? hasMoreTransactions,
    bool? isLoadingMoreTransactions,
    bool? loadMoreTransactionsError,
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
      visibleTransactionCount:
          visibleTransactionCount ?? this.visibleTransactionCount,
      hasMoreTransactions: hasMoreTransactions ?? this.hasMoreTransactions,
      isLoadingMoreTransactions:
          isLoadingMoreTransactions ?? this.isLoadingMoreTransactions,
      loadMoreTransactionsError:
          loadMoreTransactionsError ?? this.loadMoreTransactionsError,
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
