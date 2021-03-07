import 'package:json_annotation/json_annotation.dart';
import 'package:wechat_kit/src/model/api/wechat_api_resp.dart';

part 'wechat_user_info_resp.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class WechatUserInfoResp extends WechatApiResp {
  const WechatUserInfoResp({
    required int errcode,
    String? errmsg,
    this.openid,
    this.nickname,
    this.sex,
    this.province,
    this.city,
    this.country,
    this.headimgurl,
    this.privilege,
    this.unionid,
  }) : super(
          errcode: errcode,
          errmsg: errmsg,
        );

  factory WechatUserInfoResp.fromJson(Map<String, dynamic> json) =>
      _$WechatUserInfoRespFromJson(json);

  final String? openid;
  final String? nickname;
  final int? sex; // 1为男性，2为女性
  final String? province;
  final String? city;
  final String? country;
  final String? headimgurl;
  final List<dynamic>? privilege;
  final String? unionid;

  bool get isMale => sex == 1;

  bool get isFemale => sex == 2;

  @override
  Map<String, dynamic> toJson() => _$WechatUserInfoRespToJson(this);
}
