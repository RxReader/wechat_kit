// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_ticket_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WechatTicketResp _$WechatTicketRespFromJson(Map json) {
  return WechatTicketResp(
    errcode: json['errcode'] as int ?? 0,
    errmsg: json['errmsg'] as String,
    ticket: json['ticket'] as String,
    expiresIn: json['expires_in'] as int,
  );
}

Map<String, dynamic> _$WechatTicketRespToJson(WechatTicketResp instance) =>
    <String, dynamic>{
      'errcode': instance.errcode,
      'errmsg': instance.errmsg,
      'ticket': instance.ticket,
      'expires_in': instance.expiresIn,
    };
