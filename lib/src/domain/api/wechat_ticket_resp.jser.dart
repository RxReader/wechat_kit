// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_ticket_resp.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$WechatTicketRespSerializer
    implements Serializer<WechatTicketResp> {
  @override
  Map<String, dynamic> toMap(WechatTicketResp model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'ticket', model.ticket);
    setMapValue(ret, 'expires_in', model.expiresIn);
    setMapValue(ret, 'errcode', model.errcode);
    setMapValue(ret, 'errmsg', model.errmsg);
    return ret;
  }

  @override
  WechatTicketResp fromMap(Map map) {
    if (map == null) return null;
    final obj = new WechatTicketResp(
        errcode: map['errcode'] as int ?? getJserDefault('errcode'),
        errmsg: map['errmsg'] as String ?? getJserDefault('errmsg'));
    obj.ticket = map['ticket'] as String;
    obj.expiresIn = map['expires_in'] as int;
    return obj;
  }
}
