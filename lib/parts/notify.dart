part of '../models/notify.dart';

Notify _$NotifyFromJson(Map<String, dynamic> json) {
  return Notify(
    id: json['_id'] != null ? json['_id'] as String : null,
    user: json['user'] != null ? json['user'] as String : null,
    title: json['title'] != null ? json['title'] as String : null,
    body: json['body'] != null ? json['body'] as String : null,
    type: json['type'] != null ? json['type'] as String : null,
    isSeen: json['isSeen'] != null ? json['isSeen'] as bool : null,
    createdAt: json['createdAt'] != null ? json['createdAt'] as String : null,
    updatedAt: json['updatedAt'] != null ? json['updatedAt'] as String : null,
    data: json['data'] != null ? json['data'] as String : null,
  );
}

Map<String, dynamic> _$NotifyToJson(Notify instance) {
  Map<String, dynamic> json = {};
  if (instance.id != null) json['_id'] = instance.id;
  if (instance.user != null) json['user'] = instance.user;
  if (instance.title != null) json['title'] = instance.title;
  if (instance.body != null) json['body'] = instance.body;
  if (instance.type != null) json['type'] = instance.type;
  if (instance.isSeen != null) json['isSeen'] = instance.isSeen;

  if (instance.createdAt != null) json['createdAt'] = instance.createdAt;
  if (instance.updatedAt != null) json['updatedAt'] = instance.updatedAt;
  if (instance.data != null) json['data'] = instance.data;

  return json;
}
