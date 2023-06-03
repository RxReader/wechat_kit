import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as image;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:wechat_kit/wechat_kit.dart';
import 'package:wechat_kit_extension/wechat_kit_extension.dart';

const String kWechatAppID = 'your wechat appId';
const String kWechatUniversalLink = 'your wechat universal link'; // iOS 请配置
const String kWechatAppSecret = 'your wechat appSecret';
const String kWechatMiniAppID = 'your wechat miniAppId';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  late final StreamSubscription<WechatResp> _respSubs;

  WechatAuthResp? _authResp;

  @override
  void initState() {
    super.initState();
    _respSubs = WechatKitPlatform.instance.respStream().listen(_listenResp);
  }

  void _listenResp(WechatResp resp) {
    if (resp is WechatAuthResp) {
      _authResp = resp;
      final String content = 'auth: ${resp.errorCode} ${resp.errorMsg}';
      _showTips('登录', content);
    } else if (resp is WechatShareMsgResp) {
      final String content = 'share: ${resp.errorCode} ${resp.errorMsg}';
      _showTips('分享', content);
    } else if (resp is WechatPayResp) {
      final String content = 'pay: ${resp.errorCode} ${resp.errorMsg}';
      _showTips('支付', content);
    } else if (resp is WechatLaunchMiniProgramResp) {
      final String content = 'mini program: ${resp.errorCode} ${resp.errorMsg}';
      _showTips('拉起小程序', content);
    }
  }

  @override
  void dispose() {
    _respSubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wechat Kit Demo'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('注册APP'),
            onTap: () async {
              await WechatKitPlatform.instance.registerApp(
                appId: kWechatAppID,
                universalLink: kWechatUniversalLink,
              );
              _showTips('注册APP', '注册成功');
            },
          ),
          ListTile(
            title: Text('微信回调 - 冷启'),
            onTap: () async {
              await WechatKitPlatform.instance.handleInitialWXReq();
            },
          ),
          ListTile(
            title: Text('环境检查'),
            onTap: () async {
              final String content =
                  'wechat: ${await WechatKitPlatform.instance.isInstalled()} - ${await WechatKitPlatform.instance.isSupportApi()}';
              _showTips('环境检查', content);
            },
          ),
          ListTile(
            title: Text('登录'),
            onTap: () {
              WechatKitPlatform.instance.auth(
                scope: <String>[WechatScope.kSNSApiUserInfo],
                state: 'auth',
              );
            },
          ),
          ListTile(
            title: Text('扫码登录'),
            onTap: () {
              Navigator.of(context).push<void>(MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => Qrauth(),
              ));
            },
          ),
          ListTile(
            title: Text('获取用户信息'),
            onTap: () async {
              if (_authResp != null && _authResp!.isSuccessful) {
                final WechatAccessTokenResp accessTokenResp =
                    await WechatExtension.getAccessTokenUnionID(
                  appId: kWechatAppID,
                  appSecret: kWechatAppSecret,
                  code: _authResp!.code!,
                );
                if (accessTokenResp.isSuccessful) {
                  final WechatUserInfoResp userInfoResp =
                      await WechatExtension.getUserInfoUnionID(
                    openId: accessTokenResp.openid!,
                    accessToken: accessTokenResp.accessToken!,
                  );
                  if (userInfoResp.isSuccessful) {
                    _showTips('用户信息',
                        '${userInfoResp.nickname} - ${userInfoResp.sex}');
                  }
                }
              }
            },
          ),
          ListTile(
            title: Text('文字分享'),
            onTap: () {
              WechatKitPlatform.instance.shareText(
                scene: WechatScene.kTimeline,
                text: 'Share Text',
              );
            },
          ),
          ListTile(
            title: Text('图片分享'),
            onTap: () async {
              final File file = await DefaultCacheManager().getSingleFile(
                  'https://www.baidu.com/img/bd_logo1.png?where=super');
              await WechatKitPlatform.instance.shareImage(
                scene: WechatScene.kSession,
                imageUri: Uri.file(file.path),
              );
            },
          ),
          ListTile(
            title: Text('文件分享'),
            onTap: () async {
              final File file = await DefaultCacheManager().getSingleFile(
                  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf');
              await WechatKitPlatform.instance.shareFile(
                scene: WechatScene.kSession,
                title: '测试文件',
                fileUri: Uri.file(file.path),
                fileExtension: path.extension(file.path),
              );
            },
          ),
          ListTile(
            title: Text('Emoji分享'),
            onTap: () async {
              final File file = await DefaultCacheManager().getSingleFile(
                  'https://n.sinaimg.cn/tech/transform/695/w467h228/20191119/bf27-iipztfe9404360.gif');
              final image.Image thumbnail =
                  image.decodeImage(file.readAsBytesSync())!;
              Uint8List thumbData = thumbnail.getBytes();
              if (thumbData.length > 32 * 1024) {
                thumbData = Uint8List.fromList(image.encodeJpg(thumbnail,
                    quality: 100 * 32 * 1024 ~/ thumbData.length));
              }
              await WechatKitPlatform.instance.shareEmoji(
                scene: WechatScene.kSession,
                thumbData: thumbData,
                emojiUri: Uri.file(file.path),
              );
            },
          ),
          ListTile(
            title: Text('网页分享'),
            onTap: () {
              WechatKitPlatform.instance.shareWebpage(
                scene: WechatScene.kTimeline,
                webpageUrl: 'https://www.baidu.com',
              );
            },
          ),
          ListTile(
            title: Text('支付'),
            onTap: () {
              // 微信 Demo 例子：https://wxpay.wxutil.com/pub_v2/app/app_pay.php
              WechatKitPlatform.instance.pay(
                appId: kWechatAppID,
                partnerId: '商户号',
                prepayId: '预支付交易会话ID',
                package: '扩展字段,暂填写固定值：Sign=WXPay',
                nonceStr: '随机字符串, 随机字符串，不长于32位',
                timeStamp: '时间戳：东八区，单位秒',
                sign: '签名',
              );
            },
          ),
          ListTile(
            title: Text('拉起小程序'),
            onTap: () {
              WechatKitPlatform.instance.launchMiniProgram(
                userName: kWechatMiniAppID,
                path: 'page/page/index?uid=123',
                type: WechatMiniProgram.kPreview,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showTips(String title, String content) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }
}

class Qrauth extends StatefulWidget {
  const Qrauth({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _QrauthState();
  }
}

class _QrauthState extends State<Qrauth> {
  late final StreamSubscription<WechatQrauthResp> _qrauthRespSubs;

  Uint8List? _qrcode;

  @override
  void initState() {
    super.initState();
    _qrauthRespSubs =
        WechatKitPlatform.instance.qrauthRespStream().listen(_listenQrauthResp);
  }

  void _listenQrauthResp(WechatQrauthResp resp) {
    if (resp is WechatGotQrcodeResp) {
      setState(() {
        _qrcode = resp.imageData;
      });
    } else if (resp is WechatQrcodeScannedResp) {
      if (kDebugMode) {
        print('QrcodeScanned');
      }
    } else if (resp is WechatFinishResp) {
      if (kDebugMode) {
        print('resp: ${resp.errorCode} - ${resp.authCode}');
      }
    }
  }

  @override
  void dispose() {
    _qrauthRespSubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qrauth'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              final WechatAccessTokenResp accessToken =
                  await WechatExtension.getAccessToken(
                appId: kWechatAppID,
                appSecret: kWechatAppSecret,
              );
              if (kDebugMode) {
                print(
                  'accessToken: ${accessToken.errorCode} - '
                  '${accessToken.errorMsg} - '
                  '${accessToken.accessToken}',
                );
              }
              final WechatTicketResp ticket = await WechatExtension.getTicket(
                accessToken: accessToken.accessToken!,
              );
              if (kDebugMode) {
                print(
                  'accessToken: ${ticket.errorCode} - '
                  '${ticket.errorMsg} - '
                  '${ticket.ticket}',
                );
              }
              await WechatKitPlatform.instance.startQrauth(
                appId: kWechatAppID,
                scope: <String>[WechatScope.kSNSApiUserInfo],
                noncestr: Uuid().v1().replaceAll('-', ''),
                ticket: ticket.ticket!,
              );
            },
            child: Text('got qr code'),
          ),
        ],
      ),
      body: GestureDetector(
        child: Center(
          child: _qrcode != null ? Image.memory(_qrcode!) : Text('got qr code'),
        ),
      ),
    );
  }
}
