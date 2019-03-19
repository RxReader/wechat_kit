// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_pay_resp.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$WechatPayRespSerializer implements Serializer<WechatPayResp> {
  @override
  Map<String, dynamic> toMap(WechatPayResp model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'returnKey', model.returnKey);
    setMapValue(ret, 'errorCode', model.errorCode);
    setMapValue(ret, 'errorMsg', model.errorMsg);
    return ret;
  }

  @override
  WechatPayResp fromMap(Map map) {
    if (map == null) return null;
    final obj = new WechatPayResp(
        errorCode: map['errorCode'] as int ?? getJserDefault('errorCode'),
        errorMsg: map['errorMsg'] as String ?? getJserDefault('errorMsg'),
        returnKey: map['returnKey'] as String ?? getJserDefault('returnKey'));
    return obj;
  }
}
