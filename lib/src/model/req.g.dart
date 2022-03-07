// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaunchFromWXReq _$LaunchFromWXReqFromJson(Map<String, dynamic> json) =>
    LaunchFromWXReq(
      messageAction: json['messageAction'] as String?,
      messageExt: json['messageExt'] as String?,
      lang: json['lang'] as String,
      country: json['country'] as String,
    );

Map<String, dynamic> _$LaunchFromWXReqToJson(LaunchFromWXReq instance) =>
    <String, dynamic>{
      'messageAction': instance.messageAction,
      'messageExt': instance.messageExt,
      'lang': instance.lang,
      'country': instance.country,
    };

ShowMessageFromWXReq _$ShowMessageFromWXReqFromJson(
        Map<String, dynamic> json) =>
    ShowMessageFromWXReq(
      messageAction: json['messageAction'] as String?,
      messageExt: json['messageExt'] as String?,
      lang: json['lang'] as String,
      country: json['country'] as String,
    );

Map<String, dynamic> _$ShowMessageFromWXReqToJson(
        ShowMessageFromWXReq instance) =>
    <String, dynamic>{
      'messageAction': instance.messageAction,
      'messageExt': instance.messageExt,
      'lang': instance.lang,
      'country': instance.country,
    };
