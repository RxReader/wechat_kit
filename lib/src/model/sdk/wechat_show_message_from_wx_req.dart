import 'package:json_annotation/json_annotation.dart';
import 'package:wechat_kit/src/model/sdk/wechat_sdk_req.dart';

part 'wechat_show_message_from_wx_req.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class WechatShowMessageFromWXReq extends WechatSdkReq {
  const WechatShowMessageFromWXReq({
    required String openId,
    this.messageAction,
    this.messageExt,
    required this.lang,
    required this.country,
  }) : super(openId: openId);

  factory WechatShowMessageFromWXReq.fromJson(Map<String, dynamic> json) =>
      _$WechatShowMessageFromWXReqFromJson(json);

  final String? messageAction;
  final String? messageExt;
  final String lang;
  final String country;

  @override
  Map<String, dynamic> toJson() => _$WechatShowMessageFromWXReqToJson(this);
}
