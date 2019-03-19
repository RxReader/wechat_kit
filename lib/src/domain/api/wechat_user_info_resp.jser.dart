// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_user_info_resp.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$WechatUserInfoRespSerializer
    implements Serializer<WechatUserInfoResp> {
  @override
  Map<String, dynamic> toMap(WechatUserInfoResp model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'openid', model.openid);
    setMapValue(ret, 'nickname', model.nickname);
    setMapValue(ret, 'sex', model.sex);
    setMapValue(ret, 'province', model.province);
    setMapValue(ret, 'city', model.city);
    setMapValue(ret, 'country', model.country);
    setMapValue(ret, 'headimgurl', model.headimgurl);
    setMapValue(ret, 'privilege',
        codeIterable(model.privilege, (val) => passProcessor.serialize(val)));
    setMapValue(ret, 'unionid', model.unionid);
    setMapValue(ret, 'errcode', model.errcode);
    setMapValue(ret, 'errmsg', model.errmsg);
    return ret;
  }

  @override
  WechatUserInfoResp fromMap(Map map) {
    if (map == null) return null;
    final obj = new WechatUserInfoResp(
        errcode: map['errcode'] as int ?? getJserDefault('errcode'),
        errmsg: map['errmsg'] as String ?? getJserDefault('errmsg'),
        openid: map['openid'] as String ?? getJserDefault('openid'),
        nickname: map['nickname'] as String ?? getJserDefault('nickname'),
        sex: map['sex'] as int ?? getJserDefault('sex'),
        province: map['province'] as String ?? getJserDefault('province'),
        city: map['city'] as String ?? getJserDefault('city'),
        country: map['country'] as String ?? getJserDefault('country'),
        headimgurl: map['headimgurl'] as String ?? getJserDefault('headimgurl'),
        privilege: codeIterable<dynamic>(map['privilege'] as Iterable,
                (val) => passProcessor.deserialize(val)) ??
            getJserDefault('privilege'),
        unionid: map['unionid'] as String ?? getJserDefault('unionid'));
    return obj;
  }
}
