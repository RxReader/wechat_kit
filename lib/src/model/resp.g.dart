// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResp _$AuthRespFromJson(Map<String, dynamic> json) => AuthResp(
      errorCode: json['errorCode'] as int? ?? 0,
      errorMsg: json['errorMsg'] as String?,
      code: json['code'] as String?,
      state: json['state'] as String?,
      lang: json['lang'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$AuthRespToJson(AuthResp instance) => <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'code': instance.code,
      'state': instance.state,
      'lang': instance.lang,
      'country': instance.country,
    };

OpenUrlResp _$OpenUrlRespFromJson(Map<String, dynamic> json) => OpenUrlResp(
      errorCode: json['errorCode'] as int? ?? 0,
      errorMsg: json['errorMsg'] as String?,
    );

Map<String, dynamic> _$OpenUrlRespToJson(OpenUrlResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
    };

ShareMsgResp _$ShareMsgRespFromJson(Map<String, dynamic> json) => ShareMsgResp(
      errorCode: json['errorCode'] as int? ?? 0,
      errorMsg: json['errorMsg'] as String?,
    );

Map<String, dynamic> _$ShareMsgRespToJson(ShareMsgResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
    };

SubscribeMsgResp _$SubscribeMsgRespFromJson(Map<String, dynamic> json) =>
    SubscribeMsgResp(
      errorCode: json['errorCode'] as int? ?? 0,
      errorMsg: json['errorMsg'] as String?,
      templateId: json['templateId'] as String?,
      scene: json['scene'] as int?,
      action: json['action'] as String?,
      reserved: json['reserved'] as String?,
      openId: json['openId'] as String?,
    );

Map<String, dynamic> _$SubscribeMsgRespToJson(SubscribeMsgResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'templateId': instance.templateId,
      'scene': instance.scene,
      'action': instance.action,
      'reserved': instance.reserved,
      'openId': instance.openId,
    };

LaunchMiniProgramResp _$LaunchMiniProgramRespFromJson(
        Map<String, dynamic> json) =>
    LaunchMiniProgramResp(
      errorCode: json['errorCode'] as int? ?? 0,
      errorMsg: json['errorMsg'] as String?,
      extMsg: json['extMsg'] as String?,
    );

Map<String, dynamic> _$LaunchMiniProgramRespToJson(
        LaunchMiniProgramResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'extMsg': instance.extMsg,
    };

OpenCustomerServiceChatResp _$OpenCustomerServiceChatRespFromJson(
        Map<String, dynamic> json) =>
    OpenCustomerServiceChatResp(
      errorCode: json['errorCode'] as int? ?? 0,
      errorMsg: json['errorMsg'] as String?,
    );

Map<String, dynamic> _$OpenCustomerServiceChatRespToJson(
        OpenCustomerServiceChatResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
    };

OpenBusinessViewResp _$OpenBusinessViewRespFromJson(
        Map<String, dynamic> json) =>
    OpenBusinessViewResp(
      businessType: json['businessType'] as String,
      extMsg: json['extMsg'] as String,
      errorCode: json['errorCode'] as int? ?? 0,
      errorMsg: json['errorMsg'] as String?,
    );

Map<String, dynamic> _$OpenBusinessViewRespToJson(
        OpenBusinessViewResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'businessType': instance.businessType,
      'extMsg': instance.extMsg,
    };

PayResp _$PayRespFromJson(Map<String, dynamic> json) => PayResp(
      errorCode: json['errorCode'] as int? ?? 0,
      errorMsg: json['errorMsg'] as String?,
      returnKey: json['returnKey'] as String?,
    );

Map<String, dynamic> _$PayRespToJson(PayResp instance) => <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'returnKey': instance.returnKey,
    };
