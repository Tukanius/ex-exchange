part '../parts/receiver.dart';

class Receiver {
  String? id;
  String? type;
  String? accountName;
  String? bankName;
  String? accountNumber;
  String? phone;
  String? branchName;
  String? branchAddress;
  String? swiftCode;

  Receiver({
    this.id,
    this.type,
    this.accountName,
    this.bankName,
    this.accountNumber,
    this.phone,
    this.branchName,
    this.branchAddress,
    this.swiftCode,
  });
  static $fromJson(Map<String, dynamic> json) => _$ReceiverFromJson(json);

  factory Receiver.fromJson(Map<String, dynamic> json) =>
      _$ReceiverFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiverToJson(this);
}
