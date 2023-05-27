import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:wechat_kit/src/constant.dart';
import 'package:wechat_kit/src/model/qrauth.dart';
import 'package:wechat_kit/src/model/req.dart';
import 'package:wechat_kit/src/model/resp.dart';
import 'package:wechat_kit/src/wechat_kit_method_channel.dart';
import 'package:wechat_kit/src/wechat_kit_platform_interface.dart';

class MockWechatKitPlatform
    with MockPlatformInterfaceMixin
    implements WechatKitPlatform {
  @override
  Future<void> registerApp({
    required String appId,
    required String? universalLink,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<WechatReq> reqStream() {
    throw UnimplementedError();
  }

  @override
  Stream<WechatResp> respStream() {
    throw UnimplementedError();
  }

  @override
  Stream<WechatQrauthResp> qrauthRespStream() {
    throw UnimplementedError();
  }

  @override
  Future<void> handleInitialWXReq() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isInstalled() {
    return Future<bool>.value(true);
  }

  @override
  Future<bool> isSupportApi() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isSupportStateApi() {
    throw UnimplementedError();
  }

  @override
  Future<bool> openWechat() {
    throw UnimplementedError();
  }

  // --- 微信APP授权登录

  @override
  Future<bool?> auth({
    required List<String> scope,
    String? state,
    int type = WechatAuthType.kNormal,
  }) {
    throw UnimplementedError();
  }

  // --- 微信APP扫码登录

  @override
  Future<void> startQrauth({
    required String appId,
    required List<String> scope,
    required String noncestr,
    required String ticket,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> stopQrauth() {
    throw UnimplementedError();
  }

  //

  @override
  Future<bool?> openUrl({
    required String url,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> openRankList() {
    throw UnimplementedError();
  }

  @override
  Future<bool?> shareText({
    required int scene,
    required String text,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> shareImage({
    required int scene,
    String? title,
    String? description,
    Uint8List? thumbData,
    Uint8List? imageData,
    Uri? imageUri,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> shareFile({
    required int scene,
    String? title,
    String? description,
    Uint8List? thumbData,
    Uint8List? fileData,
    Uri? fileUri,
    String? fileExtension,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> shareEmoji({
    required int scene,
    String? title,
    String? description,
    required Uint8List thumbData,
    Uint8List? emojiData,
    Uri? emojiUri,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> shareMediaMusic({
    required int scene,
    String? title,
    String? description,
    Uint8List? thumbData,
    String? musicUrl,
    String? musicDataUrl,
    String? musicLowBandUrl,
    String? musicLowBandDataUrl,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> shareVideo({
    required int scene,
    String? title,
    String? description,
    Uint8List? thumbData,
    String? videoUrl,
    String? videoLowBandUrl,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> shareWebpage({
    required int scene,
    String? title,
    String? description,
    Uint8List? thumbData,
    required String webpageUrl,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> shareMiniProgram({
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
    throw UnimplementedError();
  }

  @override
  Future<bool?> subscribeMsg({
    required int scene,
    required String templateId,
    String? reserved,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> launchMiniProgram({
    required String userName,
    String? path,
    int type = WechatMiniProgram.kRelease,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> openCustomerServiceChat({
    required String corpId,
    required String url,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> openBusinessView({
    required String businessType,
    String? query,
    String? extInfo,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> openBusinessWebview({
    required int businessType,
    Map<String, String>? resultInfo,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> pay({
    required String appId,
    required String partnerId,
    required String prepayId,
    required String package,
    required String nonceStr,
    required String timeStamp,
    required String sign,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  final WechatKitPlatform initialPlatform = WechatKitPlatform.instance;

  test('$MethodChannelWechatKit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWechatKit>());
  });

  test('isInstalled', () async {
    final MockWechatKitPlatform fakePlatform = MockWechatKitPlatform();
    WechatKitPlatform.instance = fakePlatform;

    expect(await WechatKitPlatform.instance.isInstalled(), true);
  });
}
