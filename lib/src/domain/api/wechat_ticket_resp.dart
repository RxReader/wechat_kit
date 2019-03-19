import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:fake_wechat/src/domain/api/wechat_api_resp.dart';

part 'wechat_ticket_resp.jser.dart';

@GenSerializer(nameFormatter: toSnakeCase)
class WechatTicketRespSerializer extends Serializer<WechatTicketResp>
    with _$WechatTicketRespSerializer {}

class WechatTicketResp extends WechatApiResp {
  WechatTicketResp({
    int errcode,
    String errmsg,
    this.ticket,
    this.expiresIn,
  }) : super(errcode: errcode, errmsg: errmsg);

  String ticket;
  int expiresIn;
}
