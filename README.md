# wechat_kit

[![Pub Package](https://img.shields.io/pub/v/wechat_kit.svg)](https://pub.dev/packages/wechat_kit)
[![License](https://img.shields.io/github/license/RxReader/wechat_kit)](https://github.com/RxReader/wechat_kit/blob/master/LICENSE)

Flutter 版微信登录/分享/支付 SDK。

若需使用 API 接口方法，请使用 [wechat_kit_extension](https://pub.flutter-io.cn/packages/wechat_kit_extension) 。

## 相关工具

* [flutter版微信SDK](https://github.com/rxreader/wechat_kit)
* [flutter版腾讯(QQ)SDK](https://github.com/rxreader/tencent_kit)
* [flutter版新浪微博SDK](https://github.com/rxreader/weibo_kit)
* [flutter版支付宝SDK](https://github.com/rxreader/alipay_kit)
* [flutter版walle渠道打包工具](https://github.com/rxreader/walle_kit)

## Dart/Flutter Pub 私服

* [simple_pub_server](https://github.com/rxreader/simple_pub_server)

## 相关文档

* [微信开放平台](https://open.weixin.qq.com/)
* [微信登录](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317851&token=&lang=zh_CN)
* [扫码登录](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=215238808828h4XN&token=&lang=zh_CN)
* [微信支付](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317780&token=&lang=zh_CN)
* [Universal Links](https://developer.apple.com/documentation/uikit/inter-process_communication/allowing_apps_and_websites_to_link_to_your_content)

## 开始使用

### Android

```
# 不需要做任何额外接入工作
# 混淆已打入 Library，随 Library 引用，自动添加到 apk 打包混淆
```

#### 获取 Android 微信签名信息

非官方方法 -> 反编译 Gen_Signature_Android2.apk 所得

命令：

```shell
keytool -list -v -keystore ${your_keystore_path} -storepass ${your_keystore_password} 2>/dev/null | grep -p 'MD5:.*' -o | sed 's/MD5://' | sed 's/ //g' | sed 's/://g' | awk '{print tolower($0)}'
```

示例：

```shell
keytool -list -v -keystore example/android/app/infos/dev.jks -storepass 123456 2>/dev/null | grep -p 'MD5:.*' -o | sed 's/MD5://' | sed 's/ //g' | sed 's/://g' | awk '{print tolower($0)}'
> 28424130a4416d519e00946651d53a46
```

### iOS

> 暂不支持 SceneDelegate，详见文档 [微信-iOS接入指南](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html)

在Xcode中，选择你的工程设置项，选中「TARGETS」一栏，在「info」标签栏的「URL type」添加「URL scheme」为你所注册的应用程序 id。

```
URL Types
weixin: identifier=weixin schemes=${appId}
```

iOS 9系统策略更新，限制了http协议的访问，此外应用需要在“Info.plist”中将要使用的URL Schemes列为白名单，才可正常检查其他应用是否安装。

```plist
<key>LSApplicationQueriesSchemes</key>
<array>
	<string>weixin</string>
	<string>weixinULAPI</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSAllowsArbitraryLoads</key>
	<true/>
</dict>
```

Universal Links

```
Capabilities -> Associated Domain -> Domain -> applinks:${your applinks}
```

### Flutter

* 已发布的 pub 版本

```
dependencies:
  wechat_kit: ^${latestTag}
```

若需要不包含支付的 iOS SDK，请修改项目下的 `ios/Podfile`：

```diff 
+ $WechatKitSubspec = 'no_pay'
```

* snapshot

```
dependencies:
  wechat_kit:
    git:
      url: https://github.com/rxreader/wechat_kit.git
```

## 示例

[示例](./example/lib/main.dart)

## Star History

![stars](https://starchart.cc/rxreader/wechat_kit.svg)
