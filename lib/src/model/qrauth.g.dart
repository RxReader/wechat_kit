// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qrauth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WechatGotQrcodeResp _$WechatGotQrcodeRespFromJson(Map<String, dynamic> json) =>
    WechatGotQrcodeResp(
      imageData: WechatGotQrcodeResp._byteArrayFromJson(json['imageData']),
    );

Map<String, dynamic> _$WechatGotQrcodeRespToJson(
        WechatGotQrcodeResp instance) =>
    <String, dynamic>{
      'imageData': instance.imageData,
    };

WechatQrcodeScannedResp _$WechatQrcodeScannedRespFromJson(
        Map<String, dynamic> json) =>
    WechatQrcodeScannedResp();

Map<String, dynamic> _$WechatQrcodeScannedRespToJson(
        WechatQrcodeScannedResp instance) =>
    <String, dynamic>{};

WechatFinishResp _$WechatFinishRespFromJson(Map<String, dynamic> json) =>
    WechatFinishResp(
      errorCode: json['errorCode'] as int? ?? 0,
      authCode: json['authCode'] as String?,
    );

Map<String, dynamic> _$WechatFinishRespToJson(WechatFinishResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'authCode': instance.authCode,
    };
