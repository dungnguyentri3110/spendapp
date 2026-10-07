enum LoginStatus { idle, success, error }

enum LoginFieldError { required, invalid }

class LoginState {
  const LoginState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.status = LoginStatus.idle,
    this.isSubmitting = false,
  });

  final String email;
  final String password;
  final LoginFieldError? emailError;
  final LoginFieldError? passwordError;
  final LoginStatus status;
  final bool isSubmitting;

  LoginState copyWith({
    String? email,
    String? password,
    LoginFieldError? emailError,
    LoginFieldError? passwordError,
    LoginStatus? status,
    bool? isSubmitting,
    bool clearEmailError = false,
    bool clearPasswordError = false,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: clearEmailError ? null : emailError ?? this.emailError,
      passwordError: clearPasswordError
          ? null
          : passwordError ?? this.passwordError,
      status: status ?? this.status,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
