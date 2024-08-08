part '../../parts/general_parts/payment_method.dart';

class PaymentMethod {
  String? code;
  String? name;

  PaymentMethod({
    this.code,
    this.name,
  });
  static $fromJson(Map<String, dynamic> json) => _$PaymentMethodFromJson(json);

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}
