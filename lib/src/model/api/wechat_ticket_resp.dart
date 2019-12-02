import 'package:json_annotation/json_annotation.dart';
import 'package:wechat_kit/src/model/api/wechat_api_resp.dart';

part 'wechat_ticket_resp.g.dart';

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class WechatTicketResp extends WechatApiResp {
  WechatTicketResp({
    int errcode,
    String errmsg,
    this.ticket,
    this.expiresIn,
  }) : super(errcode: errcode, errmsg: errmsg);

  factory WechatTicketResp.fromJson(Map<dynamic, dynamic> json) =>
      _$WechatTicketRespFromJson(json);

  String ticket;
  int expiresIn;

  Map<dynamic, dynamic> toJson() => _$WechatTicketRespToJson(this);
}
