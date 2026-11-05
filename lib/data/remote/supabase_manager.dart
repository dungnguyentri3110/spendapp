import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:spendapp/core/app_logger.dart';
import 'package:spendapp/data/models/total_amount_permonth_model/total_amount_permonth_model.dart';
import 'package:spendapp/domain/entity/monthly_transaction.dart';
import 'package:spendapp/domain/entity/yearly_transaction_summary.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Singleton()
class SupabaseManager {
  SupabaseManager();
  bool isInitialized = false;

  Future<Supabase> initialize() async {
    try {
      return await Supabase.initialize(
        url: "https://ktrqcnbzujbokjjwedsu.supabase.co",
        publishableKey: "sb_publishable_jdORM_2q97I56vmYWLfYXA__ipSm51U",
      ).then((value) {
        isInitialized = true;
        return value;
      });
    } catch (e) {
      Log.d("SupabaseManager initialize error: $e");
      rethrow;
    }
  }

  Future<TotalAmountPermonthModel?> getTotalAmounPermonth() async {
    try {
      if (!isInitialized) {
        return await Future.value();
      }
      final totalAmount = await Supabase.instance.client
          .from('income')
          .select()
          .limit(1)
          .single();
      return TotalAmountPermonthModel.fromJson(totalAmount);
    } catch (e) {
      Log.d("SupabaseManager getTotalAmounPermonth error: $e");
      return null;
    }
  }

  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (!isInitialized) {
        throw StateError('Supabase has not been initialized.');
      }
      return await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Log.d("SupabaseManager signInWithPassword error: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      if (!isInitialized) {
        throw StateError('Supabase has not been initialized.');
      }
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      Log.d("SupabaseManager signOut error: $e");
      rethrow;
    }
  }

  Future<void> insertTotalAmountPerMonth(
    int amount,
    String? amountSource,
    String? timeChange,
  ) async {
    try {
      if (!isInitialized) {
        throw StateError('Supabase has not been initialized.');
      }
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null) {
        throw StateError('Sign in is required to insert income.');
      }
      await client.from('income').insert({
        'amount': amount,
        'amount_source': amountSource,
        'time_change': timeChange,
        'user_id': user.id,
      });
    } catch (e) {
      Log.d("SupabaseManager insertTotalAmountPerMonth error: $e");
      rethrow;
    }
  }

  Future<List<MonthlyTransaction>> getTransactionsInRange({
    DateTime? startDate,
    DateTime? endDate,
    MonthlyTransactionType? type,
  }) async {
    try {
      if (!isInitialized) {
        throw StateError('Supabase has not been initialized.');
      }
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null) {
        throw StateError('Sign in is required to load income.');
      }

      final results = await Future.wait<List<Map<String, dynamic>>>([
        if (type == null || type == MonthlyTransactionType.income)
          _fetchTransactions(
            table: 'income',
            dateColumn: 'time_change',
            select: 'amount, amount_source, time_change, created_at',
            userId: user.id,
            startDate: startDate,
            endDate: endDate,
          )
        else
          Future.value(<Map<String, dynamic>>[]),
        if (type == null || type == MonthlyTransactionType.spend)
          _fetchTransactions(
            table: 'spend',
            dateColumn: 'time_spend',
            select: 'amount, used_message, time_spend, created_at',
            userId: user.id,
            startDate: startDate,
            endDate: endDate,
          )
        else
          Future.value(<Map<String, dynamic>>[]),
      ]);

      final transactions = _mapTransactions(results[0], results[1]);
      return transactions;
    } catch (e) {
      Log.d("SupabaseManager getTransactionsInRange error: $e");
      rethrow;
    }
  }

  Future<({List<MonthlyTransaction> transactions, bool hasMore})>
  getTransactionsPage({
    DateTime? startDate,
    DateTime? endDate,
    MonthlyTransactionType? type,
    required int offset,
    required int limit,
  }) async {
    try {
      if (!isInitialized) {
        throw StateError('Supabase has not been initialized.');
      }
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null) {
        throw StateError('Sign in is required to load income.');
      }

      final results = await Future.wait<List<Map<String, dynamic>>>([
        if (type == null || type == MonthlyTransactionType.income)
          _fetchTransactions(
            table: 'income',
            dateColumn: 'time_change',
            select: 'amount, amount_source, time_change, created_at',
            userId: user.id,
            startDate: startDate,
            endDate: endDate,
            offset: offset,
            limit: limit + 1,
          )
        else
          Future.value(<Map<String, dynamic>>[]),
        if (type == null || type == MonthlyTransactionType.spend)
          _fetchTransactions(
            table: 'spend',
            dateColumn: 'time_spend',
            select: 'amount, used_message, time_spend, created_at',
            userId: user.id,
            startDate: startDate,
            endDate: endDate,
            offset: offset,
            limit: limit + 1,
          )
        else
          Future.value(<Map<String, dynamic>>[]),
      ]);

      final hasMore =
          results[0].length > limit || results[1].length > limit;
      final transactions = _mapTransactions(
        results[0].take(limit).toList(),
        results[1].take(limit).toList(),
      );
      return (transactions: transactions, hasMore: hasMore);
    } catch (e) {
      Log.d("SupabaseManager getTransactionsPage error: $e");
      rethrow;
    }
  }

  List<MonthlyTransaction> _mapTransactions(
    List<Map<String, dynamic>> incomeRows,
    List<Map<String, dynamic>> spendRows,
  ) {
    final transactions = <MonthlyTransaction>[
      for (final row in incomeRows)
        MonthlyTransaction(
          amount: (row['amount'] as num?)?.toDouble() ?? 0,
          description: row['amount_source'] as String? ?? '',
          date: DateTime.parse(row['time_change'] as String),
          createdAt: DateTime.parse(row['created_at'] as String),
          type: MonthlyTransactionType.income,
        ),
      for (final row in spendRows)
        MonthlyTransaction(
          amount: (row['amount'] as num?)?.toDouble() ?? 0,
          description: row['used_message'] as String? ?? '',
          date: DateTime.parse(row['time_spend'] as String),
          createdAt: DateTime.parse(row['created_at'] as String),
          type: MonthlyTransactionType.spend,
        ),
    ];
    transactions.sort((a, b) {
      final dateOrder = b.date.compareTo(a.date);
      return dateOrder != 0 ? dateOrder : b.createdAt.compareTo(a.createdAt);
    });
    return transactions;
  }

  Future<YearlyTransactionSummary> getYearlyTransactionSummary(int year) async {
    try {
      if (!isInitialized) {
        throw StateError('Supabase has not been initialized.');
      }
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw StateError('Sign in is required to load yearly statistics.');
      }

      final startDate = DateTime(year);
      final endDate = DateTime(year + 1);
      final results = await Future.wait<List<Map<String, dynamic>>>([
        _fetchTransactions(
          table: 'income',
          dateColumn: 'time_change',
          select: 'amount, time_change',
          userId: user.id,
          startDate: startDate,
          endDate: endDate,
        ),
        _fetchTransactions(
          table: 'spend',
          dateColumn: 'time_spend',
          select: 'amount, time_spend',
          userId: user.id,
          startDate: startDate,
          endDate: endDate,
        ),
      ]);

      final incomeByMonth = List<double>.filled(12, 0);
      final spendByMonth = List<double>.filled(12, 0);
      for (final row in results[0]) {
        final month = DateTime.parse(row['time_change'] as String).month;
        incomeByMonth[month - 1] += (row['amount'] as num?)?.toDouble() ?? 0;
      }
      for (final row in results[1]) {
        final month = DateTime.parse(row['time_spend'] as String).month;
        spendByMonth[month - 1] += (row['amount'] as num?)?.toDouble() ?? 0;
      }

      return YearlyTransactionSummary(
        incomeByMonth: incomeByMonth,
        spendByMonth: spendByMonth,
      );
    } catch (e) {
      Log.d("SupabaseManager getYearlyTransactionSummary error: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchTransactions({
    required String table,
    required String dateColumn,
    required String select,
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    int? offset,
    int? limit,
  }) async {
    var query = Supabase.instance.client
        .from(table)
        .select(select)
        .eq('user_id', userId);
    if (startDate != null && endDate != null) {
      query = query
          .gte(dateColumn, _formatDate(startDate))
          .lt(dateColumn, _formatDate(endDate));
    }
    else if (startDate != null) {
      query = query.gte(dateColumn, _formatDate(startDate));
    }
    else if (endDate != null) {
      query = query.lt(dateColumn, _formatDate(endDate));
    }

    final orderedQuery = query
        .order(dateColumn, ascending: false)
        .order('created_at', ascending: false);
    final rows = offset != null && limit != null
        ? await orderedQuery.range(offset, offset + limit - 1)
        : await orderedQuery;
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<void> insertSpend(
    int amount,
    String usedMessage,
    String timeSpend,
  ) async {
    try {
      if (!isInitialized) {
        throw StateError('Supabase has not been initialized.');
      }
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null) {
        throw StateError('Sign in is required to insert spend.');
      }

      await client.from('spend').insert({
        'amount': amount,
        'used_message': usedMessage,
        'time_spend': timeSpend,
        'user_id': user.id,
      });
    } catch (e) {
      Log.d("SupabaseManager insertSpend error: $e");
      rethrow;
    }
  }

  String _formatDate(DateTime date) {
    final formattedForSupabase = DateFormat('yyyy-MM-dd').format(date);
    return formattedForSupabase;
  }
}
