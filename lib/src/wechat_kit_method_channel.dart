import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:wechat_kit/src/constant.dart';
import 'package:wechat_kit/src/model/qrauth.dart';
import 'package:wechat_kit/src/model/req.dart';
import 'package:wechat_kit/src/model/resp.dart';
import 'package:wechat_kit/src/wechat_kit_platform_interface.dart';

/// An implementation of [WechatKitPlatform] that uses method channels.
class MethodChannelWechatKit extends WechatKitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  late final MethodChannel methodChannel =
      const MethodChannel('v7lin.github.io/wechat_kit')
        ..setMethodCallHandler(_handleMethod);

  final StreamController<WechatReq> _reqStreamController =
      StreamController<WechatReq>.broadcast();

  final StreamController<WechatResp> _respStreamController =
      StreamController<WechatResp>.broadcast();

  final StreamController<WechatQrauthResp> _qrauthRespStreamController =
      StreamController<WechatQrauthResp>.broadcast();

  Future<dynamic> _handleMethod(MethodCall call) async {
    // 优先处理不需要参数的请求
    if (call.method == 'onAuthQrcodeScanned') {
      _qrauthRespStreamController.add(WechatQrcodeScannedResp());
      return;
    }

    final Map<String, dynamic> data =
        (call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>();

    switch (call.method) {
      // onReq
      case 'onLaunchFromWXReq':
        _reqStreamController.add(WechatLaunchFromWXReq.fromJson(data));
        break;
      case 'onShowMessageFromWXReq':
        _reqStreamController.add(WechatShowMessageFromWXReq.fromJson(data));
        break;
      // onResp
      case 'onAuthResp':
        _respStreamController.add(WechatAuthResp.fromJson(data));
        break;
      case 'onOpenUrlResp':
        _respStreamController.add(WechatOpenUrlResp.fromJson(data));
        break;
      case 'onShareMsgResp':
        _respStreamController.add(WechatShareMsgResp.fromJson(data));
        break;
      case 'onSubscribeMsgResp':
        _respStreamController.add(WechatSubscribeMsgResp.fromJson(data));
        break;
      case 'onLaunchMiniProgramResp':
        _respStreamController.add(WechatLaunchMiniProgramResp.fromJson(data));
        break;
      case 'onOpenCustomerServiceChatResp':
        _respStreamController
            .add(WechatOpenCustomerServiceChatResp.fromJson(data));
        break;
      case 'onOpenBusinessViewResp':
        _respStreamController.add(WechatOpenBusinessViewResp.fromJson(data));
        break;
      case 'onOpenBusinessWebviewResp':
        _respStreamController.add(WechatOpenBusinessWebviewResp.fromJson(data));
        break;
      case 'onPayResp':
        _respStreamController.add(WechatPayResp.fromJson(data));
        break;
      // onQrauth
      case 'onAuthGotQrcode':
        _qrauthRespStreamController.add(WechatGotQrcodeResp.fromJson(data));
        break;
      case 'onAuthFinish':
        _qrauthRespStreamController.add(WechatFinishResp.fromJson(data));
        break;
    }
  }

  @override
  Future<void> registerApp({
    required String appId,
    required String? universalLink,
  }) {
    assert(!Platform.isIOS || (universalLink?.isNotEmpty ?? false));
    return methodChannel.invokeMethod<void>(
      'registerApp',
      <String, dynamic>{
        'appId': appId,
        'universalLink': universalLink,
      },
    );
  }

  @override
  Stream<WechatReq> reqStream() {
    return _reqStreamController.stream;
  }

  @override
  Stream<WechatResp> respStream() {
    return _respStreamController.stream;
  }

  @override
  Stream<WechatQrauthResp> qrauthRespStream() {
    return _qrauthRespStreamController.stream;
  }

  @override
  Future<void> handleInitialWXReq() {
    return methodChannel.invokeMethod<void>('handleInitialWXReq');
  }

  @override
  Future<bool> isInstalled() async {
    return await methodChannel.invokeMethod<bool>('isInstalled') ?? false;
  }

  @override
  Future<bool> isSupportApi() async {
    return await methodChannel.invokeMethod<bool>('isSupportApi') ?? false;
  }

  @override
  Future<bool> isSupportStateApi() async {
    return await methodChannel.invokeMethod<bool>('isSupportStateApi') ?? false;
  }

  @override
  Future<bool> openWechat() async {
    return await methodChannel.invokeMethod<bool>('openWechat') ?? false;
  }

  // --- 微信APP授权登录

  @override
  Future<void> auth({
    required List<String> scope,
    String? state,
    int type = WechatAuthType.kNormal,
  }) {
    assert((Platform.isAndroid && type == WechatAuthType.kNormal) ||
        (Platform.isIOS &&
            <int>[WechatAuthType.kNormal, WechatAuthType.kWeb].contains(type)));
    return methodChannel.invokeMethod<void>('auth', <String, dynamic>{
      'scope': scope.join(','), // Scope
      if (state != null) 'state': state,
      'type': type,
    });
  }

  // --- 微信APP扫码登录

  @override
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
    return methodChannel.invokeMethod<void>(
      'startQrauth',
      <String, dynamic>{
        'appId': appId,
        'scope': scope.join(','), // Scope
        'noncestr': noncestr,
        'timestamp': timestamp,
        'signature': signature,
      },
    );
  }

  @override
  Future<void> stopQrauth() {
    return methodChannel.invokeMethod<void>('stopQrauth');
  }

  //

  @override
  Future<void> openUrl({
    required String url,
  }) {
    assert(url.length <= 10 * 1024);
    return methodChannel.invokeMethod<void>(
      'openUrl',
      <String, dynamic>{
        'url': url,
      },
    );
  }

  @override
  Future<void> openRankList() {
    return methodChannel.invokeMethod<void>('openRankList');
  }

  @override
  Future<void> shareText({
    required int scene,
    required String text,
  }) {
    assert(text.length <= 10 * 1024);
    return methodChannel.invokeMethod<void>(
      'shareText',
      <String, dynamic>{
        'scene': scene, // Scene
        'text': text,
      },
    );
  }

  @override
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
              imageUri.isScheme('file') &&
              imageUri.toFilePath().length <= 10 * 1024 &&
              File.fromUri(imageUri).lengthSync() <= 25 * 1024 * 1024),
    );
    return methodChannel.invokeMethod<void>(
      'shareImage',
      <String, dynamic>{
        'scene': scene, // Scene
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (thumbData != null) 'thumbData': thumbData,
        if (imageData != null) 'imageData': imageData,
        if (imageUri != null) 'imageUri': imageUri.toString(),
      },
    );
  }

  @override
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
              fileUri.isScheme('file') &&
              fileUri.toFilePath().length <= 10 * 1024 &&
              File.fromUri(fileUri).lengthSync() <= 10 * 1024 * 1024),
    );
    assert(Platform.isAndroid || (fileExtension?.isNotEmpty ?? false));
    return methodChannel.invokeMethod<void>(
      'shareFile',
      <String, dynamic>{
        'scene': scene, // Scene
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (thumbData != null) 'thumbData': thumbData,
        if (fileData != null) 'fileData': fileData,
        if (fileUri != null) 'fileUri': fileUri.toString(),
        if (fileExtension != null) 'fileExtension': fileExtension,
      },
    );
  }

  @override
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
              emojiUri.isScheme('file') &&
              emojiUri.toFilePath().length <= 10 * 1024 &&
              File.fromUri(emojiUri).lengthSync() <= 10 * 1024 * 1024),
    );
    return methodChannel.invokeMethod<void>(
      'shareEmoji',
      <String, dynamic>{
        'scene': scene, // Scene
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        'thumbData': thumbData,
        if (emojiData != null) 'emojiData': emojiData,
        if (emojiUri != null) 'emojiUri': emojiUri.toString(),
      },
    );
  }

  @override
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
    return methodChannel.invokeMethod<void>(
      'shareMusic',
      <String, dynamic>{
        'scene': scene, // Scene
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (thumbData != null) 'thumbData': thumbData,
        if (musicUrl != null) 'musicUrl': musicUrl,
        if (musicDataUrl != null) 'musicDataUrl': musicDataUrl,
        if (musicLowBandUrl != null) 'musicLowBandUrl': musicLowBandUrl,
        if (musicLowBandDataUrl != null)
          'musicLowBandDataUrl': musicLowBandDataUrl,
      },
    );
  }

  @override
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
    return methodChannel.invokeMethod<void>(
      'shareVideo',
      <String, dynamic>{
        'scene': scene, // Scene
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (thumbData != null) 'thumbData': thumbData,
        if (videoUrl != null) 'videoUrl': videoUrl,
        if (videoLowBandUrl != null) 'videoLowBandUrl': videoLowBandUrl,
      },
    );
  }

  @override
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
    return methodChannel.invokeMethod<void>(
      'shareWebpage',
      <String, dynamic>{
        'scene': scene, // Scene
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (thumbData != null) 'thumbData': thumbData,
        'webpageUrl': webpageUrl,
      },
    );
  }

  @override
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
    int type = WechatMiniProgram.kRelease,
    bool disableForward = false,
  }) {
    assert(scene == WechatScene.kSession);
    assert(title == null || title.length <= 512);
    assert(description == null || description.length <= 1024);
    assert(thumbData == null || thumbData.lengthInBytes <= 32 * 1024);
    assert(hdImageData == null || hdImageData.lengthInBytes <= 128 * 1024);
    return methodChannel.invokeMethod<void>(
      'shareMiniProgram',
      <String, dynamic>{
        'scene': scene, // Scene
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (thumbData != null) 'thumbData': thumbData,
        'webpageUrl': webpageUrl,
        'username': userName,
        if (path != null) 'path': path,
        if (hdImageData != null) 'hdImageData': hdImageData,
        'withShareTicket': withShareTicket,
        'type': type,
        'disableForward': disableForward,
      },
    );
  }

  @override
  Future<void> subscribeMsg({
    required int scene,
    required String templateId,
    String? reserved,
  }) {
    assert(templateId.length <= 1024);
    assert(reserved == null || reserved.length <= 1024);
    return methodChannel.invokeMethod<void>(
      'subscribeMsg',
      <String, dynamic>{
        'scene': scene,
        'templateId': templateId,
        if (reserved != null) 'reserved': reserved,
      },
    );
  }

  @override
  Future<void> launchMiniProgram({
    required String userName,
    String? path,
    int type = WechatMiniProgram.kRelease,
  }) {
    return methodChannel.invokeMethod<void>(
      'launchMiniProgram',
      <String, dynamic>{
        'username': userName,
        if (path != null) 'path': path,
        'type': type,
      },
    );
  }

  @override
  Future<void> openCustomerServiceChat({
    required String corpId,
    required String url,
  }) {
    return methodChannel.invokeMethod<void>(
      'openCustomerServiceChat',
      <String, dynamic>{
        'corpId': corpId,
        'url': url,
      },
    );
  }

  @override
  Future<void> openBusinessView({
    required String businessType,
    String? query,
    String? extInfo,
  }) {
    return methodChannel.invokeMethod<void>(
      'openBusinessView',
      <String, dynamic>{
        'businessType': businessType,
        if (query != null) 'query': query,
        if (extInfo != null) 'extInfo': extInfo,
      },
    );
  }

  @override
  Future<void> openBusinessWebview({
    required int businessType,
    Map<String, String>? resultInfo,
  }) {
    return methodChannel.invokeMethod<void>(
      'openBusinessWebview',
      <String, dynamic>{
        'businessType': businessType,
        if (resultInfo != null) 'queryInfo': resultInfo,
      },
    );
  }

  @override
  Future<void> pay({
    required String appId,
    required String partnerId,
    required String prepayId,
    required String package,
    required String nonceStr,
    required String timeStamp,
    required String sign,
  }) {
    return methodChannel.invokeMethod<void>(
      'pay',
      <String, dynamic>{
        'appId': appId,
        'partnerId': partnerId,
        'prepayId': prepayId,
        'noncestr': nonceStr,
        'timestamp': timeStamp,
        'package': package,
        'sign': sign,
      },
    );
  }
}
