import 'package:intl/intl.dart';
import 'package:spendapp/core/config.dart';
import 'package:spendapp/data/remote/supabase_manager.dart';
import 'package:spendapp/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendapp/presentations/main_screen/bloc/main_screen_state.dart';

class MainScreenBloc extends Cubit<MainScreenState> {
  MainScreenBloc() : super(_initialState());

  static MainScreenState _initialState() {
    final now = DateTime.now();
    return MainScreenState(day: now.day, month: now.month, year: now.year);
  }

  final SupabaseManager _supabaseManager = getIt<SupabaseManager>();

  void updateAmount(String value) {
    emit(
      state.copyWith(
        amount: value,
        clearAmountError: true,
        submitStatus: IncomeSubmitStatus.idle,
      ),
    );
  }

  void updateSource(String value) {
    emit(
      state.copyWith(
        source: value,
        clearSourceError: true,
        submitStatus: IncomeSubmitStatus.idle,
      ),
    );
  }

  void selectDay(int day) {
    emit(state.copyWith(day: day, submitStatus: IncomeSubmitStatus.idle));
  }

  void selectMonth(int month) {
    final maxDay = _daysInMonth(state.year, month);
    emit(
      state.copyWith(
        month: month,
        day: state.day > maxDay ? maxDay : state.day,
        submitStatus: IncomeSubmitStatus.idle,
      ),
    );
  }

  void selectYear(int year) {
    final maxDay = _daysInMonth(year, state.month);
    emit(
      state.copyWith(
        year: year,
        day: state.day > maxDay ? maxDay : state.day,
        submitStatus: IncomeSubmitStatus.idle,
      ),
    );
  }

  int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

  Future<void> submitIncome() async {
    final amountText = state.amount?.trim();
    final source = state.source?.trim();
    final amount = amountText == null ? null : parseMoney(amountText);

    final amountError = amountText == null || amountText.isEmpty
        ? InputValidationError.required
        : amount == null || amount <= 0
        ? InputValidationError.invalid
        : null;
    final sourceError = source == null || source.isEmpty
        ? InputValidationError.required
        : null;
    if (amountError != null || sourceError != null) {
      emit(
        state.copyWith(
          amountError: amountError,
          sourceError: sourceError,
          clearAmountError: amountError == null,
          clearSourceError: sourceError == null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(isSubmitting: true, submitStatus: IncomeSubmitStatus.idle),
    );
    try {
      final timeChange = DateTime.utc(state.year, state.month, state.day);
      String formattedForSupabase = DateFormat('yyyy-MM-dd').format(timeChange);
      await _supabaseManager.insertTotalAmountPerMonth(
        amount!,
        source!,
        formattedForSupabase,
      );
      if (isClosed) return;
      amountController.clear();
      sourceController.clear();
      emit(
        state.copyWith(
          clearAmount: true,
          clearSource: true,
          isSubmitting: false,
          submitStatus: IncomeSubmitStatus.success,
        ),
      );
    } catch (_) {
      if (isClosed) return;
      emit(
        state.copyWith(
          isSubmitting: false,
          submitStatus: IncomeSubmitStatus.error,
        ),
      );
    }
  }

  final amountController = TextEditingController();
  final sourceController = TextEditingController();

  @override
  Future<void> close() {
    amountController.dispose();
    sourceController.dispose();
    return super.close();
  }
}
