import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'req.g.dart';

abstract class WechatReq {
  const WechatReq();

  Map<String, dynamic> toJson();

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}

@JsonSerializable()
class WechatLaunchFromWXReq extends WechatReq {
  const WechatLaunchFromWXReq({
    this.messageAction,
    this.messageExt,
    required this.lang,
    required this.country,
  });

  factory WechatLaunchFromWXReq.fromJson(Map<String, dynamic> json) =>
      _$WechatLaunchFromWXReqFromJson(json);

  final String? messageAction;
  final String? messageExt;
  final String lang;
  final String country;

  @override
  Map<String, dynamic> toJson() => _$WechatLaunchFromWXReqToJson(this);
}

@JsonSerializable()
class WechatShowMessageFromWXReq extends WechatReq {
  const WechatShowMessageFromWXReq({
    this.messageAction,
    this.messageExt,
    required this.lang,
    required this.country,
  });

  factory WechatShowMessageFromWXReq.fromJson(Map<String, dynamic> json) =>
      _$WechatShowMessageFromWXReqFromJson(json);

  final String? messageAction;
  final String? messageExt;
  final String lang;
  final String country;

  @override
  Map<String, dynamic> toJson() => _$WechatShowMessageFromWXReqToJson(this);
}
