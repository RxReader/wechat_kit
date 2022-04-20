import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:wechat_kit/src/model/qrauth.dart';
import 'package:wechat_kit/src/model/req.dart';
import 'package:wechat_kit/src/model/resp.dart';
import 'package:wechat_kit/src/wechat_constant.dart';

/// The Wechat instance.
class Wechat {
  Wechat._();

  static Wechat get instance => _instance;
  static late final Wechat _instance = Wechat._();

  static const String _METHOD_REGISTERAPP = 'registerApp';
  static const String _METHOD_HANDLEINITIALWXREQ = 'handleInitialWXReq';
  static const String _METHOD_ISINSTALLED = 'isInstalled';
  static const String _METHOD_ISSUPPORTAPI = 'isSupportApi';
  static const String _METHOD_ISSUPPORTSTATEAPI = 'isSupportStateAPI';
  static const String _METHOD_OPENWECHAT = 'openWechat';
  static const String _METHOD_AUTH = 'auth';
  static const String _METHOD_STARTQRAUTH = 'startQrauth';
  static const String _METHOD_STOPQRAUTH = 'stopQrauth';
  static const String _METHOD_OPENURL = 'openUrl';
  static const String _METHOD_OPENRANKLIST = 'openRankList';
  static const String _METHOD_SHARETEXT = 'shareText';
  static const String _METHOD_SHAREIMAGE = 'shareImage';
  static const String _METHOD_SHAREFILE = 'shareFile';
  static const String _METHOD_SHAREEMOJI = 'shareEmoji';
  static const String _METHOD_SHAREMUSIC = 'shareMusic';
  static const String _METHOD_SHAREVIDEO = 'shareVideo';
  static const String _METHOD_SHAREWEBPAGE = 'shareWebpage';
  static const String _METHOD_SHAREMINIPROGRAM = 'shareMiniProgram';
  static const String _METHOD_SUBSCRIBEMSG = 'subscribeMsg';
  static const String _METHOD_LAUNCHMINIPROGRAM = 'launchMiniProgram';
  static const String _METHOD_OPENCUSTOMERSERVICECHAT =
      'openCustomerServiceChat';
  static const String _METHOD_OPENBUSINESSVIEW = 'openBusinessView';
  static const String _METHOD_OPENBUSINESSWEBVIEW = 'openBusinessWebview';
  static const String _METHOD_PAY = 'pay';

  static const String _METHOD_ONLAUNCHFROMWXREQ = 'onLaunchFromWXReq';
  static const String _METHOD_ONSHOWMESSAGEFROMWXREQ = 'onShowMessageFromWXReq';

  static const String _METHOD_ONAUTHRESP = 'onAuthResp';
  static const String _METHOD_ONOPENURLRESP = 'onOpenUrlResp';
  static const String _METHOD_ONSHAREMSGRESP = 'onShareMsgResp';
  static const String _METHOD_ONSUBSCRIBEMSGRESP = 'onSubscribeMsgResp';
  static const String _METHOD_ONLAUNCHMINIPROGRAMRESP =
      'onLaunchMiniProgramResp';
  static const String _METHOD_ONOPENCUSTOMERSERVICECHATRESP =
      'onOpenCustomerServiceChatResp';
  static const String _METHOD_ONOPENBUSINESSVIEWRESP = 'onOpenBusinessViewResp';
  static const String _METHOD_ONOPENBUSINESSWEBVIEWRESP =
      'onOpenBusinessWebviewResp';
  static const String _METHOD_ONPAYRESP = 'onPayResp';
  static const String _METHOD_ONAUTHGOTQRCODE = 'onAuthGotQrcode';
  static const String _METHOD_ONAUTHQRCODESCANNED = 'onAuthQrcodeScanned';
  static const String _METHOD_ONAUTHFINISH = 'onAuthFinish';

