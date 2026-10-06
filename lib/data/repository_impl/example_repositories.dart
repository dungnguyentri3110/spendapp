import 'package:spendapp/data/models/music_model/music_model.dart';
import 'package:spendapp/data/remote/api_manager.dart';
import 'package:spendapp/data/remote/api_services/api_services.dart';
import 'package:spendapp/domain/entity/base_response/base_response.dart';
import 'package:spendapp/domain/repository/example_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ExampleRepository)
class ExampleRepositoryImpl implements ExampleRepository {
  final ApiServices _apiServices;

  ExampleRepositoryImpl({required ApiServices apiServices})
    : _apiServices = apiServices;

  @override
  Future<Either<ApiException, BaseResponse<List<MusicModel>>>>
  getListMusic() async {
    return _apiServices.getListMusic();
  }
}
