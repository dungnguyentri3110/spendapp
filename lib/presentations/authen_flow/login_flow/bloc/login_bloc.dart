import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendapp/core/config.dart';
import 'package:spendapp/data/remote/supabase_manager.dart';
import 'package:spendapp/presentations/authen_flow/login_flow/bloc/login_state.dart';

class LoginBloc extends Cubit<LoginState> {
  LoginBloc() : super(const LoginState());

  final SupabaseManager _supabaseManager = getIt<SupabaseManager>();

  void updateEmail(String email) {
    emit(
      state.copyWith(
        email: email,
        clearEmailError: true,
        status: LoginStatus.idle,
      ),
    );
  }

  void updatePassword(String password) {
    emit(
      state.copyWith(
        password: password,
        clearPasswordError: true,
        status: LoginStatus.idle,
      ),
    );
  }

  Future<void> signIn() async {
    final email = state.email.trim();
    final password = state.password;
    final emailError = email.isEmpty
        ? LoginFieldError.required
        : !email.contains('@') || !email.contains('.')
        ? LoginFieldError.invalid
        : null;
    final passwordError = password.isEmpty ? LoginFieldError.required : null;

    if (emailError != null || passwordError != null) {
      emit(
        state.copyWith(
          emailError: emailError,
          passwordError: passwordError,
          clearEmailError: emailError == null,
          clearPasswordError: passwordError == null,
        ),
      );
      return;
    }

    emit(state.copyWith(isSubmitting: true, status: LoginStatus.idle));
    try {
      final response = await _supabaseManager.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session == null || isClosed) {
        if (!isClosed) {
          emit(state.copyWith(isSubmitting: false, status: LoginStatus.error));
        }
        return;
      }
      emit(state.copyWith(isSubmitting: false, status: LoginStatus.success));
    } catch (_) {
      if (!isClosed) {
        emit(state.copyWith(isSubmitting: false, status: LoginStatus.error));
      }
    }
  }
}
