import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'req.g.dart';

abstract class BaseReq {
  const BaseReq({
    required this.openId,
  });

  final String openId;

  Map<String, dynamic> toJson();

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}

@JsonSerializable(
  explicitToJson: true,
)
class LaunchFromWXReq extends BaseReq {
  const LaunchFromWXReq({
    required String openId,
    this.messageAction,
    this.messageExt,
    required this.lang,
    required this.country,
  }) : super(openId: openId);

  factory LaunchFromWXReq.fromJson(Map<String, dynamic> json) =>
      _$LaunchFromWXReqFromJson(json);

  final String? messageAction;
  final String? messageExt;
  final String lang;
  final String country;

  @override
  Map<String, dynamic> toJson() => _$LaunchFromWXReqToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
)
class ShowMessageFromWXReq extends BaseReq {
  const ShowMessageFromWXReq({
    required String openId,
    this.messageAction,
    this.messageExt,
    required this.lang,
    required this.country,
  }) : super(openId: openId);

  factory ShowMessageFromWXReq.fromJson(Map<String, dynamic> json) =>
      _$ShowMessageFromWXReqFromJson(json);

  final String? messageAction;
  final String? messageExt;
  final String lang;
  final String country;

  @override
  Map<String, dynamic> toJson() => _$ShowMessageFromWXReqToJson(this);
}
