import 'package:spendapp/data/models/music_model/music_model.dart';
import 'package:spendapp/data/remote/api_manager.dart';
import 'package:spendapp/domain/entity/base_response/base_response.dart';
import 'package:dartz/dartz.dart';

abstract class ExampleRepository {
  Future<Either<ApiException, BaseResponse<List<MusicModel>>>> getListMusic();
}
