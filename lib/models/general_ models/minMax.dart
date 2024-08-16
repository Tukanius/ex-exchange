part '../../parts/general_parts/minMax.dart';

class MinMax {
  num? min;
  num? max;

  MinMax({
    this.min,
    this.max,
  });
  static $fromJson(Map<String, dynamic> json) => _$MinMaxFromJson(json);

  factory MinMax.fromJson(Map<String, dynamic> json) => _$MinMaxFromJson(json);
  Map<String, dynamic> toJson() => _$MinMaxToJson(this);
}
