// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_pay_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WechatPayResp _$WechatPayRespFromJson(Map json) {
  return WechatPayResp(
    errorCode: json['errorCode'] as int ?? 0,
    errorMsg: json['errorMsg'] as String,
    returnKey: json['returnKey'] as String,
  );
}

Map<String, dynamic> _$WechatPayRespToJson(WechatPayResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'returnKey': instance.returnKey,
    };
