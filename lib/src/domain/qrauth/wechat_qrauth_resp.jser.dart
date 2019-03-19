// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_qrauth_resp.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$WechatQrauthRespSerializer
    implements Serializer<WechatQrauthResp> {
  @override
  Map<String, dynamic> toMap(WechatQrauthResp model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'errorCode', model.errorCode);
    setMapValue(ret, 'authCode', model.authCode);
    return ret;
  }

  @override
  WechatQrauthResp fromMap(Map map) {
    if (map == null) return null;
    final obj = new WechatQrauthResp(
        errorCode: map['errorCode'] as int ?? getJserDefault('errorCode'),
        authCode: map['authCode'] as String ?? getJserDefault('authCode'));
    return obj;
  }
}
