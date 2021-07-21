import 'dart:convert';
import 'dart:io';

import 'package:wechat_kit_example/api/model/wechat_access_token_resp.dart';
import 'package:wechat_kit_example/api/model/wechat_ticket_resp.dart';
import 'package:wechat_kit_example/api/model/wechat_user_info_resp.dart';

class WechatApi {
  const WechatApi._();

  // --- 微信APP授权登录

  /// 获取 access_token（UnionID）
  static Future<WechatAccessTokenResp> getAccessTokenUnionID({
    required String appId,
    required String appSecret,
    required String code,
  }) {
    return HttpClient()
        .getUrl(Uri.parse(
            'https://api.weixin.qq.com/sns/oauth2/access_token?appid=$appId&secret=$appSecret&code=$code&grant_type=authorization_code'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) async {
      if (response.statusCode == HttpStatus.ok) {
        final String content = await utf8.decodeStream(response);
        return WechatAccessTokenResp.fromJson(
            json.decode(content) as Map<String, dynamic>);
      }
      throw HttpException(
          'HttpResponse statusCode: ${response.statusCode}, reasonPhrase: ${response.reasonPhrase}.');
    });
  }

  /// 刷新或续期 access_token 使用（UnionID）
  static Future<WechatAccessTokenResp> refreshAccessTokenUnionID({
    required String appId,
    required String refreshToken,
  }) {
    return HttpClient()
        .getUrl(Uri.parse(
            'https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=$appId&grant_type=refresh_token&refresh_token=$refreshToken'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) async {
      if (response.statusCode == HttpStatus.ok) {
        final String content = await utf8.decodeStream(response);
        return WechatAccessTokenResp.fromJson(
            json.decode(content) as Map<String, dynamic>);
      }
      throw HttpException(
          'HttpResponse statusCode: ${response.statusCode}, reasonPhrase: ${response.reasonPhrase}.');
    });
  }

  /// 获取用户个人信息（UnionID）
  static Future<WechatUserInfoResp> getUserInfoUnionID({
    required String openId,
    required String accessToken,
  }) {
    return HttpClient()
        .getUrl(Uri.parse(
            'https://api.weixin.qq.com/sns/userinfo?access_token=$accessToken&openid=$openId'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) async {
      if (response.statusCode == HttpStatus.ok) {
        final String content = await utf8.decodeStream(response);
        return WechatUserInfoResp.fromJson(
            json.decode(content) as Map<String, dynamic>);
      }
      throw HttpException(
          'HttpResponse statusCode: ${response.statusCode}, reasonPhrase: ${response.reasonPhrase}.');
    });
  }

  // --- 微信APP扫码登录

  /// 获取 access_token
  static Future<WechatAccessTokenResp> getAccessToken({
    required String appId,
    required String appSecret,
  }) {
    return HttpClient()
        .getUrl(Uri.parse(
            'https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=$appId&secret=$appSecret'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) async {
      if (response.statusCode == HttpStatus.ok) {
        final String content = await utf8.decodeStream(response);
        return WechatAccessTokenResp.fromJson(
            json.decode(content) as Map<String, dynamic>);
      }
      throw HttpException(
          'HttpResponse statusCode: ${response.statusCode}, reasonPhrase: ${response.reasonPhrase}.');
    });
  }

  /// 用上面的函数拿到的 access_token，获取 sdk_ticket
  static Future<WechatTicketResp> getTicket({
    required String accessToken,
  }) {
    return HttpClient()
        .getUrl(Uri.parse(
            'https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=$accessToken&type=2'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) async {
      if (response.statusCode == HttpStatus.ok) {
        final String content = await utf8.decodeStream(response);
        return WechatTicketResp.fromJson(
            json.decode(content) as Map<String, dynamic>);
      }
      throw HttpException(
          'HttpResponse statusCode: ${response.statusCode}, reasonPhrase: ${response.reasonPhrase}.');
    });
  }
}
