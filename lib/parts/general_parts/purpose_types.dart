part of '../../models/general_ models/purpose_types.dart';

PurposeTypes _$PurposeTypesFromJson(Map<String, dynamic> json) {
  return PurposeTypes(
    code: json['code'] != null ? json['code'] as String : null,
    name: json['name'] != null ? json['name'] as String : null,
  );
}

Map<String, dynamic> _$PurposeTypesToJson(PurposeTypes instance) {
  Map<String, dynamic> json = {};

  if (instance.code != null) json['code'] = instance.code;
  if (instance.name != null) json['name'] = instance.name;

  return json;
}
