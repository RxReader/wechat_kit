// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WechatAuthResp _$WechatAuthRespFromJson(Map<String, dynamic> json) =>
    WechatAuthResp(
      errorCode: json['errorCode'] as int? ?? 0,
      errorMsg: json['errorMsg'] as String?,
      code: json['code'] as String?,
      state: json['state'] as String?,
      lang: json['lang'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$WechatAuthRespToJson(WechatAuthResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'code': instance.code,
      'state': instance.state,
      'lang': instance.lang,
      'country': instance.country,
    };

WechatOpenUrlResp _$WechatOpenUrlRespFromJson(Map<String, dynamic> json) =>
    WechatOpenUrlResp(
      errorCode: json['errorCode'] as int? ?? 0,
      errorMsg: json['errorMsg'] as String?,
    );

Map<String, dynamic> _$WechatOpenUrlRespToJson(WechatOpenUrlResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
    };

WechatShareMsgResp _$WechatShareMsgRespFromJson(Map<String, dynamic> json) =>
    WechatShareMsgResp(
      errorCode: json['errorCode'] as int? ?? 0,
      errorMsg: json['errorMsg'] as String?,
    );

Map<String, dynamic> _$WechatShareMsgRespToJson(WechatShareMsgResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
    };

WechatSubscribeMsgResp _$WechatSubscribeMsgRespFromJson(
        Map<String, dynamic> json) =>
    WechatSubscribeMsgResp(
      errorCode: json['errorCode'] as int? ?? 0,
      errorMsg: json['errorMsg'] as String?,
      openId: json['openId'] as String?,
      templateId: json['templateId'] as String?,
      scene: json['scene'] as int?,
      action: json['action'] as String?,
      reserved: json['reserved'] as String?,
    );

Map<String, dynamic> _$WechatSubscribeMsgRespToJson(
        WechatSubscribeMsgResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'openId': instance.openId,
      'templateId': instance.templateId,
      'scene': instance.scene,
      'action': instance.action,
      'reserved': instance.reserved,
    };

WechatLaunchMiniProgramResp _$WechatLaunchMiniProgramRespFromJson(
        Map<String, dynamic> json) =>
    WechatLaunchMiniProgramResp(
      errorCode: json['errorCode'] as int? ?? 0,
      errorMsg: json['errorMsg'] as String?,
      extMsg: json['extMsg'] as String?,
    );

Map<String, dynamic> _$WechatLaunchMiniProgramRespToJson(
        WechatLaunchMiniProgramResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'extMsg': instance.extMsg,
    };

WechatOpenCustomerServiceChatResp _$WechatOpenCustomerServiceChatRespFromJson(
        Map<String, dynamic> json) =>
    WechatOpenCustomerServiceChatResp(
      errorCode: json['errorCode'] as int? ?? 0,
      errorMsg: json['errorMsg'] as String?,
    );

Map<String, dynamic> _$WechatOpenCustomerServiceChatRespToJson(
        WechatOpenCustomerServiceChatResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
    };

WechatOpenBusinessViewResp _$WechatOpenBusinessViewRespFromJson(
        Map<String, dynamic> json) =>
    WechatOpenBusinessViewResp(
      errorCode: json['errorCode'] as int? ?? 0,
      errorMsg: json['errorMsg'] as String?,
      businessType: json['businessType'] as String,
      extMsg: json['extMsg'] as String?,
    );

Map<String, dynamic> _$WechatOpenBusinessViewRespToJson(
        WechatOpenBusinessViewResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'businessType': instance.businessType,
      'extMsg': instance.extMsg,
    };

WechatOpenBusinessWebviewResp _$WechatOpenBusinessWebviewRespFromJson(
        Map<String, dynamic> json) =>
    WechatOpenBusinessWebviewResp(
      errorCode: json['errorCode'] as int? ?? 0,
      errorMsg: json['errorMsg'] as String?,
      businessType: json['businessType'] as int,
      resultInfo: json['resultInfo'] as String?,
    );

Map<String, dynamic> _$WechatOpenBusinessWebviewRespToJson(
        WechatOpenBusinessWebviewResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'businessType': instance.businessType,
      'resultInfo': instance.resultInfo,
    };

WechatPayResp _$WechatPayRespFromJson(Map<String, dynamic> json) =>
    WechatPayResp(
      errorCode: json['errorCode'] as int? ?? 0,
      errorMsg: json['errorMsg'] as String?,
      returnKey: json['returnKey'] as String?,
    );

Map<String, dynamic> _$WechatPayRespToJson(WechatPayResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'returnKey': instance.returnKey,
    };
