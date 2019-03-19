import 'package:fake_wechat/src/wechat.dart';
import 'package:flutter/widgets.dart';

class WechatProvider extends InheritedWidget {
  WechatProvider({
    Key key,
    @required this.wechat,
    @required Widget child,
  }) : super(key: key, child: child);

  final Wechat wechat;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    WechatProvider oldProvider = oldWidget as WechatProvider;
    return wechat != oldProvider.wechat;
  }

  static WechatProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(WechatProvider)
        as WechatProvider;
  }
}
