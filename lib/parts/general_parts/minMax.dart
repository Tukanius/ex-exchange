part of '../../models/general_ models/minMax.dart';

MinMax _$MinMaxFromJson(Map<String, dynamic> json) {
  return MinMax(
    min: json['min'] != null ? json['min'] as num : null,
    max: json['max'] != null ? json['max'] as num : null,
  );
}

Map<String, dynamic> _$MinMaxToJson(MinMax instance) {
  Map<String, dynamic> json = {};

  if (instance.min != null) json['min'] = instance.min;
  if (instance.max != null) json['max'] = instance.max;

  return json;
}
