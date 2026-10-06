import 'package:spendapp/domain/entity/music_entity_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_model.g.dart';

@JsonSerializable()
class MusicModelResponse {
  final List<MusicModel>? listMusic;

  MusicModelResponse({ this.listMusic});

  factory MusicModelResponse.fromJson(Map<String, dynamic> json) =>
      _$MusicModelResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MusicModelResponseToJson(this);

}

@JsonSerializable()
class MusicModel extends MusicEntityResponse {
  MusicModel({super.id, super.name});

  factory MusicModel.fromJson(Map<String, dynamic> json) =>
      _$MusicModelFromJson(json);

  Map<String, dynamic> toJson() => _$MusicModelToJson(this);
}
