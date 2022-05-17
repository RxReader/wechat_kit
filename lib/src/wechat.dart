import 'dart:typed_data';

import 'package:wechat_kit/src/model/qrauth.dart';
import 'package:wechat_kit/src/model/req.dart';
import 'package:wechat_kit/src/model/resp.dart';
import 'package:wechat_kit/src/wechat_constant.dart';
import 'package:wechat_kit/src/wechat_kit_platform_interface.dart';

class Wechat {
  const Wechat._();

  /// 向微信注册应用
  static Future<void> registerApp({
    required String appId,
    required String? universalLink,
  }) {
    return WechatKitPlatform.instance.registerApp(
      appId: appId,
      universalLink: universalLink,
    );
  }

  ///
  static Stream<BaseReq> reqStream() {
    return WechatKitPlatform.instance.reqStream();
  }

  ///
  static Stream<BaseResp> respStream() {
    return WechatKitPlatform.instance.respStream();
  }

  /// 扫码登录
  static Stream<QrauthResp> qrauthRespStream() {
    return WechatKitPlatform.instance.qrauthRespStream();
  }

  /// 微信回调 - 冷启
  static Future<void> handleInitialWXReq() {
    return WechatKitPlatform.instance.handleInitialWXReq();
  }

  /// 检测微信是否已安装
  static Future<bool> isInstalled() {
    return WechatKitPlatform.instance.isInstalled();
  }

  /// 判断当前微信的版本是否支持OpenApi
  static Future<bool> isSupportApi() {
    return WechatKitPlatform.instance.isSupportApi();
  }

  /// 判断当前微信的版本是否支持分享微信状态功能
  static Future<bool> isSupportStateApi() {
    return WechatKitPlatform.instance.isSupportStateApi();
  }

  /// 打开微信
  static Future<bool> openWechat() {
    return WechatKitPlatform.instance.openWechat();
  }

  // --- 微信APP授权登录

  /// 授权登录
  static Future<void> auth({
    required List<String> scope,
    String? state,
    int type = WechatAuthType.NORMAL,
  }) {
    return WechatKitPlatform.instance.auth(
      scope: scope,
      state: state,
      type: type,
    );
  }

  // --- 微信APP扫码登录

  /// 调用微信 API 获得 ticket，开始扫码登录
  static Future<void> startQrauth({
    required String appId,
    required List<String> scope,
    required String noncestr,
    required String ticket,
  }) {
    return WechatKitPlatform.instance.startQrauth(
      appId: appId,
      scope: scope,
      noncestr: noncestr,
      ticket: ticket,
    );
  }

  /// 暂停扫码登录请求
  static Future<void> stopQrauth() {
    return WechatKitPlatform.instance.stopQrauth();
  }

  //

  /// 打开指定网页
  static Future<void> openUrl({
    required String url,
  }) {
    return WechatKitPlatform.instance.openUrl(url: url);
  }

  /// 打开硬件排行榜
  static Future<void> openRankList() {
    return WechatKitPlatform.instance.openRankList();
  }

  /// 分享 - 文本
  static Future<void> shareText({
    required int scene,
    required String text,
  }) {
    return WechatKitPlatform.instance.shareText(
      scene: scene,
      text: text,
    );
  }

  /// 分享 - 图片
  static Future<void> shareImage({
    required int scene,
    String? title,
    String? description,
    Uint8List? thumbData,
    Uint8List? imageData,
    Uri? imageUri,
  }) {
    return WechatKitPlatform.instance.shareImage(
      scene: scene,
      title: title,
      description: description,
      thumbData: thumbData,
      imageData: imageData,
      imageUri: imageUri,
    );
  }

  /// 分享 - 文件
  static Future<void> shareFile({
    required int scene,
    String? title,
    String? description,
    Uint8List? thumbData,
    Uint8List? fileData,
    Uri? fileUri,
    String? fileExtension,
  }) {
    return WechatKitPlatform.instance.shareFile(
      scene: scene,
      title: title,
      description: description,
      thumbData: thumbData,
      fileData: fileData,
      fileUri: fileUri,
      fileExtension: fileExtension,
    );
  }

  /// 分享 - Emoji/GIF
  static Future<void> shareEmoji({
    required int scene,
    String? title,
    String? description,
    required Uint8List thumbData,
    Uint8List? emojiData,
    Uri? emojiUri,
  }) {
    return WechatKitPlatform.instance.shareEmoji(
      scene: scene,
      title: title,
      description: description,
      thumbData: thumbData,
      emojiData: emojiData,
      emojiUri: emojiUri,
    );
  }

