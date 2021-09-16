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
    required int errorCode,
    String? errorMsg,
    this.code,
    this.state,
    this.lang,
    this.country,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);

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
    required int errorCode,
    String? errorMsg,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);

  factory OpenUrlResp.fromJson(Map<String, dynamic> json) =>
      _$OpenUrlRespFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OpenUrlRespToJson(this);
}

@JsonSerializable()
class ShareMsgResp extends BaseResp {
  const ShareMsgResp({
    required int errorCode,
    String? errorMsg,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);

  factory ShareMsgResp.fromJson(Map<String, dynamic> json) =>
      _$ShareMsgRespFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ShareMsgRespToJson(this);
}

@JsonSerializable()
class SubscribeMsgResp extends BaseResp {
  const SubscribeMsgResp({
    required int errorCode,
    String? errorMsg,
    this.templateId,
    this.scene,
    this.action,
    this.reserved,
    this.openId,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);

  factory SubscribeMsgResp.fromJson(Map<String, dynamic> json) =>
      _$SubscribeMsgRespFromJson(json);

  final String? templateId;
  final int? scene;
  final String? action;
  final String? reserved;
  final String? openId;

  @override
  Map<String, dynamic> toJson() => _$SubscribeMsgRespToJson(this);
}

@JsonSerializable()
class LaunchMiniProgramResp extends BaseResp {
  const LaunchMiniProgramResp({
    required int errorCode,
    String? errorMsg,
    this.extMsg,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);

  factory LaunchMiniProgramResp.fromJson(Map<String, dynamic> json) =>
      _$LaunchMiniProgramRespFromJson(json);

  final String? extMsg;

  @override
  Map<String, dynamic> toJson() => _$LaunchMiniProgramRespToJson(this);
}

@JsonSerializable()
class OpenCustomerServiceChatResp extends BaseResp {
  const OpenCustomerServiceChatResp({
    required int errorCode,
    String? errorMsg,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);

  factory OpenCustomerServiceChatResp.fromJson(Map<String, dynamic> json) =>
      _$OpenCustomerServiceChatRespFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OpenCustomerServiceChatRespToJson(this);
}

@JsonSerializable()
class OpenBusinessViewResp extends BaseResp {
  const OpenBusinessViewResp({
    required this.businessType,
    required this.extMsg,
    required int errorCode,
    String? errorMsg,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);

  factory OpenBusinessViewResp.fromJson(Map<String, dynamic> json) =>
      _$OpenBusinessViewRespFromJson(json);

  final String businessType;
  final String extMsg;

  @override
  Map<String, dynamic> toJson() => _$OpenBusinessViewRespToJson(this);
}

@JsonSerializable()
class PayResp extends BaseResp {
  const PayResp({
    required int errorCode,
    String? errorMsg,
    this.returnKey,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);

  factory PayResp.fromJson(Map<String, dynamic> json) =>
      _$PayRespFromJson(json);

  final String? returnKey;

  @override
  Map<String, dynamic> toJson() => _$PayRespToJson(this);
}
