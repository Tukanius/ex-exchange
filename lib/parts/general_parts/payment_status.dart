part of '../../models/general_ models/payment_status.dart';

PaymentStatus _$PaymentStatusFromJson(Map<String, dynamic> json) {
  return PaymentStatus(
    code: json['code'] != null ? json['code'] as String : null,
    name: json['name'] != null ? json['name'] as String : null,
  );
}

Map<String, dynamic> _$PaymentStatusToJson(PaymentStatus instance) {
  Map<String, dynamic> json = {};

  if (instance.code != null) json['code'] = instance.code;
  if (instance.name != null) json['name'] = instance.name;

  return json;
}
