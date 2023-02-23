import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'resp.g.dart';

abstract class WechatResp {
  const WechatResp({
    required this.errorCode,
    this.errorMsg,
  });

  /// 成功
  static const int kErrorCodeSuccess = 0;

  /// 普通错误类型
  static const int kErrorCodeCommon = -1;

  /// 用户点击取消并返回
  static const int kErrorCodeUserCancel = -2;

  /// 发送失败
  static const int kErrorCodeSentFail = -3;

  /// 授权失败
  static const int kErrorCodeAuthDeny = -4;

  /// 微信不支持
  static const int kErrorCodeUnsupport = -5;

  /// 错误码
  @JsonKey(defaultValue: kErrorCodeSuccess)
  final int errorCode;

  /// 错误提示字符串
  final String? errorMsg;

  bool get isSuccessful => errorCode == kErrorCodeSuccess;

  bool get isCancelled => errorCode == kErrorCodeUserCancel;

  Map<String, dynamic> toJson();

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}

@JsonSerializable()
class WechatAuthResp extends WechatResp {
  const WechatAuthResp({
    required super.errorCode,
    super.errorMsg,
    this.code,
    this.state,
    this.lang,
    this.country,
  });

  factory WechatAuthResp.fromJson(Map<String, dynamic> json) =>
      _$WechatAuthRespFromJson(json);

  final String? code;
  final String? state;
  final String? lang;
  final String? country;

  @override
  Map<String, dynamic> toJson() => _$WechatAuthRespToJson(this);
}

@JsonSerializable()
class WechatOpenUrlResp extends WechatResp {
  const WechatOpenUrlResp({
    required super.errorCode,
    super.errorMsg,
  });

  factory WechatOpenUrlResp.fromJson(Map<String, dynamic> json) =>
      _$WechatOpenUrlRespFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WechatOpenUrlRespToJson(this);
}

@JsonSerializable()
class WechatShareMsgResp extends WechatResp {
  const WechatShareMsgResp({
    required super.errorCode,
    super.errorMsg,
  });

  factory WechatShareMsgResp.fromJson(Map<String, dynamic> json) =>
      _$WechatShareMsgRespFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WechatShareMsgRespToJson(this);
}

@JsonSerializable()
class WechatSubscribeMsgResp extends WechatResp {
  const WechatSubscribeMsgResp({
    required super.errorCode,
    super.errorMsg,
    this.openId,
    this.templateId,
    this.scene,
    this.action,
    this.reserved,
  });

  factory WechatSubscribeMsgResp.fromJson(Map<String, dynamic> json) =>
      _$WechatSubscribeMsgRespFromJson(json);

  final String? openId;
  final String? templateId;
  final int? scene;
  final String? action;
  final String? reserved;

  @override
  Map<String, dynamic> toJson() => _$WechatSubscribeMsgRespToJson(this);
}

@JsonSerializable()
class WechatLaunchMiniProgramResp extends WechatResp {
  const WechatLaunchMiniProgramResp({
    required super.errorCode,
    super.errorMsg,
    this.extMsg,
  });

  factory WechatLaunchMiniProgramResp.fromJson(Map<String, dynamic> json) =>
      _$WechatLaunchMiniProgramRespFromJson(json);

  final String? extMsg;

  @override
  Map<String, dynamic> toJson() => _$WechatLaunchMiniProgramRespToJson(this);
}

@JsonSerializable()
class WechatOpenCustomerServiceChatResp extends WechatResp {
  const WechatOpenCustomerServiceChatResp({
    required super.errorCode,
    super.errorMsg,
  });

  factory WechatOpenCustomerServiceChatResp.fromJson(
          Map<String, dynamic> json) =>
      _$WechatOpenCustomerServiceChatRespFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$WechatOpenCustomerServiceChatRespToJson(this);
}

@JsonSerializable()
class WechatOpenBusinessViewResp extends WechatResp {
  const WechatOpenBusinessViewResp({
    required super.errorCode,
    super.errorMsg,
    required this.businessType,
    this.extMsg,
  });

  factory WechatOpenBusinessViewResp.fromJson(Map<String, dynamic> json) =>
      _$WechatOpenBusinessViewRespFromJson(json);

  final String businessType;
  final String? extMsg;

  @override
  Map<String, dynamic> toJson() => _$WechatOpenBusinessViewRespToJson(this);
}

@JsonSerializable()
class WechatOpenBusinessWebviewResp extends WechatResp {
  const WechatOpenBusinessWebviewResp({
    required super.errorCode,
    super.errorMsg,
    required this.businessType,
    this.resultInfo,
  });

  factory WechatOpenBusinessWebviewResp.fromJson(Map<String, dynamic> json) =>
      _$WechatOpenBusinessWebviewRespFromJson(json);

  final int businessType;
  final String? resultInfo;

  @override
  Map<String, dynamic> toJson() => _$WechatOpenBusinessWebviewRespToJson(this);
}

@JsonSerializable()
class WechatPayResp extends WechatResp {
  const WechatPayResp({
    required super.errorCode,
    super.errorMsg,
    this.returnKey,
  });

  factory WechatPayResp.fromJson(Map<String, dynamic> json) =>
      _$WechatPayRespFromJson(json);

  final String? returnKey;

  @override
  Map<String, dynamic> toJson() => _$WechatPayRespToJson(this);
}
