import 'package:json_annotation/json_annotation.dart';

part 'currency_chart_point_dto.g.dart';

/// Currency Chart Point DTO
/// 
/// API'den gelen veri modeli
@JsonSerializable()
class CurrencyChartPointDTO {
  final double value;
  @JsonKey(name: 'created_at')
  final String createdAt;

  CurrencyChartPointDTO({
    required this.value,
    required this.createdAt,
  });

  factory CurrencyChartPointDTO.fromJson(Map<String, dynamic> json) =>
      _$CurrencyChartPointDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyChartPointDTOToJson(this);
}