  /// 分享 - 音乐
  static Future<void> shareMediaMusic({
    required int scene,
    String? title,
    String? description,
    Uint8List? thumbData,
    String? musicUrl,
    String? musicDataUrl,
    String? musicLowBandUrl,
    String? musicLowBandDataUrl,
  }) {
    return WechatKitPlatform.instance.shareMediaMusic(
      scene: scene,
      title: title,
      description: description,
      thumbData: thumbData,
      musicUrl: musicUrl,
      musicDataUrl: musicDataUrl,
      musicLowBandUrl: musicLowBandUrl,
      musicLowBandDataUrl: musicLowBandDataUrl,
    );
  }

  /// 分享 - 视频
  static Future<void> shareVideo({
    required int scene,
    String? title,
    String? description,
    Uint8List? thumbData,
    String? videoUrl,
    String? videoLowBandUrl,
  }) {
    return WechatKitPlatform.instance.shareVideo(
      scene: scene,
      title: title,
      description: description,
      thumbData: thumbData,
      videoUrl: videoUrl,
      videoLowBandUrl: videoLowBandUrl,
    );
  }

  /// 分享 - 网页
  static Future<void> shareWebpage({
    required int scene,
    String? title,
    String? description,
    Uint8List? thumbData,
    required String webpageUrl,
  }) {
    return WechatKitPlatform.instance.shareWebpage(
      scene: scene,
      title: title,
      description: description,
      thumbData: thumbData,
      webpageUrl: webpageUrl,
    );
  }

  /// 分享 - 小程序 - 目前只支持分享到会话
  static Future<void> shareMiniProgram({
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
    return WechatKitPlatform.instance.shareMiniProgram(
      scene: scene,
      title: title,
      description: description,
      thumbData: thumbData,
      webpageUrl: webpageUrl,
      userName: userName,
      path: path,
      hdImageData: hdImageData,
      withShareTicket: withShareTicket,
      type: type,
      disableForward: disableForward,
    );
  }

  /// 一次性订阅消息
  static Future<void> subscribeMsg({
    required int scene,
    required String templateId,
    String? reserved,
  }) {
    return WechatKitPlatform.instance.subscribeMsg(
      scene: scene,
      templateId: templateId,
      reserved: reserved,
    );
  }

  /// 打开小程序
  static Future<void> launchMiniProgram({
    required String userName,
    String? path,
    int type = WechatMiniProgram.RELEASE,
  }) {
    return WechatKitPlatform.instance.launchMiniProgram(
      userName: userName,
      path: path,
      type: type,
    );
  }

  /// 打开微信客服
  static Future<void> openCustomerServiceChat({
    required String corpId,
    required String url,
  }) {
    return WechatKitPlatform.instance.openCustomerServiceChat(
      corpId: corpId,
      url: url,
    );
  }

  /// 调起支付分
  ///  * 免确认模式：https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter6_1_7.shtml
  ///  * 需确认授权：https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter6_1_11.shtml
  ///  * 拉起小程序：https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter6_1_23.shtml
  static Future<void> openBusinessView({
    required String businessType,
    String? query,
    String? extInfo,
  }) {
    return WechatKitPlatform.instance.openBusinessView(
      businessType: businessType,
      query: query,
      extInfo: extInfo,
    );
  }

  /// APP纯签约
  /// * APP纯签约-预签约接口：https://pay.weixin.qq.com/wiki/doc/api/xiaowei.php?chapter=19_5
  /// * APP纯签约-预签约接口：https://pay.weixin.qq.com/wiki/doc/api/pap_jt_v2.php?chapter=19_5&index=2_2
  static Future<void> openBusinessWebview({
    required int businessType,
    Map<String, String>? resultInfo,
  }) {
    return WechatKitPlatform.instance.openBusinessWebview(
      businessType: businessType,
      resultInfo: resultInfo,
    );
  }

  /// 支付
  ///
  /// 参数说明：https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_12&index=2
  ///
  /// * 默认包含支付，参考 https://github.com/RxReader/wechat_kit/blob/master/example/ios/Podfile
  ///   修改 `$WechatKitSubspec = 'no_pay'` 可切换为不包含支付。
  /// * 不含「iOS 支付」调用会抛出 [MissingPluginException]。
  static Future<void> pay({
    required String appId,
    required String partnerId,
    required String prepayId,
    required String package,
    required String nonceStr,
    required String timeStamp,
    required String sign,
  }) {
    return WechatKitPlatform.instance.pay(
      appId: appId,
      partnerId: partnerId,
      prepayId: prepayId,
      package: package,
      nonceStr: nonceStr,
      timeStamp: timeStamp,
      sign: sign,
    );
  }
}
