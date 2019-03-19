import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:fake_wechat/src/domain/sdk/wechat_sdk_resp.dart';

part 'wechat_auth_resp.jser.dart';

@GenSerializer()
class WechatAuthRespSerializer extends Serializer<WechatAuthResp>
    with _$WechatAuthRespSerializer {}

class WechatAuthResp extends WechatSdkResp {
  WechatAuthResp({
    int errorCode,
    String errorMsg,
    this.code,
    this.state,
    this.lang,
    this.country,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);

  final String code;
  final String state;
  final String lang;
  final String country;
}