  static const String _ARGUMENT_KEY_APPID = 'appId';
  static const String _ARGUMENT_KEY_UNIVERSALLINK = 'universalLink';
  static const String _ARGUMENT_KEY_SCOPE = 'scope';
  static const String _ARGUMENT_KEY_STATE = 'state';
  static const String _ARGUMENT_KEY_NONCESTR = 'noncestr';
  static const String _ARGUMENT_KEY_TIMESTAMP = 'timestamp';
  static const String _ARGUMENT_KEY_SIGNATURE = 'signature';
  static const String _ARGUMENT_KEY_URL = 'url';
  static const String _ARGUMENT_KEY_QUERY = 'query';
  static const String _ARGUMENT_KEY_USERNAME = 'username';
  static const String _ARGUMENT_KEY_SCENE = 'scene';
  static const String _ARGUMENT_KEY_TEXT = 'text';
  static const String _ARGUMENT_KEY_TITLE = 'title';
  static const String _ARGUMENT_KEY_DESCRIPTION = 'description';
  static const String _ARGUMENT_KEY_THUMBDATA = 'thumbData';
  static const String _ARGUMENT_KEY_IMAGEDATA = 'imageData';
  static const String _ARGUMENT_KEY_IMAGEURI = 'imageUri';
  static const String _ARGUMENT_KEY_FILEDATA = 'fileData';
  static const String _ARGUMENT_KEY_FILEURI = 'fileUri';
  static const String _ARGUMENT_KEY_FILEEXTENSION = 'fileExtension';
  static const String _ARGUMENT_KEY_EMOJIDATA = 'emojiData';
  static const String _ARGUMENT_KEY_EMOJIURI = 'emojiUri';
  static const String _ARGUMENT_KEY_MUSICURL = 'musicUrl';
  static const String _ARGUMENT_KEY_MUSICDATAURL = 'musicDataUrl';
  static const String _ARGUMENT_KEY_MUSICLOWBANDURL = 'musicLowBandUrl';
  static const String _ARGUMENT_KEY_MUSICLOWBANDDATAURL = 'musicLowBandDataUrl';
  static const String _ARGUMENT_KEY_VIDEOURL = 'videoUrl';
  static const String _ARGUMENT_KEY_VIDEOLOWBANDURL = 'videoLowBandUrl';
  static const String _ARGUMENT_KEY_WEBPAGEURL = 'webpageUrl';
  static const String _ARGUMENT_KEY_PATH = 'path';
  static const String _ARGUMENT_KEY_HDIMAGEDATA = 'hdImageData';
  static const String _ARGUMENT_KEY_WITHSHARETICKET = 'withShareTicket';
  static const String _ARGUMENT_KEY_TYPE = 'type';
  static const String _ARGUMENT_KEY_DISABLEFORWARD = 'disableForward';
  static const String _ARGUMENT_KEY_TEMPLATEID = 'templateId';
  static const String _ARGUMENT_KEY_RESERVED = 'reserved';
  static const String _ARGUMENT_KEY_CORPID = 'corpId';
  static const String _ARGUMENT_KEY_BUSINESSTYPE = 'businessType';
  static const String _ARGUMENT_KEY_QUERYINFO = 'queryInfo';
  static const String _ARGUMENT_KEY_PARTNERID = 'partnerId';
  static const String _ARGUMENT_KEY_PREPAYID = 'prepayId';
  static const String _ARGUMENT_KEY_PACKAGE = 'package';
  static const String _ARGUMENT_KEY_SIGN = 'sign';
  static const String _ARGUMENT_KEY_EXTINFO = 'extInfo';

  static const String _SCHEME_FILE = 'file';

  late final MethodChannel _channel =
      const MethodChannel('v7lin.github.io/wechat_kit')
        ..setMethodCallHandler(_handleMethod);

  final StreamController<BaseReq> _reqStreamController =
      StreamController<BaseReq>.broadcast();

  final StreamController<BaseResp> _respStreamController =
      StreamController<BaseResp>.broadcast();

  final StreamController<QrauthResp> _qrauthRespStreamController =
      StreamController<QrauthResp>.broadcast();

  /// 向微信注册应用
  Future<void> registerApp({
    required String appId,
    required String? universalLink,
  }) {
    assert(!Platform.isIOS || (universalLink?.isNotEmpty ?? false));
    return _channel.invokeMethod<void>(
      _METHOD_REGISTERAPP,
      <String, dynamic>{
        _ARGUMENT_KEY_APPID: appId,
        _ARGUMENT_KEY_UNIVERSALLINK: universalLink,
      },
    );
  }

