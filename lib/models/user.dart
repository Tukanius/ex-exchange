part '../parts/user.dart';

class User {
  String? username;
  String? password;
  String? token;
  String? tokenType;
  String? accessToken;
  String? sessionState;
  String? sessionScope;
  String? id;
  String? type;
  String? phone;
  String? firstName;
  String? lastName;
  String? registerNo;
  String? email;
  String? userStatus;
  String? userStatusDate;
  String? createdAt;
  String? updatedAt;
  String? sessionId;
  String? otpCode;
  String? otpMethod;
  String? message;
  bool? contract;
  String? deviceToken;
  User({
    this.username,
    this.password,
    this.token,
    this.tokenType,
    this.accessToken,
    this.sessionState,
    this.sessionScope,
    this.id,
    this.type,
    this.phone,
    this.firstName,
    this.lastName,
    this.registerNo,
    this.email,
    this.userStatus,
    this.userStatusDate,
    this.createdAt,
    this.updatedAt,
    this.sessionId,
    this.otpCode,
    this.otpMethod,
    this.message,
    this.contract,
    this.deviceToken,
  });

  static $fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
