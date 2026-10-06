import 'package:spendapp/data/models/music_model/music_model.dart';
import 'package:spendapp/data/remote/api_manager.dart';
import 'package:spendapp/data/remote/endpoint.dart';
import 'package:spendapp/domain/entity/base_response/base_response.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ApiServices {
  final ApiManager _apiManager;

  ApiServices({required ApiManager apiManager}) : _apiManager = apiManager;
}

extension ExampleServices on ApiServices {
  Future<Either<ApiException, BaseResponse<List<MusicModel>>>>
  getListMusic() async {
    return await _apiManager.requestApi(
      Endpoint.getListMusic,
      method: RequestMethod.get,
      fromJsonT: (json) =>
          (json as List).map((e) => MusicModel.fromJson(e)).toList(),
    );
  }
}
