import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spendapp/core/config.dart';
import 'package:spendapp/data/remote/supabase_manager.dart';
import 'package:spendapp/presentations/spend_flow/bloc/spend_state.dart';
import 'package:spendapp/utils/helper.dart';

class SpendBloc extends Cubit<SpendState> {
  SpendBloc() : super(_initialState());

  static SpendState _initialState() {
    final now = DateTime.now();
    return SpendState(day: now.day, month: now.month, year: now.year);
  }

  final SupabaseManager _supabaseManager = getIt<SupabaseManager>();
  final amountController = TextEditingController();
  final messageController = TextEditingController();

  int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

  void updateAmount(String value) => emit(
    state.copyWith(
      amount: value,
      clearAmountError: true,
      submitStatus: SpendSubmitStatus.idle,
    ),
  );

  void updateMessage(String value) => emit(
    state.copyWith(
      message: value,
      clearMessageError: true,
      submitStatus: SpendSubmitStatus.idle,
    ),
  );

  void selectDay(int day) =>
      emit(state.copyWith(day: day, submitStatus: SpendSubmitStatus.idle));

  void selectMonth(int month) {
    final maxDay = _daysInMonth(state.year, month);
    emit(
      state.copyWith(
        month: month,
        day: state.day > maxDay ? maxDay : state.day,
        submitStatus: SpendSubmitStatus.idle,
      ),
    );
  }

  void selectYear(int year) {
    final maxDay = _daysInMonth(year, state.month);
    emit(
      state.copyWith(
        year: year,
        day: state.day > maxDay ? maxDay : state.day,
        submitStatus: SpendSubmitStatus.idle,
      ),
    );
  }

  Future<void> submitSpend() async {
    final amountText = state.amount?.trim();
    final message = state.message?.trim();
    final amount = amountText == null ? null : parseMoney(amountText);
    final amountError = amountText == null || amountText.isEmpty
        ? SpendFieldError.required
        : amount == null || amount <= 0
        ? SpendFieldError.invalid
        : null;
    final messageError = message == null || message.isEmpty
        ? SpendFieldError.required
        : null;

    if (amountError != null || messageError != null) {
      emit(
        state.copyWith(
          amountError: amountError,
          messageError: messageError,
          clearAmountError: amountError == null,
          clearMessageError: messageError == null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(isSubmitting: true, submitStatus: SpendSubmitStatus.idle),
    );
    try {
      final timeSpend = DateTime.utc(state.year, state.month, state.day);
      final formattedForSupabase = DateFormat('yyyy-MM-dd').format(timeSpend);
      await _supabaseManager.insertSpend(
        amount!,
        message!,
        formattedForSupabase,
      );
      if (isClosed) return;
      amountController.clear();
      messageController.clear();
      emit(
        state.copyWith(
          clearAmount: true,
          clearMessage: true,
          isSubmitting: false,
          submitStatus: SpendSubmitStatus.success,
        ),
      );
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isSubmitting: false,
            submitStatus: SpendSubmitStatus.error,
          ),
        );
      }
    }
  }

  @override
  Future<void> close() {
    amountController.dispose();
    messageController.dispose();
    return super.close();
  }
}
