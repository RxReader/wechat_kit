// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_launch_mini_program_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WechatLaunchMiniProgramResp _$WechatLaunchMiniProgramRespFromJson(Map json) {
  return WechatLaunchMiniProgramResp(
    errorCode: json['errorCode'] as int ?? 0,
    errorMsg: json['errorMsg'] as String,
    extMsg: json['extMsg'] as String,
  );
}

Map<String, dynamic> _$WechatLaunchMiniProgramRespToJson(
        WechatLaunchMiniProgramResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'extMsg': instance.extMsg,
    };
