// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_chart_point_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyChartPointDTO _$CurrencyChartPointDTOFromJson(
  Map<String, dynamic> json,
) => CurrencyChartPointDTO(
  value: (json['value'] as num).toDouble(),
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$CurrencyChartPointDTOToJson(
  CurrencyChartPointDTO instance,
) => <String, dynamic>{
  'value': instance.value,
  'created_at': instance.createdAt,
};
