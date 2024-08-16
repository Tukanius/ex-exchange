part '../../parts/general_parts/amount_range.dart';

class AmountRange {
  String? code;
  num? value;

  AmountRange({
    this.code,
    this.value,
  });
  static $fromJson(Map<String, dynamic> json) => _$AmountRangeFromJson(json);

  factory AmountRange.fromJson(Map<String, dynamic> json) =>
      _$AmountRangeFromJson(json);
  Map<String, dynamic> toJson() => _$AmountRangeToJson(this);
}
