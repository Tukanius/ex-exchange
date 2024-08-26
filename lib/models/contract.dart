part '../parts/contract.dart';

class Contract {
  String? name;
  String? description;

  Contract({
    this.name,
    this.description,
  });
  static $fromJson(Map<String, dynamic> json) => _$ContractFromJson(json);

  factory Contract.fromJson(Map<String, dynamic> json) =>
      _$ContractFromJson(json);
  Map<String, dynamic> toJson() => _$ContractToJson(this);
}
