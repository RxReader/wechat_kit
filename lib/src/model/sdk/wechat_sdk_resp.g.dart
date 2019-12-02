// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_sdk_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WechatSdkResp _$WechatSdkRespFromJson(Map json) {
  return WechatSdkResp(
    errorCode: json['errorCode'] as int ?? 0,
    errorMsg: json['errorMsg'] as String,
  );
}

Map<String, dynamic> _$WechatSdkRespToJson(WechatSdkResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
    };
