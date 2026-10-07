// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_amount_permonth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TotalAmountPermonthModel _$TotalAmountPermonthModelFromJson(
  Map<String, dynamic> json,
) => TotalAmountPermonthModel(
  amount: (json['amount'] as num?)?.toDouble(),
  id: (json['id'] as num?)?.toInt(),
  amount_source: json['amount_source'] as String?,
  time_change: json['time_change'] as String?,
);

Map<String, dynamic> _$TotalAmountPermonthModelToJson(
  TotalAmountPermonthModel instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'id': instance.id,
  'amount_source': instance.amount_source,
  'time_change': instance.time_change,
};
