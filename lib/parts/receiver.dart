part of '../models/receiver.dart';

Receiver _$ReceiverFromJson(Map<String, dynamic> json) {
  return Receiver(
    id: json['_id'] != null ? json['_id'] as String : null,
    type: json['type'] != null ? json['type'] as String : null,
    name: json['name'] != null ? json['name'] as String : null,
    bankName: json['bankName'] != null ? json['bankName'] as String : null,
    bankCardNo:
        json['bankCardNo'] != null ? json['bankCardNo'] as String : null,
    phone: json['phone'] != null ? json['phone'] as String : null,
    nameEng: json['nameEng'] != null ? json['nameEng'] as String : null,
    cityName: json['cityName'] != null ? json['cityName'] as String : null,
    idCardNo: json['idCardNo'] != null ? json['idCardNo'] as String : null,
  );
}

Map<String, dynamic> _$ReceiverToJson(Receiver instance) {
  Map<String, dynamic> json = {};

  if (instance.id != null) json['_id'] = instance.id;
  if (instance.type != null) json['type'] = instance.type;
  if (instance.name != null) json['name'] = instance.name;
  if (instance.bankName != null) json['bankName'] = instance.bankName;
  if (instance.bankCardNo != null) json['bankCardNo'] = instance.bankCardNo;
  if (instance.phone != null) json['phone'] = instance.phone;
  if (instance.nameEng != null) json['nameEng'] = instance.nameEng;
  if (instance.cityName != null) json['cityName'] = instance.cityName;
  if (instance.idCardNo != null) json['idCardNo'] = instance.idCardNo;

  return json;
}
