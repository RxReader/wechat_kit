// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_qrauth_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WechatQrauthResp _$WechatQrauthRespFromJson(Map json) {
  return WechatQrauthResp(
    errorCode: json['errorCode'] as int ?? 0,
    authCode: json['authCode'] as String,
  );
}

Map<String, dynamic> _$WechatQrauthRespToJson(WechatQrauthResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'authCode': instance.authCode,
    };
