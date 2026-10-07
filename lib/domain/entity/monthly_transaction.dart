enum MonthlyTransactionType { income, spend }

class MonthlyTransaction {
  const MonthlyTransaction({
    required this.amount,
    required this.description,
    required this.date,
    required this.createdAt,
    required this.type,
  });

  final double amount;
  final String description;
  final DateTime date;
  final DateTime createdAt;
  final MonthlyTransactionType type;
}
