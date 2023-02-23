// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WechatLaunchFromWXReq _$WechatLaunchFromWXReqFromJson(
        Map<String, dynamic> json) =>
    WechatLaunchFromWXReq(
      messageAction: json['messageAction'] as String?,
      messageExt: json['messageExt'] as String?,
      lang: json['lang'] as String,
      country: json['country'] as String,
    );

Map<String, dynamic> _$WechatLaunchFromWXReqToJson(
        WechatLaunchFromWXReq instance) =>
    <String, dynamic>{
      'messageAction': instance.messageAction,
      'messageExt': instance.messageExt,
      'lang': instance.lang,
      'country': instance.country,
    };

WechatShowMessageFromWXReq _$WechatShowMessageFromWXReqFromJson(
        Map<String, dynamic> json) =>
    WechatShowMessageFromWXReq(
      messageAction: json['messageAction'] as String?,
      messageExt: json['messageExt'] as String?,
      lang: json['lang'] as String,
      country: json['country'] as String,
    );

Map<String, dynamic> _$WechatShowMessageFromWXReqToJson(
        WechatShowMessageFromWXReq instance) =>
    <String, dynamic>{
      'messageAction': instance.messageAction,
      'messageExt': instance.messageExt,
      'lang': instance.lang,
      'country': instance.country,
    };
