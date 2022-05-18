import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'qrauth.g.dart';

abstract class QrauthResp {
  const QrauthResp();

  Map<String, dynamic> toJson();

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}

@JsonSerializable()
class GotQrcodeResp extends QrauthResp {
  const GotQrcodeResp({
    required this.imageData,
  });

  factory GotQrcodeResp.fromJson(Map<String, dynamic> json) =>
      _$GotQrcodeRespFromJson(json);

  @JsonKey(fromJson: _byteArrayFromJson)
  final Uint8List imageData;

  @override
  Map<String, dynamic> toJson() => _$GotQrcodeRespToJson(this);

  static Uint8List _byteArrayFromJson(Object? json) {
    return json! as Uint8List;
  }
}

@JsonSerializable()
class QrcodeScannedResp extends QrauthResp {
  const QrcodeScannedResp();

  factory QrcodeScannedResp.fromJson(Map<String, dynamic> json) =>
      _$QrcodeScannedRespFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$QrcodeScannedRespToJson(this);
}

@JsonSerializable()
class FinishResp extends QrauthResp {
  const FinishResp({
    required this.errorCode,
    this.authCode,
  });

  factory FinishResp.fromJson(Map<String, dynamic> json) =>
      _$FinishRespFromJson(json);

  /// Auth成功
  static const int ERRORCODE_OK = 0;

  /// 普通错误
  static const int ERRORCODE_NORMAL = -1;

  /// 网络错误
  static const int ERRORCODE_NETWORK = -2;

  /// 获取二维码失败
  static const int ERRORCODE_GETQRCODEFAILED = -3;

  /// 用户取消授权
  static const int ERRORCODE_CANCEL = -4;

  /// 超时
  static const int ERRORCODE_TIMEOUT = -5;

  @JsonKey(defaultValue: ERRORCODE_OK)
  final int errorCode;
  final String? authCode;

  bool get isSuccessful => errorCode == ERRORCODE_OK;

  bool get isCancelled => errorCode == ERRORCODE_CANCEL;

  @override
  Map<String, dynamic> toJson() => _$FinishRespToJson(this);
}
