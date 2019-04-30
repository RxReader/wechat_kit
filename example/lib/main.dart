import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fake_path_provider/fake_path_provider.dart';
import 'package:fake_wechat/fake_wechat.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as image;

const String WECHAT_APPID = 'wx854345270316ce6e'; // 更换为目标应用的appId

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
    Wechat wechat = Wechat();
    wechat.registerApp(appId: WECHAT_APPID);
    return WechatProvider(
      wechat: wechat,
      child: MaterialApp(
        home: Home(
          wechat: wechat,
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  Home({
    Key key,
    @required this.wechat,
  }) : super(key: key);

  final Wechat wechat;

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  StreamSubscription<WechatAuthResp> _auth;
  StreamSubscription<WechatSdkResp> _share;
  StreamSubscription<WechatPayResp> _pay;

  @override
  void initState() {
    super.initState();
    _auth = widget.wechat.authResp().listen(_listenAuth);
    _share = widget.wechat.shareMsgResp().listen(_listenShareMsg);
    _pay = widget.wechat.payResp().listen(_listenPay);
  }

  void _listenAuth(WechatAuthResp resp) {
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
                  'wechat: ${await widget.wechat.isWechatInstalled()} - ${await widget.wechat.isWechatSupportApi()}';
              _showTips('环境检查', content);
            },
          ),
          ListTile(
            title: const Text('登录'),
            onTap: () {
              widget.wechat.auth(
                scope: <String>[WechatScope.SNSAPI_USERINFO],
                state: 'auth',
              );
            },
          ),
          ListTile(
            title: const Text('文字分享'),
            onTap: () {
              widget.wechat.shareText(
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
              await widget.wechat.shareImage(
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
              await widget.wechat.shareEmoji(
                scene: WechatScene.SESSION,
                thumbData: thumbData,
                emojiUri: Uri.file(saveFile.path),
              );
            },
          ),
          ListTile(
            title: const Text('网页分享'),
            onTap: () {
              widget.wechat.shareWebpage(
                scene: WechatScene.TIMELINE,
                webpageUrl: 'https://www.baidu.com',
              );
            },
          ),
          ListTile(
            title: const Text('支付'),
            onTap: () {
              // 微信 Demo 例子：https://wxpay.wxutil.com/pub_v2/app/app_pay.php
              widget.wechat.pay(
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
