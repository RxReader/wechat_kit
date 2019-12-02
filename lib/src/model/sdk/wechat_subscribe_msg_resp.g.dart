// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_subscribe_msg_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WechatSubscribeMsgResp _$WechatSubscribeMsgRespFromJson(Map json) {
  return WechatSubscribeMsgResp(
    errorCode: json['errorCode'] as int ?? 0,
    errorMsg: json['errorMsg'] as String,
    templateId: json['templateId'] as String,
    scene: json['scene'] as int,
    action: json['action'] as String,
    reserved: json['reserved'] as String,
    openId: json['openId'] as String,
  );
}

Map<String, dynamic> _$WechatSubscribeMsgRespToJson(
        WechatSubscribeMsgResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'templateId': instance.templateId,
      'scene': instance.scene,
      'action': instance.action,
      'reserved': instance.reserved,
      'openId': instance.openId,
    };
