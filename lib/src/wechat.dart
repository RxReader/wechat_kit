import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_kit/src/model/api/wechat_access_token_resp.dart';
import 'package:wechat_kit/src/model/api/wechat_ticket_resp.dart';
import 'package:wechat_kit/src/model/api/wechat_user_info_resp.dart';
import 'package:wechat_kit/src/model/qrauth/wechat_qrauth_resp.dart';
import 'package:wechat_kit/src/model/sdk/wechat_auth_resp.dart';
import 'package:wechat_kit/src/model/sdk/wechat_launch_mini_program_resp.dart';
import 'package:wechat_kit/src/model/sdk/wechat_pay_resp.dart';
import 'package:wechat_kit/src/model/sdk/wechat_sdk_resp.dart';
import 'package:wechat_kit/src/model/sdk/wechat_subscribe_msg_resp.dart';
import 'package:wechat_kit/src/wechat_constant.dart';

///
class Wechat {
  ///
  Wechat() {
    _channel.setMethodCallHandler(_handleMethod);
  }

  static const String _METHOD_REGISTERAPP = 'registerApp';
  static const String _METHOD_ISINSTALLED = 'isInstalled';
  static const String _METHOD_ISSUPPORTAPI = 'isSupportApi';
  static const String _METHOD_OPENWECHAT = 'openWechat';
  static const String _METHOD_AUTH = 'auth';
  static const String _METHOD_STARTQRAUTH = 'startQrauth';
  static const String _METHOD_STOPQRAUTH = 'stopQrauth';
  static const String _METHOD_OPENURL = 'openUrl';
  static const String _METHOD_OPENRANKLIST = 'openRankList';
  static const String _METHOD_SHARETEXT = 'shareText';
  static const String _METHOD_SHAREIMAGE = 'shareImage';
  static const String _METHOD_SHAREEMOJI = 'shareEmoji';
  static const String _METHOD_SHAREMUSIC = 'shareMusic';
  static const String _METHOD_SHAREVIDEO = 'shareVideo';
  static const String _METHOD_SHAREWEBPAGE = 'shareWebpage';
  static const String _METHOD_SHAREMINIPROGRAM = 'shareMiniProgram';
  static const String _METHOD_SUBSCRIBEMSG = 'subscribeMsg';
  static const String _METHOD_LAUNCHMINIPROGRAM = 'launchMiniProgram';
  static const String _METHOD_PAY = 'pay';

  static const String _METHOD_ONAUTHRESP = 'onAuthResp';
  static const String _METHOD_ONOPENURLRESP = 'onOpenUrlResp';
  static const String _METHOD_ONSHAREMSGRESP = 'onShareMsgResp';
  static const String _METHOD_ONSUBSCRIBEMSGRESP = 'onSubscribeMsgResp';
  static const String _METHOD_ONLAUNCHMINIPROGRAMRESP =
      'onLaunchMiniProgramResp';
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
  static const String _ARGUMENT_KEY_USERNAME = 'username';
  static const String _ARGUMENT_KEY_SCENE = 'scene';
  static const String _ARGUMENT_KEY_TEXT = 'text';
  static const String _ARGUMENT_KEY_TITLE = 'title';
  static const String _ARGUMENT_KEY_DESCRIPTION = 'description';
  static const String _ARGUMENT_KEY_THUMBDATA = 'thumbData';
  static const String _ARGUMENT_KEY_IMAGEDATA = 'imageData';
  static const String _ARGUMENT_KEY_IMAGEURI = 'imageUri';
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
  static const String _ARGUMENT_KEY_TEMPLATEID = 'templateId';
  static const String _ARGUMENT_KEY_RESERVED = 'reserved';
  static const String _ARGUMENT_KEY_PARTNERID = 'partnerId';
  static const String _ARGUMENT_KEY_PREPAYID = 'prepayId';

//  static const String _ARGUMENT_KEY_NONCESTR = 'noncestr';
//  static const String _ARGUMENT_KEY_TIMESTAMP = 'timestamp';
  static const String _ARGUMENT_KEY_PACKAGE = 'package';
  static const String _ARGUMENT_KEY_SIGN = 'sign';

  static const String _ARGUMENT_KEY_RESULT_IMAGEDATA = 'imageData';

