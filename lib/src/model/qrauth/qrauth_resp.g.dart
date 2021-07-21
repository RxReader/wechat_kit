// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qrauth_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QrauthResp _$QrauthRespFromJson(Map<String, dynamic> json) {
  return QrauthResp(
    errorCode: json['errorCode'] as int? ?? 0,
    authCode: json['authCode'] as String?,
  );
}

Map<String, dynamic> _$QrauthRespToJson(QrauthResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'authCode': instance.authCode,
    };
