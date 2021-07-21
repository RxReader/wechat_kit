import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as image;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:wechat_kit/wechat_kit.dart';
import 'package:wechat_kit_example/api/model/wechat_access_token_resp.dart';
import 'package:wechat_kit_example/api/model/wechat_api_resp.dart';
import 'package:wechat_kit_example/api/model/wechat_ticket_resp.dart';
import 'package:wechat_kit_example/api/model/wechat_user_info_resp.dart';
import 'package:wechat_kit_example/api/wechat_api.dart';

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
  late final StreamSubscription<WechatAuthResp> _auth =
      Wechat.instance.authResp().listen(_listenAuth);
  late final StreamSubscription<WechatSdkResp> _share =
      Wechat.instance.shareMsgResp().listen(_listenShareMsg);
  late final StreamSubscription<WechatPayResp> _pay =
      Wechat.instance.payResp().listen(_listenPay);
  late final StreamSubscription<WechatLaunchMiniProgramResp> _miniProgram =
      Wechat.instance.launchMiniProgramResp().listen(_listenMiniProgram);

  WechatAuthResp? _authResp;

  @override
  void initState() {
    super.initState();
  }

  void _listenAuth(WechatAuthResp resp) {
    _authResp = resp;
    final String content = 'auth: ${resp.errorCode} ${resp.errorMsg}';
    _showTips('登录', content);
  }

  void _listenShareMsg(WechatSdkResp resp) {
    final String content = 'share: ${resp.errorCode} ${resp.errorMsg}';
    _showTips('分享', content);
  }

  void _listenPay(WechatPayResp resp) {
    final String content = 'pay: ${resp.errorCode} ${resp.errorMsg}';
    _showTips('支付', content);
  }

  void _listenMiniProgram(WechatLaunchMiniProgramResp resp) {
    final String content = 'mini program: ${resp.errorCode} ${resp.errorMsg}';
    _showTips('拉起小程序', content);
  }

  @override
  void dispose() {
    _auth.cancel();
    _share.cancel();
    _pay.cancel();
    _miniProgram.cancel();
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
              if (_authResp != null &&
                  _authResp!.errorCode == WechatSdkResp.ERRORCODE_SUCCESS) {
                final WechatAccessTokenResp accessTokenResp =
                    await WechatApi.getAccessTokenUnionID(
                  appId: WECHAT_APPID,
                  appSecret: WECHAT_APPSECRET,
                  code: _authResp!.code!,
                );
                if (accessTokenResp.errcode ==
                    WechatApiResp.ERRORCODE_SUCCESS) {
                  final WechatUserInfoResp userInfoResp =
                      await WechatApi.getUserInfoUnionID(
                    openId: accessTokenResp.openid!,
                    accessToken: accessTokenResp.accessToken!,
                  );
                  if (userInfoResp.errcode == WechatApiResp.ERRORCODE_SUCCESS) {
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
  late final StreamSubscription<Uint8List> _authGotQrcode =
      Wechat.instance.authGotQrcodeResp().listen(_listenAuthGotQrcode);
  late final StreamSubscription<String> _authQrcodeScanned =
      Wechat.instance.authQrcodeScannedResp().listen(_listenAuthQrcodeScanned);
  late final StreamSubscription<QrauthResp> _authFinish =
      Wechat.instance.authFinishResp().listen(_listenAuthFinish);

  Uint8List? _qrcod;

  @override
  void initState() {
    super.initState();
  }

  void _listenAuthGotQrcode(Uint8List qrcode) {
    setState(() {
      _qrcod = qrcode;
    });
  }

  void _listenAuthQrcodeScanned(String msg) {
    print('msg: $msg');
  }

  void _listenAuthFinish(QrauthResp qrauthResp) {
    print('resp: ${qrauthResp.errorCode} - ${qrauthResp.authCode}');
  }

  @override
  void dispose() {
    _authGotQrcode.cancel();
    _authQrcodeScanned.cancel();
    _authFinish.cancel();
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
                  await WechatApi.getAccessToken(
                appId: WECHAT_APPID,
                appSecret: WECHAT_APPSECRET,
              );
              print(
                  'accessToken: ${accessToken.errcode} - ${accessToken.errmsg} - ${accessToken.accessToken}');
              final WechatTicketResp ticket = await WechatApi.getTicket(
                accessToken: accessToken.accessToken!,
              );
              print(
                  'accessToken: ${ticket.errcode} - ${ticket.errmsg} - ${ticket.ticket}');
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
          child: _qrcod != null
              ? Image.memory(_qrcod!)
              : const Text('got qr code'),
        ),
      ),
    );
  }
}
