import 'package:json_annotation/json_annotation.dart';
import 'package:spendapp/domain/entity/total_amount_permonth_response/total_amount_permonth_response.dart';
part 'total_amount_permonth_model.g.dart';

@JsonSerializable()
class TotalAmountPermonthModel extends TotalAmountPerMonthResponse {
  TotalAmountPermonthModel({
    super.amount,
    super.id,
    super.amount_source,
    super.time_change,
  });

  factory TotalAmountPermonthModel.fromJson(Map<String, dynamic> json) =>
      _$TotalAmountPermonthModelFromJson(json);

  Map<String, dynamic> toJson() => _$TotalAmountPermonthModelToJson(this);
}
