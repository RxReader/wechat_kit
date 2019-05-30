import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fake_path_provider/fake_path_provider.dart';
import 'package:fake_wechat/fake_wechat.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as image;

void main() {
  runZoned(() {
    runApp(MyApp());
  }, onError: (Object error, StackTrace stack) {
    print(error);
    print(stack);
  });

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
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
  static const String WECHAT_APPID = 'wx854345270316ce6e';
  static const String WECHAT_APPSECRET = '';

  Wechat _wechat = Wechat()..registerApp(appId: WECHAT_APPID);

  StreamSubscription<WechatAuthResp> _auth;
  StreamSubscription<WechatSdkResp> _share;
  StreamSubscription<WechatPayResp> _pay;

  WechatAuthResp _authResp;

  @override
  void initState() {
    super.initState();
    _auth = _wechat.authResp().listen(_listenAuth);
    _share = _wechat.shareMsgResp().listen(_listenShareMsg);
    _pay = _wechat.payResp().listen(_listenPay);
  }

  void _listenAuth(WechatAuthResp resp) {
    _authResp = resp;
    String content = 'auth: ${resp.errorCode} ${resp.errorMsg}';
    _showTips('登录', content);
  }

  void _listenShareMsg(WechatSdkResp resp) {
    String content = 'share: ${resp.errorCode} ${resp.errorMsg}';
    _showTips('分享', content);
  }

  void _listenPay(WechatPayResp resp) {
    String content = 'pay: ${resp.errorCode} ${resp.errorMsg}';
    _showTips('支付', content);
  }

  @override
  void dispose() {
    if (_auth != null) {
      _auth.cancel();
    }
    if (_share != null) {
      _share.cancel();
    }
    if (_pay != null) {
      _pay.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake Wechat Demo'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('环境检查'),
            onTap: () async {
              String content =
                  'wechat: ${await _wechat.isWechatInstalled()} - ${await _wechat.isWechatSupportApi()}';
              _showTips('环境检查', content);
            },
          ),
          ListTile(
            title: const Text('登录'),
            onTap: () {
              _wechat.auth(
                scope: <String>[WechatScope.SNSAPI_USERINFO],
                state: 'auth',
              );
            },
          ),
          ListTile(
            title: const Text('扫码登录'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => Qrauth(
                      wechat: _wechat,
                    ),
              )).then((dynamic result) {

              });
            },
          ),
          ListTile(
            title: const Text('获取用户信息'),
            onTap: () {
              if (_authResp != null &&
                  _authResp.errorCode == WechatSdkResp.ERRORCODE_SUCCESS) {
                _wechat
                    .getAccessTokenUnionID(
                  appId: WECHAT_APPID,
                  appSecret: WECHAT_APPSECRET,
                  code: _authResp.code,
                )
                    .then((WechatAccessTokenResp accessTokenResp) {
                  if (accessTokenResp.errcode ==
                      WechatApiResp.ERRORCODE_SUCCESS) {
                    _wechat
                        .getUserInfoUnionID(
                      openId: accessTokenResp.openid,
                      accessToken: accessTokenResp.accessToken,
                    )
                        .then((WechatUserInfoResp userInfoResp) {
                      if (userInfoResp.errcode ==
                          WechatApiResp.ERRORCODE_SUCCESS) {
                        _showTips('用户信息',
                            '${userInfoResp.nickname} - ${userInfoResp.sex}');
                      }
                    });
                  }
                });
              }
            },
          ),
          ListTile(
            title: const Text('文字分享'),
            onTap: () {
              _wechat.shareText(
                scene: WechatScene.TIMELINE,
                text: 'Share Text',
              );
            },
          ),
          ListTile(
            title: const Text('图片分享'),
            onTap: () async {
              AssetImage timg = const AssetImage('images/icon/timg.jpeg');
              AssetBundleImageKey key =
                  await timg.obtainKey(createLocalImageConfiguration(context));
              ByteData timgData = await key.bundle.load(key.name);
              Directory saveDir = await PathProvider.getDocumentsDirectory();
              File saveFile = File('${saveDir.path}${path.separator}timg.jpeg');
              if (!saveFile.existsSync()) {
                saveFile.createSync(recursive: true);
                saveFile.writeAsBytesSync(timgData.buffer.asUint8List(),
                    flush: true);
              }
              await _wechat.shareImage(
                scene: WechatScene.SESSION,
                imageUri: Uri.file(saveFile.path),
              );
            },
          ),
          ListTile(
            title: const Text('Emoji分享'),
            onTap: () async {
              AssetImage timg = const AssetImage('images/icon/timg.gif');
              AssetBundleImageKey key =
                  await timg.obtainKey(createLocalImageConfiguration(context));
              ByteData timgData = await key.bundle.load(key.name);
              Directory saveDir = await PathProvider.getDocumentsDirectory();
              File saveFile = File('${saveDir.path}${path.separator}timg.gif');
              if (!saveFile.existsSync()) {
                saveFile.createSync(recursive: true);
                saveFile.writeAsBytesSync(timgData.buffer.asUint8List(),
                    flush: true);
              }
              image.Image thumbnail =
                  image.decodeGif(timgData.buffer.asUint8List());
              Uint8List thumbData = thumbnail.getBytes();
              if (thumbData.length > 32 * 1024) {
                thumbData = Uint8List.fromList(image.encodeJpg(thumbnail,
                    quality: 100 * 32 * 1024 ~/ thumbData.length));
              }
              await _wechat.shareEmoji(
                scene: WechatScene.SESSION,
                thumbData: thumbData,
                emojiUri: Uri.file(saveFile.path),
              );
            },
          ),
          ListTile(
            title: const Text('网页分享'),
            onTap: () {
              _wechat.shareWebpage(
                scene: WechatScene.TIMELINE,
                webpageUrl: 'https://www.baidu.com',
              );
            },
          ),
          ListTile(
            title: const Text('支付'),
            onTap: () {
              // 微信 Demo 例子：https://wxpay.wxutil.com/pub_v2/app/app_pay.php
              _wechat.pay(
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
        ],
      ),
    );
  }

  void _showTips(String title, String content) {
    showDialog(
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
    Key key,
    this.wechat,
  }) : super(key: key);

  final Wechat wechat;

  @override
  State<StatefulWidget> createState() {
    return _QrauthState();
  }
}

class _QrauthState extends State<Qrauth> {
  StreamSubscription<Uint8List> _authGotQrcode;
  StreamSubscription<String> _authQrcodeScanned;
  StreamSubscription<WechatQrauthResp> _authFinish;

  @override
  void initState() {
    super.initState();
    _authGotQrcode =
        widget.wechat.authGotQrcodeResp().listen(_listenAuthGotQrcode);
    _authQrcodeScanned =
        widget.wechat.authQrcodeScannedResp().listen(_listenAuthQrcodeScanned);
    _authFinish = widget.wechat.authFinishResp().listen(_listenAuthFinish);
  }

  void _listenAuthGotQrcode(Uint8List qrcode) {}

  void _listenAuthQrcodeScanned(String msg) {}

  void _listenAuthFinish(WechatQrauthResp qrcode) {}

  @override
  void dispose() {
    if (_authGotQrcode != null) {
      _authGotQrcode.cancel();
    }
    if (_authQrcodeScanned != null) {
      _authQrcodeScanned.cancel();
    }
    if (_authFinish != null) {
      _authFinish.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qrauth'),
      ),
      body: GestureDetector(
        child: Center(
          child: const Text('got qr code'),
        ),
      ),
    );
  }
}
