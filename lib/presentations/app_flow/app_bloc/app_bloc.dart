import 'package:spendapp/presentations/app_flow/app_bloc/app_action.dart';
import 'package:spendapp/presentations/app_flow/app_bloc/app_state.dart';
import 'package:spendapp/utils/global.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  AppBloc() : super(AppState.init()) {
    on<ChangeAppLanguage>(changeAppLanguage);
  }

  void changeAppLanguage(ChangeAppLanguage action, Emitter<AppState> emit) {
    GlobalApp.instance?.setLocale(action.language.value);
    emit(state.copy(language: action.language));
  }
}
