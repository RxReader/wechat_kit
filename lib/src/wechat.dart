import 'package:wechat_kit/src/wechat_kit_platform_interface.dart';

@Deprecated('直接用 WechatKitPlatform')
class Wechat {
  const Wechat._();

  @Deprecated('直接用 WechatKitPlatform.instance')
  static WechatKitPlatform get instance => WechatKitPlatform.instance;
}
