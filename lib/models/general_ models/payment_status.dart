part '../../parts/general_parts/payment_status.dart';

class PaymentStatus {
  String? code;
  String? name;

  PaymentStatus({
    this.code,
    this.name,
  });
  static $fromJson(Map<String, dynamic> json) => _$PaymentStatusFromJson(json);

  factory PaymentStatus.fromJson(Map<String, dynamic> json) =>
      _$PaymentStatusFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentStatusToJson(this);
}
