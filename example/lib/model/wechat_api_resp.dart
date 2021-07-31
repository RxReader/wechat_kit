import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'wechat_api_resp.g.dart';

abstract class WechatApiResp {
  const WechatApiResp({
    required this.errcode,
    this.errmsg,
  });

  /// 成功
  static const int ERRORCODE_SUCCESS = 0;

  /// -1	    系统繁忙，此时请开发者稍候再试
  /// 0       请求成功
  /// 40001	  AppSecret错误或者AppSecret不属于这个公众号，请开发者确认AppSecret的正确性
  /// 40002	  请确保grant_type字段值为client_credential
  /// 40164	  调用接口的IP地址不在白名单中，请在接口IP白名单中进行设置。（小程序及小游戏调用不要求IP地址在白名单内。）
  @JsonKey(defaultValue: ERRORCODE_SUCCESS)
  final int errcode;
  final String? errmsg;

  bool get isSuccessful => errcode == ERRORCODE_SUCCESS;

  Map<String, dynamic> toJson();

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class WechatAccessTokenResp extends WechatApiResp {
  const WechatAccessTokenResp({
    required int errcode,
    String? errmsg,
    this.openid,
    this.unionid,
    this.scope,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  }) : super(
          errcode: errcode,
          errmsg: errmsg,
        );

  factory WechatAccessTokenResp.fromJson(Map<String, dynamic> json) =>
      _$WechatAccessTokenRespFromJson(json);

  final String? openid;
  final String? unionid;
  final String? scope;
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn; // 单位：秒

  @override
  Map<String, dynamic> toJson() => _$WechatAccessTokenRespToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class WechatTicketResp extends WechatApiResp {
  const WechatTicketResp({
    required int errcode,
    String? errmsg,
    this.ticket,
    this.expiresIn,
  }) : super(
          errcode: errcode,
          errmsg: errmsg,
        );

  factory WechatTicketResp.fromJson(Map<String, dynamic> json) =>
      _$WechatTicketRespFromJson(json);

  final String? ticket;
  final int? expiresIn;

  @override
  Map<String, dynamic> toJson() => _$WechatTicketRespToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class WechatUserInfoResp extends WechatApiResp {
  const WechatUserInfoResp({
    required int errcode,
    String? errmsg,
    this.openid,
    this.nickname,
    this.sex,
    this.province,
    this.city,
    this.country,
    this.headimgurl,
    this.privilege,
    this.unionid,
  }) : super(
          errcode: errcode,
          errmsg: errmsg,
        );

  factory WechatUserInfoResp.fromJson(Map<String, dynamic> json) =>
      _$WechatUserInfoRespFromJson(json);

  final String? openid;
  final String? nickname;
  final int? sex; // 1为男性，2为女性
  final String? province;
  final String? city;
  final String? country;
  final String? headimgurl;
  final List<dynamic>? privilege;
  final String? unionid;

  bool get isMale => sex == 1;

  bool get isFemale => sex == 2;

  @override
  Map<String, dynamic> toJson() => _$WechatUserInfoRespToJson(this);
}
