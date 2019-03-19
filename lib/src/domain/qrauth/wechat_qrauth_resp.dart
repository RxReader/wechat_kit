import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'wechat_qrauth_resp.jser.dart';

@GenSerializer()
class WechatQrauthRespSerializer extends Serializer<WechatQrauthResp>
    with _$WechatQrauthRespSerializer {}

class WechatQrauthResp {
  WechatQrauthResp({
    int errorCode,
    this.authCode,
  }) : errorCode = errorCode ?? ERRORCODE_OK;

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

  final int errorCode;
  final String authCode;
}
