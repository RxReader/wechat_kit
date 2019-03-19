import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'wechat_sdk_resp.jser.dart';

@GenSerializer()
class WechatSdkRespSerializer extends Serializer<WechatSdkResp>
    with _$WechatSdkRespSerializer {}

class WechatSdkResp {
  WechatSdkResp({
    int errorCode,
    this.errorMsg,
  }): errorCode = errorCode ?? ERRORCODE_SUCCESS;

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
  final int errorCode;

  /// 错误提示字符串
  final String errorMsg;
}
