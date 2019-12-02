// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_user_info_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WechatUserInfoResp _$WechatUserInfoRespFromJson(Map json) {
  return WechatUserInfoResp(
    errcode: json['errcode'] as int ?? 0,
    errmsg: json['errmsg'] as String,
    openid: json['openid'] as String,
    nickname: json['nickname'] as String,
    sex: json['sex'] as int,
    province: json['province'] as String,
    city: json['city'] as String,
    country: json['country'] as String,
    headimgurl: json['headimgurl'] as String,
    privilege: json['privilege'] as List,
    unionid: json['unionid'] as String,
  );
}

Map<String, dynamic> _$WechatUserInfoRespToJson(WechatUserInfoResp instance) =>
    <String, dynamic>{
      'errcode': instance.errcode,
      'errmsg': instance.errmsg,
      'openid': instance.openid,
      'nickname': instance.nickname,
      'sex': instance.sex,
      'province': instance.province,
      'city': instance.city,
      'country': instance.country,
      'headimgurl': instance.headimgurl,
      'privilege': instance.privilege,
      'unionid': instance.unionid,
    };
