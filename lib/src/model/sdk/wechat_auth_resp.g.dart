// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_auth_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WechatAuthResp _$WechatAuthRespFromJson(Map json) {
  return WechatAuthResp(
    errorCode: json['errorCode'] as int ?? 0,
    errorMsg: json['errorMsg'] as String,
    code: json['code'] as String,
    state: json['state'] as String,
    lang: json['lang'] as String,
    country: json['country'] as String,
  );
}

Map<String, dynamic> _$WechatAuthRespToJson(WechatAuthResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'code': instance.code,
      'state': instance.state,
      'lang': instance.lang,
      'country': instance.country,
    };
