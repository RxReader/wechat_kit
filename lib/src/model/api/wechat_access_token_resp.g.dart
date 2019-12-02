// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_access_token_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WechatAccessTokenResp _$WechatAccessTokenRespFromJson(Map json) {
  return WechatAccessTokenResp(
    errcode: json['errcode'] as int ?? 0,
    errmsg: json['errmsg'] as String,
    openid: json['openid'] as String,
    scope: json['scope'] as String,
    accessToken: json['access_token'] as String,
    refreshToken: json['refresh_token'] as String,
    expiresIn: json['expires_in'] as int,
  );
}

Map<String, dynamic> _$WechatAccessTokenRespToJson(
        WechatAccessTokenResp instance) =>
    <String, dynamic>{
      'errcode': instance.errcode,
      'errmsg': instance.errmsg,
      'openid': instance.openid,
      'scope': instance.scope,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expires_in': instance.expiresIn,
    };