  static const String _SCHEME_FILE = 'file';

  final MethodChannel _channel =
      const MethodChannel('v7lin.github.io/wechat_kit');

  final StreamController<WechatAuthResp> _authRespStreamController =
      StreamController<WechatAuthResp>.broadcast();

  final StreamController<WechatSdkResp> _openUrlRespStreamController =
      StreamController<WechatSdkResp>.broadcast();

  final StreamController<WechatSdkResp> _shareMsgRespStreamController =
      StreamController<WechatSdkResp>.broadcast();

  final StreamController<WechatSubscribeMsgResp>
      _subscribeMsgRespStreamController =
      StreamController<WechatSubscribeMsgResp>.broadcast();

  final StreamController<WechatLaunchMiniProgramResp>
      _launchMiniProgramRespStreamController =
      StreamController<WechatLaunchMiniProgramResp>.broadcast();

  final StreamController<WechatPayResp> _payRespStreamController =
      StreamController<WechatPayResp>.broadcast();

  final StreamController<Uint8List> _authGotQrcodeRespStreamController =
      StreamController<Uint8List>.broadcast();

  final StreamController<String> _authQrcodeScannedRespStreamController =
      StreamController<String>.broadcast();

  final StreamController<WechatQrauthResp> _authFinishRespStreamController =
      StreamController<WechatQrauthResp>.broadcast();

