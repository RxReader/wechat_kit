import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:fake_wechat/src/domain/sdk/wechat_sdk_resp.dart';

part 'wechat_pay_resp.jser.dart';

@GenSerializer()
class WechatPayRespSerializer extends Serializer<WechatPayResp>
    with _$WechatPayRespSerializer {}

class WechatPayResp extends WechatSdkResp {
  WechatPayResp({
    int errorCode,
    String errorMsg,
    this.returnKey,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);

  final String returnKey;
}
