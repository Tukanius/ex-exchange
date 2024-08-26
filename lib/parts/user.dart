part of '../models/user.dart';

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      username: json['username'] != null ? json['username'] as String : null,
      password: json['password'] != null ? json['password'] as String : null,
      accessToken:
          json['accessToken'] != null ? json['accessToken'] as String : null,
      sessionScope:
          json['sessionScope'] != null ? json['sessionScope'] as String : null,
      sessionState:
          json['sessionState'] != null ? json['sessionState'] as String : null,
      token: json['token'] != null ? json['token'] as String : null,
      tokenType: json['tokenType'] != null ? json['tokenType'] as String : null,
      createdAt: json['createdAt'] != null ? json['createdAt'] as String : null,
      email: json['email'] != null ? json['email'] as String : null,
      firstName: json['firstName'] != null ? json['firstName'] as String : null,
      id: json['_id'] != null ? json['_id'] as String : null,
      lastName: json['lastName'] != null ? json['lastName'] as String : null,
      phone: json['phone'] != null ? json['phone'] as String : null,
      registerNo:
          json['registerNo'] != null ? json['registerNo'] as String : null,
      sessionId: json['sessionId'] != null ? json['sessionId'] as String : null,
      type: json['type'] != null ? json['type'] as String : null,
      updatedAt: json['updatedAt'] != null ? json['updatedAt'] as String : null,
      userStatus:
          json['userStatus'] != null ? json['userStatus'] as String : null,
      userStatusDate: json['userStatusDate'] != null
          ? json['userStatusDate'] as String
          : null,
      otpCode: json['otpCode'] != null ? json['otpCode'] as String : null,
      otpMethod: json['otpMethod'] != null ? json['otpMethod'] as String : null,
      message: json['message'] != null ? json['message'] as String : null,
      contract: json['contract'] != null ? json['contract'] as bool : null,
      deviceToken:
          json['deviceToken'] != null ? json['deviceToken'] as String : null,
      oldPassword:
          json['oldPassword'] != null ? json['oldPassword'] as String : null);
}

Map<String, dynamic> _$UserToJson(User instance) {
  Map<String, dynamic> json = {};
  if (instance.id != null) json['_id'] = instance.id;
  if (instance.username != null) json['username'] = instance.username;
  if (instance.password != null) json['password'] = instance.password;
  if (instance.accessToken != null) json['accessToken'] = instance.accessToken;
  if (instance.sessionScope != null)
    json['sessionScope'] = instance.sessionScope;
  if (instance.sessionState != null)
    json['sessionState'] = instance.sessionState;
  if (instance.token != null) json['token'] = instance.token;
  if (instance.tokenType != null) json['tokenType'] = instance.tokenType;
  if (instance.createdAt != null) json['createdAt'] = instance.createdAt;
  if (instance.email != null) json['email'] = instance.email;
  if (instance.lastName != null) json['lastName'] = instance.lastName;
  if (instance.firstName != null) json['firstName'] = instance.firstName;
  if (instance.phone != null) json['phone'] = instance.phone;
  if (instance.registerNo != null) json['registerNo'] = instance.registerNo;
  if (instance.sessionId != null) json['sessionId'] = instance.sessionId;
  if (instance.type != null) json['type'] = instance.type;
  if (instance.updatedAt != null) json['updatedAt'] = instance.updatedAt;
  if (instance.userStatus != null) json['userStatus'] = instance.userStatus;
  if (instance.userStatusDate != null)
    json['userStatusDate'] = instance.userStatusDate;
  if (instance.otpCode != null) json['otpCode'] = instance.otpCode;
  if (instance.otpMethod != null) json['otpMethod'] = instance.otpMethod;
  if (instance.message != null) json['message'] = instance.message;
  if (instance.contract != null) json['contract'] = instance.contract;
  if (instance.deviceToken != null) json['deviceToken'] = instance.deviceToken;
  if (instance.oldPassword != null) json['oldPassword'] = instance.oldPassword;

  return json;
}
