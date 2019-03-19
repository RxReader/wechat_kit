// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_launch_mini_program_resp.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$WechatLaunchMiniProgramRespSerializer
    implements Serializer<WechatLaunchMiniProgramResp> {
  @override
  Map<String, dynamic> toMap(WechatLaunchMiniProgramResp model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'extMsg', model.extMsg);
    setMapValue(ret, 'errorCode', model.errorCode);
    setMapValue(ret, 'errorMsg', model.errorMsg);
    return ret;
  }

  @override
  WechatLaunchMiniProgramResp fromMap(Map map) {
    if (map == null) return null;
    final obj = new WechatLaunchMiniProgramResp(
        errorCode: map['errorCode'] as int ?? getJserDefault('errorCode'),
        errorMsg: map['errorMsg'] as String ?? getJserDefault('errorMsg'),
        extMsg: map['extMsg'] as String ?? getJserDefault('extMsg'));
    return obj;
  }
}
