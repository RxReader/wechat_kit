import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fake_wechat/fake_wechat.dart';

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
    wechat.registerApp(appId: 'wx854345270316ce6e'); // 更换为目标应用的appId
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

  @override
  void initState() {
    super.initState();
    _auth = widget.wechat.authResp().listen(_listenAuth);
    _share = widget.wechat.shareMsgResp().listen(_listenShareMsg);
  }

  void _listenAuth(WechatAuthResp resp) {
    String content = 'auth: ${resp.errorCode} ${resp.errorMsg}';
    _showTips('登录', content);
  }

  void _listenShareMsg(WechatSdkResp resp) {
    String content = 'share: ${resp.errorCode} ${resp.errorMsg}';
    _showTips('分享', content);
  }

  @override
  void dispose() {
    if (_auth != null) {
      _auth.cancel();
    }
    if (_share != null) {
      _share.cancel();
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
              AssetImage image = const AssetImage('images/icon/timg.jpeg');
              AssetBundleImageKey key =
                  await image.obtainKey(createLocalImageConfiguration(context));
              ByteData imageData = await key.bundle.load(key.name);
              await widget.wechat.shareImage(
                scene: WechatScene.TIMELINE,
                imageData: imageData.buffer.asUint8List(),
              );
            },
          ),
          ListTile(
            title: const Text('Emoji分享'),
            onTap: () async {
              AssetImage image = const AssetImage('images/icon/timg.gif');
              AssetBundleImageKey key =
                  await image.obtainKey(createLocalImageConfiguration(context));
              ByteData emojiData = await key.bundle.load(key.name);
              await widget.wechat.shareEmoji(
                scene: WechatScene.SESSION,
                thumbData: null,
                emojiData: emojiData.buffer.asUint8List(),
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
          )
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