  /// 向微信注册应用
  Future<void> registerApp({
    @required String appId,
    @required String universalLink,
  }) {
    assert(appId != null && appId.isNotEmpty);
    assert(
        !Platform.isIOS || (universalLink != null && universalLink.isNotEmpty));
    return _channel.invokeMethod(
      _METHOD_REGISTERAPP,
      <String, dynamic>{
        _ARGUMENT_KEY_APPID: appId,
        _ARGUMENT_KEY_UNIVERSALLINK: universalLink,
      },
    );
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case _METHOD_ONAUTHRESP:
        _authRespStreamController.add(
            WechatAuthResp.fromJson(call.arguments as Map<dynamic, dynamic>));
        break;
      case _METHOD_ONOPENURLRESP:
        _openUrlRespStreamController.add(
            WechatSdkResp.fromJson(call.arguments as Map<dynamic, dynamic>));
        break;
      case _METHOD_ONSHAREMSGRESP:
        _shareMsgRespStreamController.add(
            WechatSdkResp.fromJson(call.arguments as Map<dynamic, dynamic>));
        break;
      case _METHOD_ONSUBSCRIBEMSGRESP:
        _subscribeMsgRespStreamController.add(WechatSubscribeMsgResp.fromJson(
            call.arguments as Map<dynamic, dynamic>));
        break;
      case _METHOD_ONLAUNCHMINIPROGRAMRESP:
        _launchMiniProgramRespStreamController.add(
            WechatLaunchMiniProgramResp.fromJson(
                call.arguments as Map<dynamic, dynamic>));
        break;
      case _METHOD_ONPAYRESP:
        _payRespStreamController.add(
            WechatPayResp.fromJson(call.arguments as Map<dynamic, dynamic>));
        break;
      case _METHOD_ONAUTHGOTQRCODE:
        _authGotQrcodeRespStreamController
            .add(call.arguments[_ARGUMENT_KEY_RESULT_IMAGEDATA] as Uint8List);
        break;
      case _METHOD_ONAUTHQRCODESCANNED:
        _authQrcodeScannedRespStreamController.add('QrcodeScanned');
        break;
      case _METHOD_ONAUTHFINISH:
        _authFinishRespStreamController.add(
            WechatQrauthResp.fromJson(call.arguments as Map<dynamic, dynamic>));
        break;
    }
  }

  /// 登录
  Stream<WechatAuthResp> authResp() {
    return _authRespStreamController.stream;
  }

  /// 打开浏览器
  Stream<WechatSdkResp> openUrlResp() {
    return _openUrlRespStreamController.stream;
  }

  /// 分享
  Stream<WechatSdkResp> shareMsgResp() {
    return _shareMsgRespStreamController.stream;
  }

  /// 一次性订阅消息
  Stream<WechatSubscribeMsgResp> subscribeMsgResp() {
    return _subscribeMsgRespStreamController.stream;
  }

  /// 打开小程序
  Stream<WechatLaunchMiniProgramResp> launchMiniProgramResp() {
    return _launchMiniProgramRespStreamController.stream;
  }

  /// 支付
  Stream<WechatPayResp> payResp() {
    return _payRespStreamController.stream;
  }

  /// 扫码登录 - 获取二维码
  Stream<Uint8List> authGotQrcodeResp() {
    return _authGotQrcodeRespStreamController.stream;
  }

  /// 扫码登录 - 用户扫描二维码
  Stream<String> authQrcodeScannedResp() {
    return _authQrcodeScannedRespStreamController.stream;
  }

  /// 扫码登录 - 用户点击授权
  Stream<WechatQrauthResp> authFinishResp() {
    return _authFinishRespStreamController.stream;
  }

  /// 检测微信是否已安装
  Future<bool> isInstalled() {
    return _channel.invokeMethod(_METHOD_ISINSTALLED);
  }

  /// 判断当前微信的版本是否支持OpenApi
  Future<bool> isSupportApi() {
    return _channel.invokeMethod(_METHOD_ISSUPPORTAPI);
  }

  /// 打开微信
  Future<bool> openWechat() {
    return _channel.invokeMethod(_METHOD_OPENWECHAT);
  }

  // --- 微信APP授权登录

  /// 授权登录
  Future<void> auth({
    @required List<String> scope,
    String state,
  }) {
    assert(scope != null && scope.isNotEmpty);
    Map<String, dynamic> arguments = <String, dynamic>{
      _ARGUMENT_KEY_SCOPE: scope.join(','), // Scope
//      _ARGUMENT_KEY_STATE: state,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (state != null) {
      arguments[_ARGUMENT_KEY_STATE] = state;
    }
    return _channel.invokeMethod(_METHOD_AUTH, arguments);
  }

  /// 获取 access_token（UnionID）
  Future<WechatAccessTokenResp> getAccessTokenUnionID({
    @required String appId,
    @required String appSecret,
    @required String code,
  }) {
    assert(appId != null && appId.isNotEmpty);
    assert(appSecret != null && appSecret.isNotEmpty);
    assert(code != null && code.isNotEmpty);
    return HttpClient()
        .getUrl(Uri.parse(
            'https://api.weixin.qq.com/sns/oauth2/access_token?appid=$appId&secret=$appSecret&code=$code&grant_type=authorization_code'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) async {
      if (response.statusCode == HttpStatus.ok) {
        String content = await utf8.decodeStream(response);
        return WechatAccessTokenResp.fromJson(
            json.decode(content) as Map<dynamic, dynamic>);
      }
      throw HttpException(
          'HttpResponse statusCode: ${response.statusCode}, reasonPhrase: ${response.reasonPhrase}.');
    });
  }

  /// 刷新或续期 access_token 使用（UnionID）
  Future<WechatAccessTokenResp> refreshAccessTokenUnionID({
    @required String appId,
    @required String refreshToken,
  }) {
    assert(appId != null && appId.isNotEmpty);
    assert(refreshToken != null && refreshToken.isNotEmpty);
    return HttpClient()
        .getUrl(Uri.parse(
            'https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=$appId&grant_type=refresh_token&refresh_token=$refreshToken'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) async {
      if (response.statusCode == HttpStatus.ok) {
        String content = await utf8.decodeStream(response);
        return WechatAccessTokenResp.fromJson(
            json.decode(content) as Map<dynamic, dynamic>);
      }
      throw HttpException(
          'HttpResponse statusCode: ${response.statusCode}, reasonPhrase: ${response.reasonPhrase}.');
    });
  }

  /// 获取用户个人信息（UnionID）
  Future<WechatUserInfoResp> getUserInfoUnionID({
    @required String openId,
    @required String accessToken,
  }) {
    assert(openId != null && openId.isNotEmpty);
    assert(accessToken != null && accessToken.isNotEmpty);
    return HttpClient()
        .getUrl(Uri.parse(
            'https://api.weixin.qq.com/sns/userinfo?access_token=$accessToken&openid=$openId'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) async {
      if (response.statusCode == HttpStatus.ok) {
        String content = await utf8.decodeStream(response);
        return WechatUserInfoResp.fromJson(
            json.decode(content) as Map<dynamic, dynamic>);
      }
      throw HttpException(
          'HttpResponse statusCode: ${response.statusCode}, reasonPhrase: ${response.reasonPhrase}.');
    });
  }

  // --- 微信APP扫码登录

  /// 获取 access_token
  Future<WechatAccessTokenResp> getAccessToken({
    @required String appId,
    @required String appSecret,
  }) {
    assert(appId != null && appId.isNotEmpty);
    assert(appSecret != null && appSecret.isNotEmpty);
    return HttpClient()
        .getUrl(Uri.parse(
            'https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=$appId&secret=$appSecret'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) async {
      if (response.statusCode == HttpStatus.ok) {
        String content = await utf8.decodeStream(response);
        return WechatAccessTokenResp.fromJson(
            json.decode(content) as Map<dynamic, dynamic>);
      }
      throw HttpException(
          'HttpResponse statusCode: ${response.statusCode}, reasonPhrase: ${response.reasonPhrase}.');
    });
  }

  /// 用上面的函数拿到的 access_token，获取 sdk_ticket
  Future<WechatTicketResp> getTicket({
    @required String accessToken,
  }) {
    assert(accessToken != null && accessToken.isNotEmpty);
    return HttpClient()
        .getUrl(Uri.parse(
            'https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=$accessToken&type=2'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) async {
      if (response.statusCode == HttpStatus.ok) {
        String content = await utf8.decodeStream(response);
        return WechatTicketResp.fromJson(
            json.decode(content) as Map<dynamic, dynamic>);
      }
      throw HttpException(
          'HttpResponse statusCode: ${response.statusCode}, reasonPhrase: ${response.reasonPhrase}.');
    });
  }

  /// 用上面函数拿到的 ticket，开始扫码登录
  Future<void> startQrauth({
    @required String appId,
    @required String scope,
    @required String ticket,
  }) {
    assert(appId != null && appId.isNotEmpty);
    assert(scope != null && scope.isNotEmpty);
    assert(ticket != null && ticket.isNotEmpty);
    String noncestr = Uuid().v1().toString().replaceAll('-', '');
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String content =
        'appid=$appId&noncestr=$noncestr&sdk_ticket=$ticket&timestamp=$timestamp';
    String signature = hex.encode(sha1.convert(utf8.encode(content)).bytes);
    return _channel.invokeMethod(
      _METHOD_STARTQRAUTH,
      <String, dynamic>{
        _ARGUMENT_KEY_APPID: appId,
        _ARGUMENT_KEY_SCOPE: scope, // Scope
        _ARGUMENT_KEY_NONCESTR: noncestr,
        _ARGUMENT_KEY_TIMESTAMP: timestamp,
        _ARGUMENT_KEY_SIGNATURE: signature,
      },
    );
  }

  /// 暂停扫码登录请求
  Future<void> stopQrauth() {
    return _channel.invokeMethod(_METHOD_STOPQRAUTH);
  }

  /// 打开指定网页
  Future<void> openUrl({
    @required String url,
  }) {
    assert(url != null && url.isNotEmpty && url.length <= 10 * 1024);
    return _channel.invokeMethod(
      _METHOD_OPENURL,
      <String, dynamic>{
        _ARGUMENT_KEY_URL: url,
      },
    );
  }

  /// 打开硬件排行榜
  Future<void> openRankList() {
    return _channel.invokeMethod(_METHOD_OPENRANKLIST);
  }

  /// 分享 - 文本
  Future<void> shareText({
    @required int scene,
    @required String text,
  }) {
    assert(text != null && text.isNotEmpty && text.length <= 10 * 1024);
    return _channel.invokeMethod(
      _METHOD_SHARETEXT,
      <String, dynamic>{
        _ARGUMENT_KEY_SCENE: scene, // Scene
        _ARGUMENT_KEY_TEXT: text,
      },
    );
  }

  /// 分享 - 图片
  Future<void> shareImage({
    @required int scene,
    String title,
    String description,
    Uint8List thumbData,
    Uint8List imageData,
    Uri imageUri,
  }) {
    assert(title == null || title.length <= 512);
    assert(description == null || description.length <= 1024);
    assert(thumbData == null || thumbData.lengthInBytes <= 32 * 1024);
    assert((imageData != null && imageData.lengthInBytes <= 25 * 1024 * 1024) ||
        (imageUri != null &&
            imageUri.isScheme(_SCHEME_FILE) &&
            imageUri.toFilePath().length <= 10 * 1024 &&
            File.fromUri(imageUri).lengthSync() <= 25 * 1024 * 1024));
    Map<String, dynamic> arguments = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene, // Scene
//      _ARGUMENT_KEY_TITLE: title,
//      _ARGUMENT_KEY_DESCRIPTION: description,
//      _ARGUMENT_KEY_THUMBDATA: thumbData,
//      _ARGUMENT_KEY_IMAGEDATA: imageData
//      _ARGUMENT_KEY_IMAGEURI: imageUri.toString(),
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (title != null) {
      arguments[_ARGUMENT_KEY_TITLE] = title;
    }
    if (description != null) {
      arguments[_ARGUMENT_KEY_DESCRIPTION] = description;
    }
    if (thumbData != null) {
      arguments[_ARGUMENT_KEY_THUMBDATA] = thumbData;
    }
    if (imageData != null) {
      arguments[_ARGUMENT_KEY_IMAGEDATA] = imageData;
    }
    if (imageUri != null) {
      arguments[_ARGUMENT_KEY_IMAGEURI] = imageUri.toString();
    }
    return _channel.invokeMethod(_METHOD_SHAREIMAGE, arguments);
  }

  /// 分享 - Emoji/GIF
  Future<void> shareEmoji({
    @required int scene,
    String title,
    String description,
    @required Uint8List thumbData,
    Uint8List emojiData,
    Uri emojiUri,
  }) {
    assert(title == null || title.length <= 512);
    assert(description == null || description.length <= 1024);
    assert(thumbData != null && thumbData.lengthInBytes <= 32 * 1024);
    assert((emojiData != null && emojiData.lengthInBytes <= 10 * 1024 * 1024) ||
        (emojiUri != null &&
            emojiUri.isScheme(_SCHEME_FILE) &&
            emojiUri.toFilePath().length <= 10 * 1024 &&
            File.fromUri(emojiUri).lengthSync() <= 10 * 1024 * 1024));
    Map<String, dynamic> arguments = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene, // Scene
//      _ARGUMENT_KEY_TITLE: title,
//      _ARGUMENT_KEY_DESCRIPTION: description,
      _ARGUMENT_KEY_THUMBDATA: thumbData,
//      _ARGUMENT_KEY_EMOJIDATA: emojiData,
//      _ARGUMENT_KEY_EMOJIURI: emojiUri.toString(),
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (title != null) {
      arguments[_ARGUMENT_KEY_TITLE] = title;
    }
    if (description != null) {
      arguments[_ARGUMENT_KEY_DESCRIPTION] = description;
    }
    if (emojiData != null) {
      arguments[_ARGUMENT_KEY_EMOJIDATA] = emojiData;
    }
    if (emojiUri != null) {
      arguments[_ARGUMENT_KEY_EMOJIURI] = emojiUri.toString();
    }
    return _channel.invokeMethod(_METHOD_SHAREEMOJI, arguments);
  }

  /// 分享 - 音乐
  Future<void> shareMediaMusic({
    @required int scene,
    String title,
    String description,
    Uint8List thumbData,
    String musicUrl,
    String musicDataUrl,
    String musicLowBandUrl,
    String musicLowBandDataUrl,
  }) {
    assert(title == null || title.length <= 512);
    assert(description == null || description.length <= 1024);
    assert(thumbData == null || thumbData.lengthInBytes <= 32 * 1024);
    assert((musicUrl != null &&
            musicUrl.isNotEmpty &&
            musicUrl.length <= 10 * 1024) ||
        (musicLowBandUrl != null &&
            musicLowBandUrl.isNotEmpty &&
            musicLowBandUrl.length <= 10 * 1024));
    Map<String, dynamic> arguments = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene, // Scene
//      _ARGUMENT_KEY_TITLE: title,
//      _ARGUMENT_KEY_DESCRIPTION: description,
//      _ARGUMENT_KEY_THUMBDATA: thumbData,
//      _ARGUMENT_KEY_MUSICURL: musicUrl,
//      _ARGUMENT_KEY_MUSICDATAURL: musicDataUrl,
//      _ARGUMENT_KEY_MUSICLOWBANDURL: musicLowBandUrl,
//      _ARGUMENT_KEY_MUSICLOWBANDDATAURL: musicLowBandDataUrl,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (title != null) {
      arguments[_ARGUMENT_KEY_TITLE] = title;
    }
    if (description != null) {
      arguments[_ARGUMENT_KEY_DESCRIPTION] = description;
    }
    if (thumbData != null) {
      arguments[_ARGUMENT_KEY_THUMBDATA] = thumbData;
    }
    if (musicUrl != null) {
      arguments[_ARGUMENT_KEY_MUSICURL] = musicUrl;
    }
    if (musicDataUrl != null) {
      arguments[_ARGUMENT_KEY_MUSICDATAURL] = musicDataUrl;
    }
    if (musicLowBandUrl != null) {
      arguments[_ARGUMENT_KEY_MUSICLOWBANDURL] = musicLowBandUrl;
    }
    if (musicLowBandDataUrl != null) {
      arguments[_ARGUMENT_KEY_MUSICLOWBANDDATAURL] = musicLowBandDataUrl;
    }
    return _channel.invokeMethod(_METHOD_SHAREMUSIC, arguments);
  }

  /// 分享 - 视频
  Future<void> shareVideo({
    @required int scene,
    String title,
    String description,
    Uint8List thumbData,
    String videoUrl,
    String videoLowBandUrl,
  }) {
    assert(title == null || title.length <= 512);
    assert(description == null || description.length <= 1024);
    assert(thumbData == null || thumbData.lengthInBytes <= 32 * 1024);
    assert((videoUrl != null &&
            videoUrl.isNotEmpty &&
            videoUrl.length <= 10 * 1024) ||
        (videoLowBandUrl != null &&
            videoLowBandUrl.isNotEmpty &&
            videoLowBandUrl.length <= 10 * 1024));
    Map<String, dynamic> arguments = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene, // Scene
//      _ARGUMENT_KEY_TITLE: title,
//      _ARGUMENT_KEY_DESCRIPTION: description,
//      _ARGUMENT_KEY_THUMBDATA: thumbData,
//      _ARGUMENT_KEY_VIDEOURL: videoUrl,
//      _ARGUMENT_KEY_VIDEOLOWBANDURL: videoLowBandUrl,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (title != null) {
      arguments[_ARGUMENT_KEY_TITLE] = title;
    }
    if (description != null) {
      arguments[_ARGUMENT_KEY_DESCRIPTION] = description;
    }
    if (thumbData != null) {
      arguments[_ARGUMENT_KEY_THUMBDATA] = thumbData;
    }
    if (videoUrl != null) {
      arguments[_ARGUMENT_KEY_VIDEOURL] = videoUrl;
    }
    if (videoLowBandUrl != null) {
      arguments[_ARGUMENT_KEY_VIDEOLOWBANDURL] = videoLowBandUrl;
    }
    return _channel.invokeMethod(_METHOD_SHAREVIDEO, arguments);
  }

  /// 分享 - 网页
  Future<void> shareWebpage({
    @required int scene,
    String title,
    String description,
    Uint8List thumbData,
    @required String webpageUrl,
  }) {
    assert(title == null || title.length <= 512);
    assert(description == null || description.length <= 1024);
    assert(thumbData == null || thumbData.lengthInBytes <= 32 * 1024);
    assert(webpageUrl != null &&
        webpageUrl.isNotEmpty &&
        webpageUrl.length <= 10 * 1024);
    Map<String, dynamic> arguments = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene, // Scene
//      _ARGUMENT_KEY_TITLE: title,
//      _ARGUMENT_KEY_DESCRIPTION: description,
//      _ARGUMENT_KEY_THUMBDATA: thumbData,
      _ARGUMENT_KEY_WEBPAGEURL: webpageUrl,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (title != null) {
      arguments[_ARGUMENT_KEY_TITLE] = title;
    }
    if (description != null) {
      arguments[_ARGUMENT_KEY_DESCRIPTION] = description;
    }
    if (thumbData != null) {
      arguments[_ARGUMENT_KEY_THUMBDATA] = thumbData;
    }
    return _channel.invokeMethod(_METHOD_SHAREWEBPAGE, arguments);
  }

  /// 分享 - 小程序 - 目前只支持分享到会话
  Future<void> shareMiniProgram({
    @required int scene,
    String title,
    String description,
    Uint8List thumbData,
    @required String webpageUrl,
    @required String userName,
    String path,
    Uint8List hdImageData,
    bool withShareTicket = false,
  }) {
    assert(scene == WechatScene.SESSION);
    assert(title == null || title.length <= 512);
    assert(description == null || description.length <= 1024);
    assert(thumbData == null || thumbData.lengthInBytes <= 32 * 1024);
    assert(webpageUrl != null && webpageUrl.isNotEmpty);
    assert(userName != null && userName.isNotEmpty);
    assert(hdImageData == null || hdImageData.lengthInBytes <= 128 * 1024);
    Map<String, dynamic> arguments = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene, // Scene
//      _ARGUMENT_KEY_TITLE: title,
//      _ARGUMENT_KEY_DESCRIPTION: description,
//      _ARGUMENT_KEY_THUMBDATA: thumbData,
      _ARGUMENT_KEY_WEBPAGEURL: webpageUrl,
      _ARGUMENT_KEY_USERNAME: userName,
//      _ARGUMENT_KEY_PATH: path,
//      _ARGUMENT_KEY_HDIMAGEDATA: hdImageData,
      _ARGUMENT_KEY_WITHSHARETICKET: withShareTicket,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (title != null) {
      arguments[_ARGUMENT_KEY_TITLE] = title;
    }
    if (description != null) {
      arguments[_ARGUMENT_KEY_DESCRIPTION] = description;
    }
    if (thumbData != null) {
      arguments[_ARGUMENT_KEY_THUMBDATA] = thumbData;
    }
    if (path != null) {
      arguments[_ARGUMENT_KEY_PATH] = path;
    }
    if (hdImageData != null) {
      arguments[_ARGUMENT_KEY_HDIMAGEDATA] = hdImageData;
    }
    return _channel.invokeMethod(_METHOD_SHAREMINIPROGRAM, arguments);
  }

  /// 一次性订阅消息
  Future<void> subscribeMsg({
    @required int scene,
    @required String templateId,
    String reserved,
  }) {
    assert(templateId != null &&
        templateId.isNotEmpty &&
        templateId.length <= 1024);
    assert(reserved == null || reserved.length <= 1024);
    Map<String, dynamic> arguments = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene,
      _ARGUMENT_KEY_TEMPLATEID: templateId,
//      _ARGUMENT_KEY_RESERVED: reserved,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (reserved != null) {
      arguments[_ARGUMENT_KEY_RESERVED] = reserved;
    }
    return _channel.invokeMethod(_METHOD_SUBSCRIBEMSG, arguments);
  }

  /// 打开小程序
  Future<void> launchMiniProgram({
    @required String userName,
    String path,
  }) {
    assert(userName != null && userName.isNotEmpty);
    Map<String, dynamic> arguments = <String, dynamic>{
      _ARGUMENT_KEY_USERNAME: userName,
//      _ARGUMENT_KEY_PATH: path,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (path != null) {
      arguments[_ARGUMENT_KEY_PATH] = path;
    }
    return _channel.invokeMethod(_METHOD_LAUNCHMINIPROGRAM, arguments);
  }

  /// 支付
  /// 参数说明：https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_12&index=2
  Future<void> pay({
    @required String appId,
    @required String partnerId,
    @required String prepayId,
    @required String package,
    @required String nonceStr,
    @required String timeStamp,
    @required String sign,
  }) {
    assert(appId != null && appId.isNotEmpty);
    assert(partnerId != null && partnerId.isNotEmpty);
    assert(prepayId != null && prepayId.isNotEmpty);
    assert(package != null && package.isNotEmpty);
    assert(nonceStr != null && nonceStr.isNotEmpty);
    assert(timeStamp != null && timeStamp.isNotEmpty);
    assert(sign != null && sign.isNotEmpty);
    return _channel.invokeMethod(
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
