part '../parts/notify.dart';

class Notify {
  String? id;
  String? user;
  String? title;
  String? body;
  String? type;
  String? data;
  bool? isSeen;
  String? createdAt;
  String? updatedAt;

  Notify({
    this.id,
    this.user,
    this.title,
    this.body,
    this.type,
    this.isSeen,
    this.createdAt,
    this.updatedAt,
    this.data,
  });
  static $fromJson(Map<String, dynamic> json) => _$NotifyFromJson(json);

  factory Notify.fromJson(Map<String, dynamic> json) => _$NotifyFromJson(json);
  Map<String, dynamic> toJson() => _$NotifyToJson(this);
}
