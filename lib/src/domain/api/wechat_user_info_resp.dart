import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:fake_wechat/src/domain/api/wechat_api_resp.dart';

part 'wechat_user_info_resp.jser.dart';

@GenSerializer(nameFormatter: toSnakeCase)
class WechatUserInfoRespSerializer extends Serializer<WechatUserInfoResp> with _$WechatUserInfoRespSerializer{}

class WechatUserInfoResp extends WechatApiResp {
  WechatUserInfoResp({
    int errcode,
    String errmsg,
    this.openid,
    this.nickname,
    this.sex,
    this.province,
    this.city,
    this.country,
    this.headimgurl,
    this.privilege,
    this.unionid,
  }) : super(errcode: errcode, errmsg: errmsg);

  final String openid;
  final String nickname;

  /// 1为男性，2为女性
  final int sex;
  final String province;
  final String city;
  final String country;
  final String headimgurl;
  final List<dynamic> privilege;
  final String unionid;

  bool isMale() {
    return sex == 1;
  }

  bool isFemale() {
    return sex == 2;
  }
}
