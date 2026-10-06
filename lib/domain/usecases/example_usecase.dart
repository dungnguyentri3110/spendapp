import 'package:spendapp/data/models/music_model/music_model.dart';
import 'package:spendapp/data/remote/api_manager.dart';
import 'package:spendapp/domain/entity/base_response/base_response.dart';
import 'package:spendapp/domain/repository/example_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
final class ExampleUseCase {
  final ExampleRepository _repository;

  ExampleUseCase({required ExampleRepository repository})
    : _repository = repository;

  Future<Either<ApiException, BaseResponse<List<MusicModel>>>>
  getListMusic() async {
    return await _repository.getListMusic();
  }
}
