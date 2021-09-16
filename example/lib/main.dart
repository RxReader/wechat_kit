import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as image;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:wechat_kit/wechat_kit.dart';
import 'package:wechat_kit_extension/wechat_kit_extension.dart';

const String WECHAT_APPID = 'your wechat appId';
const String WECHAT_UNIVERSAL_LINK = 'your wechat universal link'; // iOS 请配置
const String WECHAT_APPSECRET = 'your wechat appSecret';
const String WECHAT_MINIAPPID = 'your wechat miniAppId';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Wechat.instance.registerApp(
    appId: WECHAT_APPID,
    universalLink: WECHAT_UNIVERSAL_LINK,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  late final StreamSubscription<BaseResp> _respSubs =
      Wechat.instance.respStream().listen(_listenResp);

  AuthResp? _authResp;

  void _listenResp(BaseResp resp) {
    if (resp is AuthResp) {
      _authResp = resp;
      final String content = 'auth: ${resp.errorCode} ${resp.errorMsg}';
      _showTips('登录', content);
    } else if (resp is ShareMsgResp) {
      final String content = 'share: ${resp.errorCode} ${resp.errorMsg}';
      _showTips('分享', content);
    } else if (resp is PayResp) {
      final String content = 'pay: ${resp.errorCode} ${resp.errorMsg}';
      _showTips('支付', content);
    } else if (resp is LaunchMiniProgramResp) {
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
        title: const Text('Wechat Kit Demo'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('微信回调 - 冷启'),
            onTap: () async {
              await Wechat.instance.handleInitialWXReq();
            },
          ),
          ListTile(
            title: const Text('环境检查'),
            onTap: () async {
              final String content =
                  'wechat: ${await Wechat.instance.isInstalled()} - ${await Wechat.instance.isSupportApi()}';
              _showTips('环境检查', content);
            },
          ),
          ListTile(
            title: const Text('登录'),
            onTap: () {
              Wechat.instance.auth(
                scope: <String>[WechatScope.SNSAPI_USERINFO],
                state: 'auth',
              );
            },
          ),
          ListTile(
            title: const Text('扫码登录'),
            onTap: () {
              Navigator.of(context).push<void>(MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const Qrauth(),
              ));
            },
          ),
          ListTile(
            title: const Text('获取用户信息'),
            onTap: () async {
              if (_authResp != null && _authResp!.isSuccessful) {
                final WechatAccessTokenResp accessTokenResp =
                    await WechatExtension.getAccessTokenUnionID(
                  appId: WECHAT_APPID,
                  appSecret: WECHAT_APPSECRET,
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
            title: const Text('文字分享'),
            onTap: () {
              Wechat.instance.shareText(
                scene: WechatScene.TIMELINE,
                text: 'Share Text',
              );
            },
          ),
          ListTile(
            title: const Text('图片分享'),
            onTap: () async {
              final File file = await DefaultCacheManager().getSingleFile(
                  'https://www.baidu.com/img/bd_logo1.png?where=super');
              await Wechat.instance.shareImage(
                scene: WechatScene.SESSION,
                imageUri: Uri.file(file.path),
              );
            },
          ),
          ListTile(
            title: const Text('文件分享'),
            onTap: () async {
              final File file = await DefaultCacheManager().getSingleFile(
                  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf');
              await Wechat.instance.shareFile(
                scene: WechatScene.SESSION,
                title: '测试文件',
                fileUri: Uri.file(file.path),
                fileExtension: path.extension(file.path),
              );
            },
          ),
          ListTile(
            title: const Text('Emoji分享'),
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
              await Wechat.instance.shareEmoji(
                scene: WechatScene.SESSION,
                thumbData: thumbData,
                emojiUri: Uri.file(file.path),
              );
            },
          ),
          ListTile(
            title: const Text('网页分享'),
            onTap: () {
              Wechat.instance.shareWebpage(
                scene: WechatScene.TIMELINE,
                webpageUrl: 'https://www.baidu.com',
              );
            },
          ),
          ListTile(
            title: const Text('支付'),
            onTap: () {
              // 微信 Demo 例子：https://wxpay.wxutil.com/pub_v2/app/app_pay.php
              Wechat.instance.pay(
                appId: WECHAT_APPID,
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
            title: const Text('拉起小程序'),
            onTap: () {
              Wechat.instance.launchMiniProgram(
                userName: WECHAT_MINIAPPID,
                path: 'page/page/index?uid=123',
                type: WechatMiniProgram.preview,
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
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QrauthState();
  }
}

class _QrauthState extends State<Qrauth> {
  late final StreamSubscription<QrauthResp> _qrauthRespSubs =
      Wechat.instance.qrauthRespStream().listen(_listenQrauthResp);

  Uint8List? _qrcode;

  void _listenQrauthResp(QrauthResp resp) {
    if (resp is GotQrcodeResp) {
      setState(() {
        _qrcode = resp.imageData;
      });
    } else if (resp is QrcodeScannedResp) {
      print('QrcodeScanned');
    } else if (resp is FinishResp) {
      print('resp: ${resp.errorCode} - ${resp.authCode}');
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
        title: const Text('Qrauth'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              final WechatAccessTokenResp accessToken =
                  await WechatExtension.getAccessToken(
                appId: WECHAT_APPID,
                appSecret: WECHAT_APPSECRET,
              );
              print(
                'accessToken: ${accessToken.errorCode} - '
                '${accessToken.errorMsg} - '
                '${accessToken.accessToken}',
              );
              final WechatTicketResp ticket = await WechatExtension.getTicket(
                accessToken: accessToken.accessToken!,
              );
              print(
                'accessToken: ${ticket.errorCode} - '
                '${ticket.errorMsg} - '
                '${ticket.ticket}',
              );
              await Wechat.instance.startQrauth(
                appId: WECHAT_APPID,
                scope: <String>[WechatScope.SNSAPI_USERINFO],
                noncestr: const Uuid().v1().toString().replaceAll('-', ''),
                ticket: ticket.ticket!,
              );
            },
            child: const Text('got qr code'),
          ),
        ],
      ),
      body: GestureDetector(
        child: Center(
          child: _qrcode != null
              ? Image.memory(_qrcode!)
              : const Text('got qr code'),
        ),
      ),
    );
  }
}
