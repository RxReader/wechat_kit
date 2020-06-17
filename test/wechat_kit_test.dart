import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pedantic/pedantic.dart';
import 'package:wechat_kit/wechat_kit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('v7lin.github.io/wechat_kit');
  final Wechat wechat = Wechat();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'registerApp':
          return null;
        case 'isInstalled':
          return true;
        case 'isSupportApi':
          return true;
        case 'openWechat':
          return true;
        case 'auth':
          unawaited(channel.binaryMessenger.handlePlatformMessage(
            channel.name,
            channel.codec.encodeMethodCall(MethodCall(
                'onAuthResp',
                json.decode(
                    '{"country":"CN","code":null,"errorCode":-2,"state":null,"lang":"zh_CN","errorMsg":null}'))),
            (ByteData data) {
              print('mock ${channel.name} ${call.method}');
            },
          ));
          return null;
        case 'startQrauth':
        case 'stopQrauth':
          throw PlatformException(code: '0', message: '懒得去mock');
        case 'openUrl':
        case 'openRankList':
          throw PlatformException(code: '0', message: '懒得去mock');
        case 'shareText':
        case 'shareImage':
        case 'shareEmoji':
        case 'shareMusic':
        case 'shareVideo':
        case 'shareWebpage':
        case 'shareMiniProgram':
          unawaited(channel.binaryMessenger.handlePlatformMessage(
            channel.name,
            channel.codec.encodeMethodCall(MethodCall('onShareMsgResp',
                json.decode('{"errorCode":0,"errorMsg":null}'))),
            (ByteData data) {
              print('mock ${channel.name} ${call.method}');
            },
          ));
          return null;
        case 'subscribeMsg':
        case 'launchMiniProgram':
          throw PlatformException(code: '0', message: '懒得去mock');
        case 'pay':
          unawaited(channel.binaryMessenger.handlePlatformMessage(
            channel.name,
            channel.codec.encodeMethodCall(MethodCall(
                'onPayResp',
                json.decode(
                    '{"errorCode":-2,"returnKey":"","errorMsg":null}'))),
            (ByteData data) {
              // mock success
            },
          ));
          return null;
      }
      throw PlatformException(code: '0', message: '想啥呢，升级插件不想升级Mock？');
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('isInstalled', () async {
    expect(await wechat.isInstalled(), true);
  });

  test('isSupportApi', () async {
    expect(await wechat.isSupportApi(), true);
  });

  test('auth', () async {
    StreamSubscription<WechatAuthResp> sub =
        wechat.authResp().listen((WechatAuthResp resp) {
      expect(resp.errorCode, WechatSdkResp.ERRORCODE_USERCANCEL);
    });
    await wechat.auth(scope: <String>[WechatScope.SNSAPI_USERINFO]);
    await sub.cancel();
  });

  test('share', () async {
    StreamSubscription<WechatSdkResp> sub =
        wechat.shareMsgResp().listen((WechatSdkResp resp) {
      expect(resp.errorCode, WechatSdkResp.ERRORCODE_SUCCESS);
    });
    await wechat.shareText(scene: WechatScene.SESSION, text: 'share text');
    await sub.cancel();
  });

  test('pay', () async {
    StreamSubscription<WechatPayResp> sub =
        wechat.payResp().listen((WechatPayResp resp) {
      expect(resp.errorCode, WechatSdkResp.ERRORCODE_USERCANCEL);
    });
    await wechat.pay(
      appId: 'mock',
      partnerId: 'mock',
      prepayId: 'mock',
      package: 'mock',
      nonceStr: 'mock',
      timeStamp: 'mock',
      sign: 'mock',
    );
    await sub.cancel();
  });
}
