// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_launch_from_wx_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WechatLaunchFromWXReq _$WechatLaunchFromWXReqFromJson(
    Map<String, dynamic> json) {
  return WechatLaunchFromWXReq(
    openId: json['openId'] as String,
    messageAction: json['messageAction'] as String?,
    messageExt: json['messageExt'] as String?,
    lang: json['lang'] as String,
    country: json['country'] as String,
  );
}

Map<String, dynamic> _$WechatLaunchFromWXReqToJson(
        WechatLaunchFromWXReq instance) =>
    <String, dynamic>{
      'openId': instance.openId,
      'messageAction': instance.messageAction,
      'messageExt': instance.messageExt,
      'lang': instance.lang,
      'country': instance.country,
    };
