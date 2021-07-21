import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'wechat_sdk_req.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class WechatSdkReq {
  const WechatSdkReq({
    required this.openId,
  });

  factory WechatSdkReq.fromJson(Map<String, dynamic> json) =>
      _$WechatSdkReqFromJson(json);

  final String openId;

  Map<String, dynamic> toJson() => _$WechatSdkReqToJson(this);

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}
