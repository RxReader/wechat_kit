// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qrauth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GotQrcodeResp _$GotQrcodeRespFromJson(Map<String, dynamic> json) {
  return GotQrcodeResp(
    imageData: GotQrcodeResp._byteArrayFromJson(json['imageData']),
  );
}

Map<String, dynamic> _$GotQrcodeRespToJson(GotQrcodeResp instance) =>
    <String, dynamic>{
      'imageData': instance.imageData,
    };

QrcodeScannedResp _$QrcodeScannedRespFromJson(Map<String, dynamic> json) {
  return QrcodeScannedResp();
}

Map<String, dynamic> _$QrcodeScannedRespToJson(QrcodeScannedResp instance) =>
    <String, dynamic>{};

FinishResp _$FinishRespFromJson(Map<String, dynamic> json) {
  return FinishResp(
    errorCode: json['errorCode'] as int? ?? 0,
    authCode: json['authCode'] as String?,
  );
}

Map<String, dynamic> _$FinishRespToJson(FinishResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'authCode': instance.authCode,
    };
