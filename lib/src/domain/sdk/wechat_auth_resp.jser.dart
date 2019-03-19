// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_auth_resp.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$WechatAuthRespSerializer
    implements Serializer<WechatAuthResp> {
  @override
  Map<String, dynamic> toMap(WechatAuthResp model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'code', model.code);
    setMapValue(ret, 'state', model.state);
    setMapValue(ret, 'lang', model.lang);
    setMapValue(ret, 'country', model.country);
    setMapValue(ret, 'errorCode', model.errorCode);
    setMapValue(ret, 'errorMsg', model.errorMsg);
    return ret;
  }

  @override
  WechatAuthResp fromMap(Map map) {
    if (map == null) return null;
    final obj = new WechatAuthResp(
        errorCode: map['errorCode'] as int ?? getJserDefault('errorCode'),
        errorMsg: map['errorMsg'] as String ?? getJserDefault('errorMsg'),
        code: map['code'] as String ?? getJserDefault('code'),
        state: map['state'] as String ?? getJserDefault('state'),
        lang: map['lang'] as String ?? getJserDefault('lang'),
        country: map['country'] as String ?? getJserDefault('country'));
    return obj;
  }
}