  /// 微信回调 - 冷启
  Future<void> handleInitialWXReq() {
    return _channel.invokeMethod<void>(_METHOD_HANDLEINITIALWXREQ);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    // 优先处理不需要参数的请求
    if (call.method == _METHOD_ONAUTHQRCODESCANNED) {
      _qrauthRespStreamController.add(const QrcodeScannedResp());
      return;
    }

    final Map<String, dynamic> _data =
        (call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>();

    switch (call.method) {
      // onReq
      case _METHOD_ONLAUNCHFROMWXREQ:
        _reqStreamController.add(LaunchFromWXReq.fromJson(_data));
        break;
      case _METHOD_ONSHOWMESSAGEFROMWXREQ:
        _reqStreamController.add(ShowMessageFromWXReq.fromJson(_data));
        break;
      // onResp
      case _METHOD_ONAUTHRESP:
        _respStreamController.add(AuthResp.fromJson(_data));
        break;
      case _METHOD_ONOPENURLRESP:
        _respStreamController.add(OpenUrlResp.fromJson(_data));
        break;
      case _METHOD_ONSHAREMSGRESP:
        _respStreamController.add(ShareMsgResp.fromJson(_data));
        break;
      case _METHOD_ONSUBSCRIBEMSGRESP:
        _respStreamController.add(SubscribeMsgResp.fromJson(_data));
        break;
      case _METHOD_ONLAUNCHMINIPROGRAMRESP:
        _respStreamController.add(LaunchMiniProgramResp.fromJson(_data));
        break;
      case _METHOD_ONOPENCUSTOMERSERVICECHATRESP:
        _respStreamController.add(OpenCustomerServiceChatResp.fromJson(_data));
        break;
      case _METHOD_ONOPENBUSINESSVIEWRESP:
        _respStreamController.add(OpenBusinessViewResp.fromJson(_data));
        break;
      case _METHOD_ONOPENBUSINESSWEBVIEWRESP:
        _respStreamController.add(OpenBusinessWebviewResp.fromJson(_data));
        break;
      case _METHOD_ONPAYRESP:
        _respStreamController.add(PayResp.fromJson(_data));
        break;
      // onQrauth
      case _METHOD_ONAUTHGOTQRCODE:
        _qrauthRespStreamController.add(GotQrcodeResp.fromJson(_data));
        break;
      case _METHOD_ONAUTHFINISH:
        _qrauthRespStreamController.add(FinishResp.fromJson(_data));
        break;
    }
  }

  ///
  Stream<BaseReq> reqStream() {
    return _reqStreamController.stream;
  }

  ///
  Stream<BaseResp> respStream() {
    return _respStreamController.stream;
  }

  /// 扫码登录
  Stream<QrauthResp> qrauthRespStream() {
    return _qrauthRespStreamController.stream;
  }

  /// 检测微信是否已安装
  Future<bool> isInstalled() async {
    return await _channel.invokeMethod<bool>(_METHOD_ISINSTALLED) ?? false;
  }

  /// 判断当前微信的版本是否支持OpenApi
  Future<bool> isSupportApi() async {
    return await _channel.invokeMethod<bool>(_METHOD_ISSUPPORTAPI) ?? false;
  }

  /// 判断当前微信的版本是否支持分享微信状态功能
  Future<bool> isSupportStateAPI() async {
    return await _channel.invokeMethod<bool>(_METHOD_ISSUPPORTSTATEAPI) ??
        false;
  }

  /// 打开微信
  Future<bool> openWechat() async {
    return await _channel.invokeMethod<bool>(_METHOD_OPENWECHAT) ?? false;
  }

  // --- 微信APP授权登录

  /// 授权登录
  Future<void> auth({
    required List<String> scope,
    String? state,
  }) {
    return _channel.invokeMethod<void>(_METHOD_AUTH, <String, dynamic>{
      _ARGUMENT_KEY_SCOPE: scope.join(','), // Scope
      if (state != null) _ARGUMENT_KEY_STATE: state,
    });
  }

  /// iOS：未安装微信，授权登录
  Future<void> sendAuth({
    required List<String> scope,
    String? state,
  }) {
    assert(Platform.isIOS);
    return _channel.invokeMethod<void>('sendAuth', <String, dynamic>{
      _ARGUMENT_KEY_SCOPE: scope.join(','), // Scope
      if (state != null) _ARGUMENT_KEY_STATE: state,
    });
  }

  // --- 微信APP扫码登录

  /// 调用微信 API 获得 ticket，开始扫码登录
  Future<void> startQrauth({
    required String appId,
    required List<String> scope,
    required String noncestr,
    required String ticket,
  }) {
    final String timestamp = '${DateTime.now().millisecondsSinceEpoch}';
    final String content = 'appid=$appId'
        '&noncestr=$noncestr'
        '&sdk_ticket=$ticket'
        '&timestamp=$timestamp';
    final String signature = hex.encode(
      sha1.convert(utf8.encode(content)).bytes,
    );
    return _channel.invokeMethod<void>(
      _METHOD_STARTQRAUTH,
      <String, dynamic>{
        _ARGUMENT_KEY_APPID: appId,
        _ARGUMENT_KEY_SCOPE: scope.join(','), // Scope
        _ARGUMENT_KEY_NONCESTR: noncestr,
        _ARGUMENT_KEY_TIMESTAMP: timestamp,
        _ARGUMENT_KEY_SIGNATURE: signature,
      },
    );
  }

  /// 暂停扫码登录请求
  Future<void> stopQrauth() {
    return _channel.invokeMethod<void>(_METHOD_STOPQRAUTH);
  }

  /// 打开指定网页
  Future<void> openUrl({
    required String url,
  }) {
    assert(url.length <= 10 * 1024);
    return _channel.invokeMethod<void>(
      _METHOD_OPENURL,
      <String, dynamic>{
        _ARGUMENT_KEY_URL: url,
      },
    );
  }

  /// 打开硬件排行榜
  Future<void> openRankList() {
    return _channel.invokeMethod<void>(_METHOD_OPENRANKLIST);
  }

  /// 分享 - 文本
  Future<void> shareText({
    required int scene,
    required String text,
  }) {
    assert(text.length <= 10 * 1024);
    return _channel.invokeMethod<void>(
      _METHOD_SHARETEXT,
      <String, dynamic>{
        _ARGUMENT_KEY_SCENE: scene, // Scene
        _ARGUMENT_KEY_TEXT: text,
      },
    );
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
    assert(title == null || title.length <= 512);
    assert(description == null || description.length <= 1024);
    assert(thumbData == null || thumbData.lengthInBytes <= 32 * 1024);
    assert(
      (imageData != null && imageData.lengthInBytes <= 25 * 1024 * 1024) ||
          (imageUri != null &&
              imageUri.isScheme(_SCHEME_FILE) &&
              imageUri.toFilePath().length <= 10 * 1024 &&
              File.fromUri(imageUri).lengthSync() <= 25 * 1024 * 1024),
    );
    return _channel.invokeMethod<void>(
      _METHOD_SHAREIMAGE,
      <String, dynamic>{
        _ARGUMENT_KEY_SCENE: scene, // Scene
        if (title != null) _ARGUMENT_KEY_TITLE: title,
        if (description != null) _ARGUMENT_KEY_DESCRIPTION: description,
        if (thumbData != null) _ARGUMENT_KEY_THUMBDATA: thumbData,
        if (imageData != null) _ARGUMENT_KEY_IMAGEDATA: imageData,
        if (imageUri != null) _ARGUMENT_KEY_IMAGEURI: imageUri.toString(),
      },
    );
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
    assert(title == null || title.length <= 512);
    assert(description == null || description.length <= 1024);
    assert(thumbData == null || thumbData.lengthInBytes <= 32 * 1024);
    assert(
      (fileData != null && fileData.lengthInBytes <= 10 * 1024 * 1024) ||
          (fileUri != null &&
              fileUri.isScheme(_SCHEME_FILE) &&
              fileUri.toFilePath().length <= 10 * 1024 &&
              File.fromUri(fileUri).lengthSync() <= 10 * 1024 * 1024),
    );
    assert(Platform.isAndroid || (fileExtension?.isNotEmpty ?? false));
    return _channel.invokeMethod<void>(
      _METHOD_SHAREFILE,
      <String, dynamic>{
        _ARGUMENT_KEY_SCENE: scene, // Scene
        if (title != null) _ARGUMENT_KEY_TITLE: title,
        if (description != null) _ARGUMENT_KEY_DESCRIPTION: description,
        if (thumbData != null) _ARGUMENT_KEY_THUMBDATA: thumbData,
        if (fileData != null) _ARGUMENT_KEY_FILEDATA: fileData,
        if (fileUri != null) _ARGUMENT_KEY_FILEURI: fileUri.toString(),
        if (fileExtension != null) _ARGUMENT_KEY_FILEEXTENSION: fileExtension,
      },
    );
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
    assert(title == null || title.length <= 512);
    assert(description == null || description.length <= 1024);
    assert(thumbData.lengthInBytes <= 32 * 1024);
    assert(
      (emojiData != null && emojiData.lengthInBytes <= 10 * 1024 * 1024) ||
          (emojiUri != null &&
              emojiUri.isScheme(_SCHEME_FILE) &&
              emojiUri.toFilePath().length <= 10 * 1024 &&
              File.fromUri(emojiUri).lengthSync() <= 10 * 1024 * 1024),
    );
    return _channel.invokeMethod<void>(
      _METHOD_SHAREEMOJI,
      <String, dynamic>{
        _ARGUMENT_KEY_SCENE: scene, // Scene
        if (title != null) _ARGUMENT_KEY_TITLE: title,
        if (description != null) _ARGUMENT_KEY_DESCRIPTION: description,
        _ARGUMENT_KEY_THUMBDATA: thumbData,
        if (emojiData != null) _ARGUMENT_KEY_EMOJIDATA: emojiData,
        if (emojiUri != null) _ARGUMENT_KEY_EMOJIURI: emojiUri.toString(),
      },
    );
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
    assert(title == null || title.length <= 512);
    assert(description == null || description.length <= 1024);
    assert(thumbData == null || thumbData.lengthInBytes <= 32 * 1024);
    assert(
      (musicUrl != null && musicUrl.length <= 10 * 1024) ||
          (musicLowBandUrl != null && musicLowBandUrl.length <= 10 * 1024),
    );
    return _channel.invokeMethod<void>(
      _METHOD_SHAREMUSIC,
      <String, dynamic>{
        _ARGUMENT_KEY_SCENE: scene, // Scene
        if (title != null) _ARGUMENT_KEY_TITLE: title,
        if (description != null) _ARGUMENT_KEY_DESCRIPTION: description,
        if (thumbData != null) _ARGUMENT_KEY_THUMBDATA: thumbData,
        if (musicUrl != null) _ARGUMENT_KEY_MUSICURL: musicUrl,
        if (musicDataUrl != null) _ARGUMENT_KEY_MUSICDATAURL: musicDataUrl,
        if (musicLowBandUrl != null)
          _ARGUMENT_KEY_MUSICLOWBANDURL: musicLowBandUrl,
        if (musicLowBandDataUrl != null)
          _ARGUMENT_KEY_MUSICLOWBANDDATAURL: musicLowBandDataUrl,
      },
    );
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
    assert(title == null || title.length <= 512);
    assert(description == null || description.length <= 1024);
    assert(thumbData == null || thumbData.lengthInBytes <= 32 * 1024);
    assert(
      (videoUrl != null && videoUrl.length <= 10 * 1024) ||
          (videoLowBandUrl != null && videoLowBandUrl.length <= 10 * 1024),
    );
    return _channel.invokeMethod<void>(
      _METHOD_SHAREVIDEO,
      <String, dynamic>{
        _ARGUMENT_KEY_SCENE: scene, // Scene
        if (title != null) _ARGUMENT_KEY_TITLE: title,
        if (description != null) _ARGUMENT_KEY_DESCRIPTION: description,
        if (thumbData != null) _ARGUMENT_KEY_THUMBDATA: thumbData,
        if (videoUrl != null) _ARGUMENT_KEY_VIDEOURL: videoUrl,
        if (videoLowBandUrl != null)
          _ARGUMENT_KEY_VIDEOLOWBANDURL: videoLowBandUrl,
      },
    );
  }

  /// 分享 - 网页
  Future<void> shareWebpage({
    required int scene,
    String? title,
    String? description,
    Uint8List? thumbData,
    required String webpageUrl,
  }) {
    assert(title == null || title.length <= 512);
    assert(description == null || description.length <= 1024);
    assert(thumbData == null || thumbData.lengthInBytes <= 32 * 1024);
    assert(webpageUrl.length <= 10 * 1024);
    return _channel.invokeMethod<void>(
      _METHOD_SHAREWEBPAGE,
      <String, dynamic>{
        _ARGUMENT_KEY_SCENE: scene, // Scene
        if (title != null) _ARGUMENT_KEY_TITLE: title,
        if (description != null) _ARGUMENT_KEY_DESCRIPTION: description,
        if (thumbData != null) _ARGUMENT_KEY_THUMBDATA: thumbData,
        _ARGUMENT_KEY_WEBPAGEURL: webpageUrl,
      },
    );
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
    int type = WechatMiniProgram.release,
    bool disableForward = false,
  }) {
    assert(scene == WechatScene.SESSION);
    assert(title == null || title.length <= 512);
    assert(description == null || description.length <= 1024);
    assert(thumbData == null || thumbData.lengthInBytes <= 32 * 1024);
    assert(hdImageData == null || hdImageData.lengthInBytes <= 128 * 1024);
    return _channel.invokeMethod<void>(
      _METHOD_SHAREMINIPROGRAM,
      <String, dynamic>{
        _ARGUMENT_KEY_SCENE: scene, // Scene
        if (title != null) _ARGUMENT_KEY_TITLE: title,
        if (description != null) _ARGUMENT_KEY_DESCRIPTION: description,
        if (thumbData != null) _ARGUMENT_KEY_THUMBDATA: thumbData,
        _ARGUMENT_KEY_WEBPAGEURL: webpageUrl,
        _ARGUMENT_KEY_USERNAME: userName,
        if (path != null) _ARGUMENT_KEY_PATH: path,
        if (hdImageData != null) _ARGUMENT_KEY_HDIMAGEDATA: hdImageData,
        _ARGUMENT_KEY_WITHSHARETICKET: withShareTicket,
        _ARGUMENT_KEY_TYPE: type,
        _ARGUMENT_KEY_DISABLEFORWARD: disableForward,
      },
    );
  }

