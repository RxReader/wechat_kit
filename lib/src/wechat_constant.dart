class WechatScope {
  WechatScope._();

  /// 只能获取openId
  static const String SNSAPI_BASE = 'snsapi_base';

  /// 能获取openId和用户基本信息
  static const String SNSAPI_USERINFO = 'snsapi_userinfo';
}

class WechatScene {
  WechatScene._();

  /// 聊天界面
  static const int SESSION = 0;

  /// 朋友圈
  static const int TIMELINE = 1;

  /// 收藏
  static const int FAVORITE = 2;
}

class WechatBizProfileType {
  WechatBizProfileType._();

  /// 普通公众号
  static const int NORMAL = 0;

  /// 硬件公众号
  static const int DEVICE = 1;
}

class WechatMPWebviewType {
  WechatMPWebviewType._();

  /// 广告网页
  static const int AD = 0;
}

class WechatMiniProgram {
  WechatMiniProgram._();

  /// 正式版
  static const int release = 0;

  /// 测试版
  static const int test = 1;

  /// 体验版
  static const int preview = 2;
}
