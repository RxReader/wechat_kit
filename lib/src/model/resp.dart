import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'resp.g.dart';

abstract class BaseResp {
  const BaseResp({
    required this.errorCode,
    this.errorMsg,
  });

  /// 成功
  static const int ERRORCODE_SUCCESS = 0;

  /// 普通错误类型
  static const int ERRORCODE_COMMON = -1;

  /// 用户点击取消并返回
  static const int ERRORCODE_USERCANCEL = -2;

  /// 发送失败
  static const int ERRORCODE_SENTFAIL = -3;

  /// 授权失败
  static const int ERRORCODE_AUTHDENY = -4;

  /// 微信不支持
  static const int ERRORCODE_UNSUPPORT = -5;

  /// 错误码
  @JsonKey(defaultValue: ERRORCODE_SUCCESS)
  final int errorCode;

  /// 错误提示字符串
  final String? errorMsg;

  bool get isSuccessful => errorCode == ERRORCODE_SUCCESS;

  bool get isCancelled => errorCode == ERRORCODE_USERCANCEL;

  Map<String, dynamic> toJson();

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}

@JsonSerializable()
class AuthResp extends BaseResp {
  const AuthResp({
    required super.errorCode,
    super.errorMsg,
    this.code,
    this.state,
    this.lang,
    this.country,
  });

  factory AuthResp.fromJson(Map<String, dynamic> json) =>
      _$AuthRespFromJson(json);

  final String? code;
  final String? state;
  final String? lang;
  final String? country;

  @override
  Map<String, dynamic> toJson() => _$AuthRespToJson(this);
}

@JsonSerializable()
class OpenUrlResp extends BaseResp {
  const OpenUrlResp({
    required super.errorCode,
    super.errorMsg,
  });

  factory OpenUrlResp.fromJson(Map<String, dynamic> json) =>
      _$OpenUrlRespFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OpenUrlRespToJson(this);
}

@JsonSerializable()
class ShareMsgResp extends BaseResp {
  const ShareMsgResp({
    required super.errorCode,
    super.errorMsg,
  });

  factory ShareMsgResp.fromJson(Map<String, dynamic> json) =>
      _$ShareMsgRespFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ShareMsgRespToJson(this);
}

@JsonSerializable()
class SubscribeMsgResp extends BaseResp {
  const SubscribeMsgResp({
    required super.errorCode,
    super.errorMsg,
    this.templateId,
    this.scene,
    this.action,
    this.reserved,
  });

  factory SubscribeMsgResp.fromJson(Map<String, dynamic> json) =>
      _$SubscribeMsgRespFromJson(json);

  final String? templateId;
  final int? scene;
  final String? action;
  final String? reserved;

  @override
  Map<String, dynamic> toJson() => _$SubscribeMsgRespToJson(this);
}

@JsonSerializable()
class LaunchMiniProgramResp extends BaseResp {
  const LaunchMiniProgramResp({
    required super.errorCode,
    super.errorMsg,
    this.extMsg,
  });

  factory LaunchMiniProgramResp.fromJson(Map<String, dynamic> json) =>
      _$LaunchMiniProgramRespFromJson(json);

  final String? extMsg;

  @override
  Map<String, dynamic> toJson() => _$LaunchMiniProgramRespToJson(this);
}

@JsonSerializable()
class OpenCustomerServiceChatResp extends BaseResp {
  const OpenCustomerServiceChatResp({
    required super.errorCode,
    super.errorMsg,
  });

  factory OpenCustomerServiceChatResp.fromJson(Map<String, dynamic> json) =>
      _$OpenCustomerServiceChatRespFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OpenCustomerServiceChatRespToJson(this);
}

@JsonSerializable()
class OpenBusinessViewResp extends BaseResp {
  const OpenBusinessViewResp({
    required super.errorCode,
    super.errorMsg,
    required this.businessType,
    this.extMsg,
  });

  factory OpenBusinessViewResp.fromJson(Map<String, dynamic> json) =>
      _$OpenBusinessViewRespFromJson(json);

  final String businessType;
  final String? extMsg;

  @override
  Map<String, dynamic> toJson() => _$OpenBusinessViewRespToJson(this);
}

@JsonSerializable()
class OpenBusinessWebviewResp extends BaseResp {
  const OpenBusinessWebviewResp({
    required super.errorCode,
    super.errorMsg,
    required this.businessType,
    this.resultInfo,
  });

  factory OpenBusinessWebviewResp.fromJson(Map<String, dynamic> json) =>
      _$OpenBusinessWebviewRespFromJson(json);

  final int businessType;
  final String? resultInfo;

  @override
  Map<String, dynamic> toJson() => _$OpenBusinessWebviewRespToJson(this);
}

@JsonSerializable()
class PayResp extends BaseResp {
  const PayResp({
    required super.errorCode,
    super.errorMsg,
    this.returnKey,
  });

  factory PayResp.fromJson(Map<String, dynamic> json) =>
      _$PayRespFromJson(json);

  final String? returnKey;

  @override
  Map<String, dynamic> toJson() => _$PayRespToJson(this);
}
