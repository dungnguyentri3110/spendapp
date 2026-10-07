class YearlyTransactionSummary {
  const YearlyTransactionSummary({
    required this.incomeByMonth,
    required this.spendByMonth,
  });

  final List<double> incomeByMonth;
  final List<double> spendByMonth;

  double get totalIncome =>
      incomeByMonth.fold(0, (total, amount) => total + amount);

  double get totalSpend =>
      spendByMonth.fold(0, (total, amount) => total + amount);
}
