import 'package:json_annotation/json_annotation.dart';
import 'package:wechat_kit/src/model/api/wechat_api_resp.dart';

part 'wechat_access_token_resp.g.dart';

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class WechatAccessTokenResp extends WechatApiResp {
  WechatAccessTokenResp({
    int errcode,
    String errmsg,
    this.openid,
    this.scope,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  }) : super(errcode: errcode, errmsg: errmsg);

  factory WechatAccessTokenResp.fromJson(Map<dynamic, dynamic> json) =>
      _$WechatAccessTokenRespFromJson(json);

  final String openid;
  final String scope;
  final String accessToken;
  final String refreshToken;

  /// 单位：秒
  final int expiresIn;

  Map<dynamic, dynamic> toJson() => _$WechatAccessTokenRespToJson(this);
}
