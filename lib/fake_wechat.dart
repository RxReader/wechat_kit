library fake_wechat;

export 'src/domain/api/wechat_access_token_resp.dart'
    hide WechatAccessTokenRespSerializer;
export 'src/domain/api/wechat_api_resp.dart';
export 'src/domain/api/wechat_user_info_resp.dart'
    hide WechatUserInfoRespSerializer;
export 'src/domain/qrauth/wechat_qrauth_resp.dart'
    hide WechatQrauthRespSerializer;
export 'src/domain/sdk/wechat_auth_resp.dart' hide WechatAuthRespSerializer;
export 'src/domain/sdk/wechat_launch_mini_program_resp.dart'
    hide WechatLaunchMiniProgramRespSerializer;
export 'src/domain/sdk/wechat_pay_resp.dart' hide WechatPayRespSerializer;
export 'src/domain/sdk/wechat_sdk_resp.dart' hide WechatSdkRespSerializer;
export 'src/domain/sdk/wechat_subscribe_msg_resp.dart'
    hide WechatSubscribeMsgRespSerializer;
export 'src/wechat.dart';
export 'src/wechat_biz_profile_type.dart';
export 'src/wechat_mp_webview_type.dart';
export 'src/wechat_provider.dart';
export 'src/wechat_scene.dart';
export 'src/wechat_scope.dart';
