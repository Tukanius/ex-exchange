part '../../parts/general_parts/transaction_status.dart';

class TransactionStatus {
  String? code;
  String? name;

  TransactionStatus({
    this.code,
    this.name,
  });
  static $fromJson(Map<String, dynamic> json) =>
      _$TransactionStatusFromJson(json);

  factory TransactionStatus.fromJson(Map<String, dynamic> json) =>
      _$TransactionStatusFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionStatusToJson(this);
}
