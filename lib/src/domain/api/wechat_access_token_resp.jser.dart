// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_access_token_resp.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$WechatAccessTokenRespSerializer
    implements Serializer<WechatAccessTokenResp> {
  @override
  Map<String, dynamic> toMap(WechatAccessTokenResp model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'openid', model.openid);
    setMapValue(ret, 'scope', model.scope);
    setMapValue(ret, 'access_token', model.accessToken);
    setMapValue(ret, 'refresh_token', model.refreshToken);
    setMapValue(ret, 'expires_in', model.expiresIn);
    setMapValue(ret, 'errcode', model.errcode);
    setMapValue(ret, 'errmsg', model.errmsg);
    return ret;
  }

  @override
  WechatAccessTokenResp fromMap(Map map) {
    if (map == null) return null;
    final obj = new WechatAccessTokenResp(
        errcode: map['errcode'] as int ?? getJserDefault('errcode'),
        errmsg: map['errmsg'] as String ?? getJserDefault('errmsg'),
        openid: map['openid'] as String ?? getJserDefault('openid'),
        scope: map['scope'] as String ?? getJserDefault('scope'),
        accessToken:
            map['access_token'] as String ?? getJserDefault('accessToken'),
        refreshToken:
            map['refresh_token'] as String ?? getJserDefault('refreshToken'),
        expiresIn: map['expires_in'] as int ?? getJserDefault('expiresIn'));
    return obj;
  }
}
