import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'req.g.dart';

abstract class BaseReq {
  const BaseReq();

  Map<String, dynamic> toJson();

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}

@JsonSerializable()
class LaunchFromWXReq extends BaseReq {
  const LaunchFromWXReq({
    this.messageAction,
    this.messageExt,
    required this.lang,
    required this.country,
  });

  factory LaunchFromWXReq.fromJson(Map<String, dynamic> json) =>
      _$LaunchFromWXReqFromJson(json);

  final String? messageAction;
  final String? messageExt;
  final String lang;
  final String country;

  @override
  Map<String, dynamic> toJson() => _$LaunchFromWXReqToJson(this);
}

@JsonSerializable()
class ShowMessageFromWXReq extends BaseReq {
  const ShowMessageFromWXReq({
    this.messageAction,
    this.messageExt,
    required this.lang,
    required this.country,
  });

  factory ShowMessageFromWXReq.fromJson(Map<String, dynamic> json) =>
      _$ShowMessageFromWXReqFromJson(json);

  final String? messageAction;
  final String? messageExt;
  final String lang;
  final String country;

  @override
  Map<String, dynamic> toJson() => _$ShowMessageFromWXReqToJson(this);
}
