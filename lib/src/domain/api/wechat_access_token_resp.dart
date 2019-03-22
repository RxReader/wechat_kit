import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:fake_wechat/src/domain/api/wechat_api_resp.dart';

part 'wechat_access_token_resp.jser.dart';

@GenSerializer(nameFormatter: toSnakeCase)
class WechatAccessTokenRespSerializer extends Serializer<WechatAccessTokenResp>
    with _$WechatAccessTokenRespSerializer {}

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

  final String openid;
  final String scope;
  final String accessToken;
  final String refreshToken;

  /// 单位：秒
  final int expiresIn;
}
