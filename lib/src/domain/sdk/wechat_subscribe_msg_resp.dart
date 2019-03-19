import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:fake_wechat/src/domain/sdk/wechat_sdk_resp.dart';

part 'wechat_subscribe_msg_resp.jser.dart';

@GenSerializer()
class WechatSubscribeMsgRespSerializer
    extends Serializer<WechatSubscribeMsgResp>
    with _$WechatSubscribeMsgRespSerializer {}

class WechatSubscribeMsgResp extends WechatSdkResp {
  WechatSubscribeMsgResp({
    int errorCode,
    String errorMsg,
    this.templateId,
    this.scene,
    this.action,
    this.reserved,
    this.openId,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);

  final String templateId;
  final int scene;
  final String action;
  final String reserved;
  final String openId;
}
