class WechatScope {
  WechatScope._();

  /// 只能获取openId
  static const String SNSAPI_BASE = 'snsapi_base';

  /// 能获取openId和用户基本信息
  static const String SNSAPI_USERINFO = 'snsapi_userinfo';
}
