import 'package:spendapp/domain/usecases/example_usecase.dart';
import 'package:spendapp/presentations/main_flow/home_flow/blocs/home_state.dart';
import 'package:spendapp/utils/app_logger.dart';
import 'package:spendapp/utils/global.dart';
import 'package:spendapp/widgets/loading/loading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(HomeState.init());

  final ExampleUseCase _exampleUseCase = getIt<ExampleUseCase>();

  Future<void> getListMusic() async {
    Loading.show();
    final response = await _exampleUseCase.getListMusic();
    Log.d(response);
    response.fold(
      (error) async {
        Log.d(error);
        await Future.delayed(const Duration(seconds: 3), () {
          Loading.hide();
          // BottomSheetError.show(
          //   title: Translate.t.titleError,
          //   content:
          //       "The dimensions assume that the border is being used in a square space. When applied to a rectangular space, the border paints in the center of the rectangle",
          //   titleButton1: Translate.t.nextButton,
          //   onPress1: () {
          //     BottomSheetError.hide();
          //   },
          //   titleButton2: Translate.t.closeButton,
          //   onPress2: () {
          //     BottomSheetError.hide();
          //   },
          // );
        });
      },
      (res) {
        Log.d(res);
        emit(state.copy(listMusic: res.data));
      },
    );
    Loading.hide();
  }
}
