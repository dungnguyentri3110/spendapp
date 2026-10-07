enum SpendSubmitStatus { idle, success, error }

enum SpendFieldError { required, invalid }

class SpendState {
  const SpendState({
    this.amount,
    this.message,
    required this.day,
    required this.month,
    required this.year,
    this.amountError,
    this.messageError,
    this.isSubmitting = false,
    this.submitStatus = SpendSubmitStatus.idle,
  });

  final String? amount;
  final String? message;
  final int day;
  final int month;
  final int year;
  final SpendFieldError? amountError;
  final SpendFieldError? messageError;
  final bool isSubmitting;
  final SpendSubmitStatus submitStatus;

  SpendState copyWith({
    String? amount,
    String? message,
    int? day,
    int? month,
    int? year,
    SpendFieldError? amountError,
    SpendFieldError? messageError,
    bool? isSubmitting,
    SpendSubmitStatus? submitStatus,
    bool clearAmount = false,
    bool clearMessage = false,
    bool clearAmountError = false,
    bool clearMessageError = false,
  }) {
    return SpendState(
      amount: clearAmount ? null : amount ?? this.amount,
      message: clearMessage ? null : message ?? this.message,
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
      amountError: clearAmountError ? null : amountError ?? this.amountError,
      messageError: clearMessageError
          ? null
          : messageError ?? this.messageError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitStatus: submitStatus ?? this.submitStatus,
    );
  }
}
