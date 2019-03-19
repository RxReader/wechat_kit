import 'dart:convert';

import 'package:fake_wechat/src/domain/api/wechat_access_token_resp.dart';
import 'package:fake_wechat/src/domain/api/wechat_user_info_resp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

void main() {
  test('smoke test - snake case', () {
    print('${toSnakeCase('oneField')}');
    print('${toSnakeCase('oneField_street')}');
    print('${toSnakeCase('one_field')}');
  });

  test('smoke test - kebab case', () {
    print('${toKebabCase('oneField')}');
    print('${toKebabCase('oneField_street')}');
    print('${toKebabCase('one_field')}');
  });

  test('smoke test - camel case', () {
    print('${toCamelCase('oneField')}');
    print('${toCamelCase('oneField_street')}');
    print('${toCamelCase('one_field')}');
  });

  test('smoke test - jaguar_serializer', () {
    WechatAccessTokenResp accessTokenResp = WechatAccessTokenRespSerializer()
        .fromMap(json.decode(
                '{"access_token":"ACCESS_TOKEN","expires_in":7200,"refresh_token":"REFRESH_TOKEN","openid":"OPENID","scope":"SCOPE"}')
            as Map<dynamic, dynamic>);
    expect(accessTokenResp.errcode, equals(0));
    expect(accessTokenResp.expiresIn, equals(7200));
    expect(accessTokenResp.accessToken, equals('ACCESS_TOKEN'));
    expect(accessTokenResp.refreshToken, equals('REFRESH_TOKEN'));
    expect(accessTokenResp.openid, equals('OPENID'));
    expect(accessTokenResp.scope, equals('SCOPE'));

    WechatUserInfoResp userInfoResp = WechatUserInfoRespSerializer().fromMap(
        json.decode(
                '{"openid":"OPENID","nickname":"NICKNAME","sex":1,"province":"PROVINCE","city":"CITY","country":"COUNTRY","headimgurl": "http://wx.qlogo.cn/mmopen/g3MonUZtNHkdmzicIlibx6iaFqAc56vxLSUfpb6n5WKSYVY0ChQKkiaJSgQ1dZuTOgvLLrhJbERQQ4eMsv84eavHiaiceqxibJxCfHe/0","privilege":["PRIVILEGE1","PRIVILEGE2"],"unionid": " o6_bmasdasdsad6_2sgVt7hMZOPfL"}')
            as Map<dynamic, dynamic>);
    expect(userInfoResp.errcode, equals(0));
    expect(userInfoResp.nickname, equals('NICKNAME'));
    expect(userInfoResp.sex, equals(1));
    expect(userInfoResp.headimgurl, equals('http://wx.qlogo.cn/mmopen/g3MonUZtNHkdmzicIlibx6iaFqAc56vxLSUfpb6n5WKSYVY0ChQKkiaJSgQ1dZuTOgvLLrhJbERQQ4eMsv84eavHiaiceqxibJxCfHe/0'));
  });
}
