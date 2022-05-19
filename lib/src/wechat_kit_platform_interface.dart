import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:wechat_kit/src/model/qrauth.dart';
import 'package:wechat_kit/src/model/req.dart';
import 'package:wechat_kit/src/model/resp.dart';
import 'package:wechat_kit/src/wechat_constant.dart';
import 'package:wechat_kit/src/wechat_kit_method_channel.dart';

abstract class WechatKitPlatform extends PlatformInterface {
  /// Constructs a WechatKitPlatform.
  WechatKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static WechatKitPlatform _instance = MethodChannelWechatKit();

  /// The default instance of [WechatKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelWechatKit].
  static WechatKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WechatKitPlatform] when
  /// they register themselves.
  static set instance(WechatKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 向微信注册应用
  Future<void> registerApp({
    required String appId,
    required String? universalLink,
  }) {
    throw UnimplementedError(
        'registerApp({required appId, required universalLink}) has not been implemented.');
  }

  ///
  Stream<BaseReq> reqStream() {
    throw UnimplementedError('reqStream() has not been implemented.');
  }

  ///
  Stream<BaseResp> respStream() {
    throw UnimplementedError('respStream() has not been implemented.');
  }

  /// 扫码登录
  Stream<QrauthResp> qrauthRespStream() {
    throw UnimplementedError('qrauthRespStream() has not been implemented.');
  }

  /// 微信回调 - 冷启
  Future<void> handleInitialWXReq() {
    throw UnimplementedError('handleInitialWXReq() has not been implemented.');
  }

  /// 检测微信是否已安装
  Future<bool> isInstalled() {
    throw UnimplementedError('isInstalled() has not been implemented.');
  }

  /// 判断当前微信的版本是否支持OpenApi
  Future<bool> isSupportApi() {
    throw UnimplementedError('isSupportApi() has not been implemented.');
  }

  /// 判断当前微信的版本是否支持分享微信状态功能
  Future<bool> isSupportStateApi() {
    throw UnimplementedError('isSupportStateApi() has not been implemented.');
  }

  /// 打开微信
  Future<bool> openWechat() {
    throw UnimplementedError('openWechat() has not been implemented.');
  }

  // --- 微信APP授权登录

  /// 授权登录
  Future<void> auth({
    required List<String> scope,
    String? state,
    int type = WechatAuthType.NORMAL,
  }) {
    throw UnimplementedError(
        'auth({required scope, state, type}) has not been implemented.');
  }

  // --- 微信APP扫码登录

  /// 调用微信 API 获得 ticket，开始扫码登录
  Future<void> startQrauth({
    required String appId,
    required List<String> scope,
    required String noncestr,
    required String ticket,
  }) {
    throw UnimplementedError(
        'startQrauth({required appId, required scope, required noncestr, required ticket}) has not been implemented.');
  }

  /// 暂停扫码登录请求
  Future<void> stopQrauth() {
    throw UnimplementedError('stopQrauth() has not been implemented.');
  }

  //

  /// 打开指定网页
  Future<void> openUrl({
    required String url,
  }) {
    throw UnimplementedError(
        'openUrl({required url}) has not been implemented.');
  }

  /// 打开硬件排行榜
  Future<void> openRankList() {
    throw UnimplementedError('openRankList() has not been implemented.');
  }

  /// 分享 - 文本
  Future<void> shareText({
    required int scene,
    required String text,
  }) {
    throw UnimplementedError(
        'shareText({required scene, required text}) has not been implemented.');
  }

  /// 分享 - 图片
  Future<void> shareImage({
    required int scene,
    String? title,
    String? description,
    Uint8List? thumbData,
    Uint8List? imageData,
    Uri? imageUri,
  }) {
    throw UnimplementedError(
        'shareImage({required scene, title, description, thumbData, imageData, imageUri}) has not been implemented.');
  }

  /// 分享 - 文件
  Future<void> shareFile({
    required int scene,
    String? title,
    String? description,
    Uint8List? thumbData,
    Uint8List? fileData,
    Uri? fileUri,
    String? fileExtension,
  }) {
    throw UnimplementedError(
        'shareFile({required scene, title, description, thumbData, fileData, fileUri, fileExtension}) has not been implemented.');
  }

  /// 分享 - Emoji/GIF
  Future<void> shareEmoji({
    required int scene,
    String? title,
    String? description,
    required Uint8List thumbData,
    Uint8List? emojiData,
    Uri? emojiUri,
  }) {
    throw UnimplementedError(
        'shareEmoji({required scene, title, description, required thumbData, emojiData, emojiUri}) has not been implemented.');
  }

  /// 分享 - 音乐
  Future<void> shareMediaMusic({
    required int scene,
    String? title,
    String? description,
    Uint8List? thumbData,
    String? musicUrl,
    String? musicDataUrl,
    String? musicLowBandUrl,
    String? musicLowBandDataUrl,
  }) {
    throw UnimplementedError(
        'shareMediaMusic({required scene, title, description, thumbData, musicUrl, musicDataUrl, musicLowBandUrl, musicLowBandDataUrl}) has not been implemented.');
  }

  /// 分享 - 视频
  Future<void> shareVideo({
    required int scene,
    String? title,
    String? description,
    Uint8List? thumbData,
    String? videoUrl,
    String? videoLowBandUrl,
  }) {
    throw UnimplementedError(
        'shareVideo({required scene, title, description, thumbData, videoUrl, videoLowBandUrl}) has not been implemented.');
  }

  /// 分享 - 网页
  Future<void> shareWebpage({
    required int scene,
    String? title,
    String? description,
    Uint8List? thumbData,
    required String webpageUrl,
  }) {
    throw UnimplementedError(
        'shareWebpage({required scene, title, description, thumbData, required webpageUrl}) has not been implemented.');
  }

  /// 分享 - 小程序 - 目前只支持分享到会话
  Future<void> shareMiniProgram({
    required int scene,
    String? title,
    String? description,
    Uint8List? thumbData,
    required String webpageUrl,
    required String userName,
    String? path,
    Uint8List? hdImageData,
    bool withShareTicket = false,
    int type = WechatMiniProgram.RELEASE,
    bool disableForward = false,
  }) {
    throw UnimplementedError(
        'shareMiniProgram({required scene, title, description, thumbData, required webpageUrl, required userName, path, hdImageData, withShareTicket, type, disableForward}) has not been implemented.');
  }

  /// 一次性订阅消息
  Future<void> subscribeMsg({
    required int scene,
    required String templateId,
    String? reserved,
  }) {
    throw UnimplementedError(
        'subscribeMsg({required scene, required templateId, reserved}) has not been implemented.');
  }

  /// 打开小程序
  Future<void> launchMiniProgram({
    required String userName,
    String? path,
    int type = WechatMiniProgram.RELEASE,
  }) {
    throw UnimplementedError(
        'launchMiniProgram({required userName, path, type}) has not been implemented.');
  }

  /// 打开微信客服
  Future<void> openCustomerServiceChat({
    required String corpId,
    required String url,
  }) {
    throw UnimplementedError(
        'openCustomerServiceChat({required corpId, required url}) has not been implemented.');
  }

  /// 调起支付分
  ///  * 免确认模式：https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter6_1_7.shtml
  ///  * 需确认授权：https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter6_1_11.shtml
  ///  * 拉起小程序：https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter6_1_23.shtml
  Future<void> openBusinessView({
    required String businessType,
    String? query,
    String? extInfo,
  }) {
    throw UnimplementedError(
        'openBusinessView({required businessType, query, extInfo}) has not been implemented.');
  }

  /// APP纯签约
  /// * APP纯签约-预签约接口：https://pay.weixin.qq.com/wiki/doc/api/xiaowei.php?chapter=19_5
  /// * APP纯签约-预签约接口：https://pay.weixin.qq.com/wiki/doc/api/pap_jt_v2.php?chapter=19_5&index=2_2
  Future<void> openBusinessWebview({
    required int businessType,
    Map<String, String>? resultInfo,
  }) {
    throw UnimplementedError(
        'openBusinessWebview({required businessType, resultInfo}) has not been implemented.');
  }

  /// 支付
  ///
  /// 参数说明：https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_12&index=2
  ///
  /// * 默认包含支付，参考 https://github.com/RxReader/wechat_kit/blob/master/example/ios/Podfile
  ///   修改 `$WechatKitSubspec = 'no_pay'` 可切换为不包含支付
  /// * 不含「iOS 支付」调用会抛出 [MissingPluginException]
  Future<void> pay({
    required String appId,
    required String partnerId,
    required String prepayId,
    required String package,
    required String nonceStr,
    required String timeStamp,
    required String sign,
  }) {
    throw UnimplementedError(
        'pay({required appId, required partnerId, required prepayId, required package, required nonceStr, required timeStamp, required sign}) has not been implemented.');
  }
}
