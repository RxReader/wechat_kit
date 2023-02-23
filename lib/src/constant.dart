class WechatScope {
  const WechatScope._();

  /// 只能获取openId
  static const String kSNSApiBase = 'snsapi_base';

  /// 能获取openId和用户基本信息
  static const String kSNSApiUserInfo = 'snsapi_userinfo';
}

class WechatAuthType {
  const WechatAuthType._();

  /// APP授权
  static const int kNormal = 0;

  /// WEB授权 - 仅iOS
  static const int kWeb = 1;
}

class WechatScene {
  const WechatScene._();

  /// 聊天界面
  static const int kSession = 0;

  /// 朋友圈
  static const int kTimeline = 1;

  /// 收藏
  static const int kFavorite = 2;
}

class WechatBizProfileType {
  const WechatBizProfileType._();

  /// 普通公众号
  static const int kNormal = 0;

  /// 硬件公众号
  static const int kDevice = 1;
}

class WechatMPWebviewType {
  const WechatMPWebviewType._();

  /// 广告网页
  static const int kAd = 0;
}

class WechatMiniProgram {
  const WechatMiniProgram._();

  /// 正式版
  static const int kRelease = 0;

  /// 测试版
  static const int kTest = 1;

  /// 体验版
  static const int kPreview = 2;
}
