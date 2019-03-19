import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:fake_wechat/src/domain/sdk/wechat_sdk_resp.dart';

part 'wechat_launch_mini_program_resp.jser.dart';

@GenSerializer()
class WechatLaunchMiniProgramRespSerializer
    extends Serializer<WechatLaunchMiniProgramResp>
    with _$WechatLaunchMiniProgramRespSerializer {}

class WechatLaunchMiniProgramResp extends WechatSdkResp {
  WechatLaunchMiniProgramResp({
    int errorCode,
    String errorMsg,
    this.extMsg,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);

  final String extMsg;
}
