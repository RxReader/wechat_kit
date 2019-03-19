// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_sdk_resp.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$WechatSdkRespSerializer implements Serializer<WechatSdkResp> {
  @override
  Map<String, dynamic> toMap(WechatSdkResp model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'errorCode', model.errorCode);
    setMapValue(ret, 'errorMsg', model.errorMsg);
    return ret;
  }

  @override
  WechatSdkResp fromMap(Map map) {
    if (map == null) return null;
    final obj = new WechatSdkResp(
        errorCode: map['errorCode'] as int ?? getJserDefault('errorCode'),
        errorMsg: map['errorMsg'] as String ?? getJserDefault('errorMsg'));
    return obj;
  }
}