  /// 一次性订阅消息
  Future<void> subscribeMsg({
    required int scene,
    required String templateId,
    String? reserved,
  }) {
    assert(templateId.length <= 1024);
    assert(reserved == null || reserved.length <= 1024);
    return _channel.invokeMethod<void>(
      _METHOD_SUBSCRIBEMSG,
      <String, dynamic>{
        _ARGUMENT_KEY_SCENE: scene,
        _ARGUMENT_KEY_TEMPLATEID: templateId,
        if (reserved != null) _ARGUMENT_KEY_RESERVED: reserved,
      },
    );
  }

  /// 打开小程序
  Future<void> launchMiniProgram({
    required String userName,
    String? path,
    int type = WechatMiniProgram.release,
  }) {
    return _channel.invokeMethod<void>(
      _METHOD_LAUNCHMINIPROGRAM,
      <String, dynamic>{
        _ARGUMENT_KEY_USERNAME: userName,
        if (path != null) _ARGUMENT_KEY_PATH: path,
        _ARGUMENT_KEY_TYPE: type,
      },
    );
  }

  /// 打开微信客服
  Future<void> openCustomerServiceChat({
    required String corpId,
    required String url,
  }) {
    return _channel.invokeMethod<void>(
      _METHOD_OPENCUSTOMERSERVICECHAT,
      <String, dynamic>{
        _ARGUMENT_KEY_CORPID: corpId,
        _ARGUMENT_KEY_URL: url,
      },
    );
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
    return _channel.invokeMethod<void>(
      _METHOD_OPENBUSINESSVIEW,
      <String, dynamic>{
        _ARGUMENT_KEY_BUSINESSTYPE: businessType,
        if (query != null) _ARGUMENT_KEY_QUERY: query,
        if (extInfo != null) _ARGUMENT_KEY_EXTINFO: extInfo,
      },
    );
  }

