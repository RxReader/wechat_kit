// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_show_message_from_wx_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WechatShowMessageFromWXReq _$WechatShowMessageFromWXReqFromJson(
    Map<String, dynamic> json) {
  return WechatShowMessageFromWXReq(
    openId: json['openId'] as String,
    messageAction: json['messageAction'] as String?,
    messageExt: json['messageExt'] as String?,
    lang: json['lang'] as String,
    country: json['country'] as String,
  );
}

Map<String, dynamic> _$WechatShowMessageFromWXReqToJson(
        WechatShowMessageFromWXReq instance) =>
    <String, dynamic>{
      'openId': instance.openId,
      'messageAction': instance.messageAction,
      'messageExt': instance.messageExt,
      'lang': instance.lang,
      'country': instance.country,
    };
