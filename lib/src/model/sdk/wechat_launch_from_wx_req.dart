import 'package:json_annotation/json_annotation.dart';
import 'package:wechat_kit/src/model/sdk/wechat_sdk_req.dart';

part 'wechat_launch_from_wx_req.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class WechatLaunchFromWXReq extends WechatSdkReq {
  const WechatLaunchFromWXReq({
    required String openId,
    this.messageAction,
    this.messageExt,
    required this.lang,
    required this.country,
  }) : super(openId: openId);

  factory WechatLaunchFromWXReq.fromJson(Map<String, dynamic> json) =>
      _$WechatLaunchFromWXReqFromJson(json);

  final String? messageAction;
  final String? messageExt;
  final String lang;
  final String country;

  @override
  Map<String, dynamic> toJson() => _$WechatLaunchFromWXReqToJson(this);
}
