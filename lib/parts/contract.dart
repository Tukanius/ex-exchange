part of '../models/contract.dart';

Contract _$ContractFromJson(Map<String, dynamic> json) {
  return Contract(
    name: json['name'] != null ? json['name'] as String : null,
    description:
        json['description'] != null ? json['description'] as String : null,
  );
}

Map<String, dynamic> _$ContractToJson(Contract instance) {
  Map<String, dynamic> json = {};

  if (instance.name != null) json['name'] = instance.name;
  if (instance.description != null) json['description'] = instance.description;

  return json;
}
