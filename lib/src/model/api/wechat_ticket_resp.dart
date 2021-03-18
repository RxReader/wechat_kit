import 'package:json_annotation/json_annotation.dart';
import 'package:wechat_kit/src/model/api/wechat_api_resp.dart';

part 'wechat_ticket_resp.g.dart';

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
