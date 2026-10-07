enum IncomeSubmitStatus { idle, success, error }

enum InputValidationError { required, invalid }

class MainScreenState {
  MainScreenState({
    this.amount,
    this.source,
    required this.day,
    required this.month,
    required this.year,
    this.isSubmitting = false,
    this.submitStatus = IncomeSubmitStatus.idle,
    this.amountError,
    this.sourceError,
  });

  final String? amount;
  final String? source;
  final int day;
  final int month;
  final int year;
  final bool isSubmitting;
  final IncomeSubmitStatus submitStatus;
  final InputValidationError? amountError;
  final InputValidationError? sourceError;

  MainScreenState copyWith({
    String? amount,
    String? source,
    int? day,
    int? month,
    int? year,
    bool? isSubmitting,
    IncomeSubmitStatus? submitStatus,
    InputValidationError? amountError,
    InputValidationError? sourceError,
    bool clearAmount = false,
    bool clearSource = false,
    bool clearAmountError = false,
    bool clearSourceError = false,
  }) {
    return MainScreenState(
      amount: clearAmount ? null : amount ?? this.amount,
      source: clearSource ? null : source ?? this.source,
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitStatus: submitStatus ?? this.submitStatus,
      amountError: clearAmountError ? null : amountError ?? this.amountError,
      sourceError: clearSourceError ? null : sourceError ?? this.sourceError,
    );
  }
}
