import 'package:json_annotation/json_annotation.dart';
import 'package:wechat_kit/src/model/sdk/wechat_sdk_resp.dart';

part 'wechat_launch_mini_program_resp.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class WechatLaunchMiniProgramResp extends WechatSdkResp {
  const WechatLaunchMiniProgramResp({
    required int errorCode,
    String? errorMsg,
    this.extMsg,
  }) : super(
          errorCode: errorCode,
          errorMsg: errorMsg,
        );

  factory WechatLaunchMiniProgramResp.fromJson(Map<String, dynamic> json) =>
      _$WechatLaunchMiniProgramRespFromJson(json);

  final String? extMsg;

  @override
  Map<String, dynamic> toJson() => _$WechatLaunchMiniProgramRespToJson(this);
}
