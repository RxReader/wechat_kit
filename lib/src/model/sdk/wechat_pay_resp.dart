import 'package:json_annotation/json_annotation.dart';
import 'package:wechat_kit/src/model/sdk/wechat_sdk_resp.dart';

part 'wechat_pay_resp.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class WechatPayResp extends WechatSdkResp {
  const WechatPayResp({
    required int errorCode,
    String? errorMsg,
    this.returnKey,
  }) : super(
          errorCode: errorCode,
          errorMsg: errorMsg,
        );

  factory WechatPayResp.fromJson(Map<String, dynamic> json) =>
      _$WechatPayRespFromJson(json);

  final String? returnKey;

  @override
  Map<String, dynamic> toJson() => _$WechatPayRespToJson(this);
}
