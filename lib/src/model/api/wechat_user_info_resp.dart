import 'package:json_annotation/json_annotation.dart';
import 'package:wechat_kit/src/model/api/wechat_api_resp.dart';

part 'wechat_user_info_resp.g.dart';

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
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

  factory WechatUserInfoResp.fromJson(Map<dynamic, dynamic> json) =>
      _$WechatUserInfoRespFromJson(json);

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

  Map<dynamic, dynamic> toJson() => _$WechatUserInfoRespToJson(this);
}
