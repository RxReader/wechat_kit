import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;
import 'package:okhttp_kit/okhttp_kit.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:wechat_kit/wechat_kit.dart';

void main() => runApp(MyApp());

const String WECHAT_APPID = 'your wechat appId';
const String WECHAT_UNIVERSAL_LINK = 'your wechat universal link'; // iOS 请配置
const String WECHAT_APPSECRET = 'your wechat appSecret';
const String WECHAT_MINIAPPID = 'your wechat miniAppId';

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
  Wechat _wechat = Wechat()
    ..registerApp(
      appId: WECHAT_APPID,
      universalLink: WECHAT_UNIVERSAL_LINK,
    );

  StreamSubscription<WechatAuthResp> _auth;
  StreamSubscription<WechatSdkResp> _share;
  StreamSubscription<WechatPayResp> _pay;
  StreamSubscription<WechatLaunchMiniProgramResp> _miniProgram;

  WechatAuthResp _authResp;

  @override
  void initState() {
    super.initState();
    _auth = _wechat.authResp().listen(_listenAuth);
    _share = _wechat.shareMsgResp().listen(_listenShareMsg);
    _pay = _wechat.payResp().listen(_listenPay);
    _miniProgram = _wechat.launchMiniProgramResp().listen(_listenMiniProgram);
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

  void _listenMiniProgram(WechatLaunchMiniProgramResp resp) {
    String content = 'mini program: ${resp.errorCode} ${resp.errorMsg}';
    _showTips('拉起小程序', content);
  }

  @override
  void dispose() {
    _auth?.cancel();
    _auth = null;
    _share?.cancel();
    _share = null;
    _pay?.cancel();
    _pay = null;
    _miniProgram?.cancel();
    _miniProgram = null;
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
            title: const Text('环境检查'),
            onTap: () async {
              String content =
                  'wechat: ${await _wechat.isInstalled()} - ${await _wechat.isSupportApi()}';
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
              Navigator.of(context).push<void>(MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => Qrauth(
                  wechat: _wechat,
                ),
              ));
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
              OkHttpClient client = OkHttpClientBuilder().build();
              Response resp = await client
                  .newCall(RequestBuilder()
                      .get()
                      .url(HttpUrl.parse(
                          'https://www.baidu.com/img/bd_logo1.png?where=super'))
                      .build())
                  .enqueue();
              if (resp.isSuccessful()) {
                Directory saveDir = Platform.isAndroid
                    ? await path_provider.getExternalStorageDirectory()
                    : await path_provider.getApplicationDocumentsDirectory();
                File saveFile = File(path.join(saveDir.path, 'timg.png'));
                if (!saveFile.existsSync()) {
                  saveFile.createSync(recursive: true);
                  saveFile.writeAsBytesSync(
                    await resp.body().bytes(),
                    flush: true,
                  );
                }
                await _wechat.shareImage(
                  scene: WechatScene.SESSION,
                  imageUri: Uri.file(saveFile.path),
                );
              }
            },
          ),
          ListTile(
            title: const Text('文件分享'),
            onTap: () async {
              OkHttpClient client = OkHttpClientBuilder().build();
              Response resp = await client
                  .newCall(RequestBuilder()
                      .get()
                      .url(HttpUrl.parse(
                          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'))
                      .build())
                  .enqueue();
              if (resp.isSuccessful()) {
                Directory saveDir = Platform.isAndroid
                    ? await path_provider.getExternalStorageDirectory()
                    : await path_provider.getApplicationDocumentsDirectory();
                File saveFile = File(path.join(saveDir.path, 'demo.pdf'));
                if (!saveFile.existsSync()) {
                  saveFile.createSync(recursive: true);
                  saveFile.writeAsBytesSync(
                    await resp.body().bytes(),
                    flush: true,
                  );
                }
                await _wechat.shareFile(
                  scene: WechatScene.SESSION,
                  title: '测试文件',
                  fileUri: Uri.file(saveFile.path),
                  fileExtension: path.extension(saveFile.path),
                );
              }
            },
          ),
          ListTile(
            title: const Text('Emoji分享'),
            onTap: () async {
              OkHttpClient client = OkHttpClientBuilder().build();
              Response resp = await client
                  .newCall(RequestBuilder()
                      .get()
                      .url(HttpUrl.parse(
                          'https://n.sinaimg.cn/tech/transform/695/w467h228/20191119/bf27-iipztfe9404360.gif'))
                      .build())
                  .enqueue();
              if (resp.isSuccessful()) {
                Directory saveDir = Platform.isAndroid
                    ? await path_provider.getExternalStorageDirectory()
                    : await path_provider.getApplicationDocumentsDirectory();
                File saveFile = File(path.join(saveDir.path, 'timg.gif'));
                if (!saveFile.existsSync()) {
                  saveFile.createSync(recursive: true);
                  saveFile.writeAsBytesSync(
                    await resp.body().bytes(),
                    flush: true,
                  );
                }
                image.Image thumbnail =
                    image.decodeGif(saveFile.readAsBytesSync());
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
              }
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
          ListTile(
            title: const Text('拉起小程序'),
            onTap: () {
              _wechat.launchMiniProgram(
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

  Uint8List _qrcod;

  @override
  void initState() {
    super.initState();
    _authGotQrcode =
        widget.wechat.authGotQrcodeResp().listen(_listenAuthGotQrcode);
    _authQrcodeScanned =
        widget.wechat.authQrcodeScannedResp().listen(_listenAuthQrcodeScanned);
    _authFinish = widget.wechat.authFinishResp().listen(_listenAuthFinish);
  }

  void _listenAuthGotQrcode(Uint8List qrcode) {
    _qrcod = qrcode;
    setState(() {});
  }

  void _listenAuthQrcodeScanned(String msg) {
    print('msg: $msg');
  }

  void _listenAuthFinish(WechatQrauthResp qrauthResp) {
    print('resp: ${qrauthResp.errorCode} - ${qrauthResp.authCode}');
  }

  @override
  void dispose() {
    _authGotQrcode?.cancel();
    _authGotQrcode = null;
    _authQrcodeScanned?.cancel();
    _authQrcodeScanned = null;
    _authFinish?.cancel();
    _authFinish = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qrauth'),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              WechatAccessTokenResp accessToken =
                  await widget.wechat.getAccessToken(
                appId: WECHAT_APPID,
                appSecret: WECHAT_APPSECRET,
              );
              print(
                  'accessToken: ${accessToken.errcode} - ${accessToken.errmsg} - ${accessToken.accessToken}');
              WechatTicketResp ticket = await widget.wechat.getTicket(
                accessToken: accessToken.accessToken,
              );
              print(
                  'accessToken: ${ticket.errcode} - ${ticket.errmsg} - ${ticket.ticket}');
              await widget.wechat.startQrauth(
                appId: WECHAT_APPID,
                scope: <String>[WechatScope.SNSAPI_USERINFO],
                ticket: ticket.ticket,
              );
            },
            child: const Text('got qr code'),
          ),
        ],
      ),
      body: GestureDetector(
        child: Center(
          child:
              _qrcod != null ? Image.memory(_qrcod) : const Text('got qr code'),
        ),
      ),
    );
  }
}
