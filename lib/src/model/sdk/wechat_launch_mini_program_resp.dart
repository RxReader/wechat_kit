import 'package:json_annotation/json_annotation.dart';
import 'package:wechat_kit/src/model/sdk/wechat_sdk_resp.dart';

part 'wechat_launch_mini_program_resp.g.dart';

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
)
class WechatLaunchMiniProgramResp extends WechatSdkResp {
  WechatLaunchMiniProgramResp({
    int errorCode,
    String errorMsg,
    this.extMsg,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);

  factory WechatLaunchMiniProgramResp.fromJson(Map<dynamic, dynamic> json) =>
      _$WechatLaunchMiniProgramRespFromJson(json);

  final String extMsg;

  @override
  Map<dynamic, dynamic> toJson() => _$WechatLaunchMiniProgramRespToJson(this);
}
