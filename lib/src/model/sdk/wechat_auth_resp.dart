import 'package:json_annotation/json_annotation.dart';

import 'package:wechat_kit/src/model/sdk/wechat_sdk_resp.dart';

part 'wechat_auth_resp.g.dart';

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
)
class WechatAuthResp extends WechatSdkResp {
  WechatAuthResp({
    int errorCode,
    String errorMsg,
    this.code,
    this.state,
    this.lang,
    this.country,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);

  factory WechatAuthResp.fromJson(Map<dynamic, dynamic> json) =>
      _$WechatAuthRespFromJson(json);

  final String code;
  final String state;
  final String lang;
  final String country;

  @override
  Map<dynamic, dynamic> toJson() => _$WechatAuthRespToJson(this);
}