  /// APP纯签约
  /// * APP纯签约-预签约接口：https://pay.weixin.qq.com/wiki/doc/api/xiaowei.php?chapter=19_5
  /// * APP纯签约-预签约接口：https://pay.weixin.qq.com/wiki/doc/api/pap_jt_v2.php?chapter=19_5&index=2_2
  Future<void> openBusinessWebview({
    required int businessType,
    Map<String, String>? resultInfo,
  }) {
    return _channel.invokeMethod<void>(
      _METHOD_OPENBUSINESSWEBVIEW,
      <String, dynamic>{
        _ARGUMENT_KEY_BUSINESSTYPE: businessType,
        if (resultInfo != null) _ARGUMENT_KEY_QUERYINFO: resultInfo,
      },
    );
  }

  /// 支付 - 不含「iOS 支付」调用会直接抛出异常 No implementation [MissingPluginException]
  /// 参数说明：https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_12&index=2
  ///
  /// # 默认 no_pay，参考 https://github.com/RxReader/wechat_kit/blob/master/example/ios/Podfile
  /// $WechatKitSubspec = 'pay'
  Future<void> pay({
    required String appId,
    required String partnerId,
    required String prepayId,
    required String package,
    required String nonceStr,
    required String timeStamp,
    required String sign,
  }) {
    return _channel.invokeMethod<void>(
      _METHOD_PAY,
      <String, dynamic>{
        _ARGUMENT_KEY_APPID: appId,
        _ARGUMENT_KEY_PARTNERID: partnerId,
        _ARGUMENT_KEY_PREPAYID: prepayId,
        _ARGUMENT_KEY_NONCESTR: nonceStr,
        _ARGUMENT_KEY_TIMESTAMP: timeStamp,
        _ARGUMENT_KEY_PACKAGE: package,
        _ARGUMENT_KEY_SIGN: sign,
      },
    );
  }
}
