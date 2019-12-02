import 'package:json_annotation/json_annotation.dart';

abstract class WechatApiResp {
  WechatApiResp({
    this.errcode,
    this.errmsg,
  });

  /// 成功
  static const int ERRORCODE_SUCCESS = 0;

  /// -1	    系统繁忙，此时请开发者稍候再试
  /// 0       请求成功
  /// 40001	  AppSecret错误或者AppSecret不属于这个公众号，请开发者确认AppSecret的正确性
  /// 40002	  请确保grant_type字段值为client_credential
  /// 40164	  调用接口的IP地址不在白名单中，请在接口IP白名单中进行设置。（小程序及小游戏调用不要求IP地址在白名单内。）
  @JsonKey(
    defaultValue: ERRORCODE_SUCCESS,
  )
  final int errcode;
  final String errmsg;

  bool isSuccessful() => errcode == ERRORCODE_SUCCESS;
}
