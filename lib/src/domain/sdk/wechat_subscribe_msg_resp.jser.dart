// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_subscribe_msg_resp.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$WechatSubscribeMsgRespSerializer
    implements Serializer<WechatSubscribeMsgResp> {
  @override
  Map<String, dynamic> toMap(WechatSubscribeMsgResp model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'templateId', model.templateId);
    setMapValue(ret, 'scene', model.scene);
    setMapValue(ret, 'action', model.action);
    setMapValue(ret, 'reserved', model.reserved);
    setMapValue(ret, 'openId', model.openId);
    setMapValue(ret, 'errorCode', model.errorCode);
    setMapValue(ret, 'errorMsg', model.errorMsg);
    return ret;
  }

  @override
  WechatSubscribeMsgResp fromMap(Map map) {
    if (map == null) return null;
    final obj = new WechatSubscribeMsgResp(
        errorCode: map['errorCode'] as int ?? getJserDefault('errorCode'),
        errorMsg: map['errorMsg'] as String ?? getJserDefault('errorMsg'),
        templateId: map['templateId'] as String ?? getJserDefault('templateId'),
        scene: map['scene'] as int ?? getJserDefault('scene'),
        action: map['action'] as String ?? getJserDefault('action'),
        reserved: map['reserved'] as String ?? getJserDefault('reserved'),
        openId: map['openId'] as String ?? getJserDefault('openId'));
    return obj;
  }
}
