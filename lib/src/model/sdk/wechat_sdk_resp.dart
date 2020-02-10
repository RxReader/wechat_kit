import 'package:json_annotation/json_annotation.dart';

part 'wechat_sdk_resp.g.dart';

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
)
class WechatSdkResp {
  WechatSdkResp({
    this.errorCode,
    this.errorMsg,
  });

  factory WechatSdkResp.fromJson(Map<dynamic, dynamic> json) =>
      _$WechatSdkRespFromJson(json);

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
  @JsonKey(
    defaultValue: ERRORCODE_SUCCESS,
  )
  final int errorCode;

  /// 错误提示字符串
  final String errorMsg;

  bool isSuccessful() => errorCode == ERRORCODE_SUCCESS;

  Map<dynamic, dynamic> toJson() => _$WechatSdkRespToJson(this);
}
