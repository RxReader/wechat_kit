import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'wechat_qrauth_resp.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class WechatQrauthResp {
  const WechatQrauthResp({
    required this.errorCode,
    this.authCode,
  });

  factory WechatQrauthResp.fromJson(Map<String, dynamic> json) =>
      _$WechatQrauthRespFromJson(json);

  /// Auth成功
  static const int ERRORCODE_OK = 0;

  /// 普通错误
  static const int ERRORCODE_NORMAL = -1;

  /// 网络错误
  static const int ERRORCODE_NETWORK = -2;

  /// 获取二维码失败
  static const int ERRORCODE_GETQRCODEFAILED = -3;

  /// 用户取消授权
  static const int ERRORCODE_CANCEL = -4;

  /// 超时
  static const int ERRORCODE_TIMEOUT = -5;

  @JsonKey(defaultValue: ERRORCODE_OK)
  final int errorCode;
  final String? authCode;

  bool get isSuccessful => errorCode == ERRORCODE_OK;

  bool get isCancelled => errorCode == ERRORCODE_CANCEL;

  Map<String, dynamic> toJson() => _$WechatQrauthRespToJson(this);

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}
