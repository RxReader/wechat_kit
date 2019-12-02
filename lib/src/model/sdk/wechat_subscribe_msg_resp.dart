import 'package:json_annotation/json_annotation.dart';
import 'package:wechat_kit/src/model/sdk/wechat_sdk_resp.dart';

part 'wechat_subscribe_msg_resp.g.dart';

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
)
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

  factory WechatSubscribeMsgResp.fromJson(Map<dynamic, dynamic> json) =>
      _$WechatSubscribeMsgRespFromJson(json);

  final String templateId;
  final int scene;
  final String action;
  final String reserved;
  final String openId;

  @override
  Map<dynamic, dynamic> toJson() => _$WechatSubscribeMsgRespToJson(this);
}
