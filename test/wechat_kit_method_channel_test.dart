import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wechat_kit/src/wechat_kit_method_channel.dart';

void main() {
  final MethodChannelWechatKit platform = MethodChannelWechatKit();
  const MethodChannel channel = MethodChannel('v7lin.github.io/wechat_kit');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'isInstalled':
          return true;
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('isInstalled', () async {
    expect(await platform.isInstalled(), true);
  });
}
