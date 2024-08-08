part '../parts/receiver.dart';

class Receiver {
  String? id;
  String? type;
  String? name;
  String? bankName;
  String? bankCardNo;
  String? phone;

  String? nameEng;
  String? cityName;
  String? idCardNo;

  Receiver({
    this.id,
    this.type,
    this.name,
    this.bankName,
    this.bankCardNo,
    this.phone,
    this.nameEng,
    this.cityName,
    this.idCardNo,
  });
  static $fromJson(Map<String, dynamic> json) => _$ReceiverFromJson(json);

  factory Receiver.fromJson(Map<String, dynamic> json) =>
      _$ReceiverFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiverToJson(this);
}
