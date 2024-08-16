part of '../models/receiver.dart';

Receiver _$ReceiverFromJson(Map<String, dynamic> json) {
  return Receiver(
    id: json['_id'] != null ? json['_id'] as String : null,
    type: json['type'] != null ? json['type'] as String : null,
    accountName:
        json['accountName'] != null ? json['accountName'] as String : null,
    bankName: json['bankName'] != null ? json['bankName'] as String : null,
    accountNumber:
        json['accountNumber'] != null ? json['accountNumber'] as String : null,
    phone: json['phone'] != null ? json['phone'] as String : null,
    branchName:
        json['branchName'] != null ? json['branchName'] as String : null,
    branchAddress:
        json['branchAddress'] != null ? json['branchAddress'] as String : null,
    swiftCode: json['swiftCode'] != null ? json['swiftCode'] as String : null,
  );
}

Map<String, dynamic> _$ReceiverToJson(Receiver instance) {
  Map<String, dynamic> json = {};

  if (instance.id != null) json['_id'] = instance.id;
  if (instance.type != null) json['type'] = instance.type;
  if (instance.accountName != null) json['accountName'] = instance.accountName;
  if (instance.bankName != null) json['bankName'] = instance.bankName;
  if (instance.accountNumber != null)
    json['accountNumber'] = instance.accountNumber;
  if (instance.phone != null) json['phone'] = instance.phone;
  if (instance.branchName != null) json['branchName'] = instance.branchName;

  if (instance.branchAddress != null)
    json['branchAddress'] = instance.branchAddress;
  if (instance.swiftCode != null) json['swiftCode'] = instance.swiftCode;

  return json;
}
