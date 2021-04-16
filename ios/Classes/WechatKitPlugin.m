#import "WechatKitPlugin.h"
#ifdef NO_PAY
#import <WXApi.h>
#import <WechatAuthSDK.h>
#else
#import <WechatOpenSDK/WXApi.h>
#import <WechatOpenSDK/WechatAuthSDK.h>
#endif

@interface WechatKitPlugin () <WXApiDelegate, WechatAuthAPIDelegate>

@end

@implementation WechatKitPlugin {
    FlutterMethodChannel *_channel;
    WechatAuthSDK *_qrauth;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel =
        [FlutterMethodChannel methodChannelWithName:@"v7lin.github.io/wechat_kit"
                                    binaryMessenger:[registrar messenger]];
    WechatKitPlugin *instance = [[WechatKitPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

static NSString *const METHOD_REGISTERAPP = @"registerApp";
static NSString *const METHOD_ISINSTALLED = @"isInstalled";
static NSString *const METHOD_ISSUPPORTAPI = @"isSupportApi";
static NSString *const METHOD_OPENWECHAT = @"openWechat";
static NSString *const METHOD_AUTH = @"auth";
static NSString *const METHOD_STARTQRAUTH = @"startQrauth";
static NSString *const METHOD_STOPQRAUTH = @"stopQrauth";
static NSString *const METHOD_OPENURL = @"openUrl";
static NSString *const METHOD_OPENRANKLIST = @"openRankList";
static NSString *const METHOD_SHARETEXT = @"shareText";
static NSString *const METHOD_SHAREIMAGE = @"shareImage";
static NSString *const METHOD_SHAREFILE = @"shareFile";
static NSString *const METHOD_SHAREEMOJI = @"shareEmoji";
static NSString *const METHOD_SHAREMUSIC = @"shareMusic";
static NSString *const METHOD_SHAREVIDEO = @"shareVideo";
static NSString *const METHOD_SHAREWEBPAGE = @"shareWebpage";
static NSString *const METHOD_SHAREMINIPROGRAM = @"shareMiniProgram";
static NSString *const METHOD_SUBSCRIBEMSG = @"subscribeMsg";
static NSString *const METHOD_LAUNCHMINIPROGRAM = @"launchMiniProgram";
#ifndef NO_PAY
static NSString *const METHOD_PAY = @"pay";
#endif

static NSString *const METHOD_ONAUTHRESP = @"onAuthResp";
static NSString *const METHOD_ONOPENURLRESP = @"onOpenUrlResp";
static NSString *const METHOD_ONSHAREMSGRESP = @"onShareMsgResp";
static NSString *const METHOD_ONSUBSCRIBEMSGRESP = @"onSubscribeMsgResp";
static NSString *const METHOD_ONLAUNCHMINIPROGRAMRESP =
    @"onLaunchMiniProgramResp";
#ifndef NO_PAY
static NSString *const METHOD_ONPAYRESP = @"onPayResp";
#endif
static NSString *const METHOD_ONAUTHGOTQRCODE = @"onAuthGotQrcode";
static NSString *const METHOD_ONAUTHQRCODESCANNED = @"onAuthQrcodeScanned";
static NSString *const METHOD_ONAUTHFINISH = @"onAuthFinish";

static NSString *const ARGUMENT_KEY_APPID = @"appId";
static NSString *const ARGUMENT_KEY_UNIVERSALLINK = @"universalLink";
static NSString *const ARGUMENT_KEY_SCOPE = @"scope";
static NSString *const ARGUMENT_KEY_STATE = @"state";
static NSString *const ARGUMENT_KEY_NONCESTR = @"noncestr";
static NSString *const ARGUMENT_KEY_TIMESTAMP = @"timestamp";
static NSString *const ARGUMENT_KEY_SIGNATURE = @"signature";
static NSString *const ARGUMENT_KEY_URL = @"url";
static NSString *const ARGUMENT_KEY_USERNAME = @"username";
static NSString *const ARGUMENT_KEY_SCENE = @"scene";
static NSString *const ARGUMENT_KEY_TEXT = @"text";
static NSString *const ARGUMENT_KEY_TITLE = @"title";
static NSString *const ARGUMENT_KEY_DESCRIPTION = @"description";
static NSString *const ARGUMENT_KEY_THUMBDATA = @"thumbData";
static NSString *const ARGUMENT_KEY_IMAGEDATA = @"imageData";
static NSString *const ARGUMENT_KEY_IMAGEURI = @"imageUri";
static NSString *const ARGUMENT_KEY_FILEDATA = @"fileData";
static NSString *const ARGUMENT_KEY_FILEURI = @"fileUri";
static NSString *const ARGUMENT_KEY_FILEEXTENSION = @"fileExtension";
static NSString *const ARGUMENT_KEY_EMOJIDATA = @"emojiData";
static NSString *const ARGUMENT_KEY_EMOJIURI = @"emojiUri";
static NSString *const ARGUMENT_KEY_MUSICURL = @"musicUrl";
static NSString *const ARGUMENT_KEY_MUSICDATAURL = @"musicDataUrl";
static NSString *const ARGUMENT_KEY_MUSICLOWBANDURL = @"musicLowBandUrl";
static NSString *const ARGUMENT_KEY_MUSICLOWBANDDATAURL =
    @"musicLowBandDataUrl";
static NSString *const ARGUMENT_KEY_VIDEOURL = @"videoUrl";
static NSString *const ARGUMENT_KEY_VIDEOLOWBANDURL = @"videoLowBandUrl";
static NSString *const ARGUMENT_KEY_WEBPAGEURL = @"webpageUrl";
static NSString *const ARGUMENT_KEY_PATH = @"path";
static NSString *const ARGUMENT_KEY_HDIMAGEDATA = @"hdImageData";
static NSString *const ARGUMENT_KEY_WITHSHARETICKET = @"withShareTicket";
static NSString *const ARGUMENT_KEY_TYPE = @"type";
static NSString *const ARGUMENT_KEY_DISABLEFORWARD = @"disableForward";
static NSString *const ARGUMENT_KEY_TEMPLATEID = @"templateId";
static NSString *const ARGUMENT_KEY_RESERVED = @"reserved";
#ifndef NO_PAY
static NSString *const ARGUMENT_KEY_PARTNERID = @"partnerId";
static NSString *const ARGUMENT_KEY_PREPAYID = @"prepayId";
// static NSString *const ARGUMENT_KEY_NONCESTR = @"noncestr";
// static NSString *const ARGUMENT_KEY_TIMESTAMP = @"timestamp";
static NSString *const ARGUMENT_KEY_PACKAGE = @"package";
static NSString *const ARGUMENT_KEY_SIGN = @"sign";
#endif

static NSString *const ARGUMENT_KEY_RESULT_ERRORCODE = @"errorCode";
static NSString *const ARGUMENT_KEY_RESULT_ERRORMSG = @"errorMsg";
static NSString *const ARGUMENT_KEY_RESULT_CODE = @"code";
static NSString *const ARGUMENT_KEY_RESULT_STATE = @"state";
static NSString *const ARGUMENT_KEY_RESULT_LANG = @"lang";
static NSString *const ARGUMENT_KEY_RESULT_COUNTRY = @"country";
static NSString *const ARGUMENT_KEY_RESULT_TEMPLATEID = @"templateId";
static NSString *const ARGUMENT_KEY_RESULT_SCENE = @"scene";
static NSString *const ARGUMENT_KEY_RESULT_ACTION = @"action";
static NSString *const ARGUMENT_KEY_RESULT_RESERVED = @"reserved";
static NSString *const ARGUMENT_KEY_RESULT_OPENID = @"openId";
static NSString *const ARGUMENT_KEY_RESULT_EXTMSG = @"extMsg";
static NSString *const ARGUMENT_KEY_RESULT_RETURNKEY = @"returnKey";
static NSString *const ARGUMENT_KEY_RESULT_IMAGEDATA = @"imageData";
static NSString *const ARGUMENT_KEY_RESULT_AUTHCODE = @"authCode";

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
        _qrauth = [[WechatAuthSDK alloc] init];
        _qrauth.delegate = self;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
    if ([METHOD_REGISTERAPP isEqualToString:call.method]) {
        NSString *appId = call.arguments[ARGUMENT_KEY_APPID];
        NSString *universalLink = call.arguments[ARGUMENT_KEY_UNIVERSALLINK];
        [WXApi registerApp:appId universalLink:universalLink];
        result(nil);
    } else if ([METHOD_ISINSTALLED isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[WXApi isWXAppInstalled]]);
    } else if ([METHOD_ISSUPPORTAPI isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[WXApi isWXAppSupportApi]]);
    } else if ([METHOD_OPENWECHAT isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[WXApi openWXApp]]);
    } else if ([METHOD_AUTH isEqualToString:call.method]) {
        [self handleAuthCall:call result:result];
    } else if ([METHOD_STARTQRAUTH isEqualToString:call.method] ||
               [METHOD_STOPQRAUTH isEqualToString:call.method]) {
        [self handleQRAuthCall:call result:result];
    } else if ([METHOD_OPENURL isEqualToString:call.method]) {
        [self handleOpenUrlCall:call result:result];
    } else if ([METHOD_OPENRANKLIST isEqualToString:call.method]) {
        [self handleOpenRankListCall:call result:result];
    } else if ([METHOD_SHARETEXT isEqualToString:call.method]) {
        [self handleShareTextCall:call result:result];
    } else if ([METHOD_SHAREIMAGE isEqualToString:call.method] ||
               [METHOD_SHAREFILE isEqualToString:call.method] ||
               [METHOD_SHAREEMOJI isEqualToString:call.method] ||
               [METHOD_SHAREMUSIC isEqualToString:call.method] ||
               [METHOD_SHAREVIDEO isEqualToString:call.method] ||
               [METHOD_SHAREWEBPAGE isEqualToString:call.method] ||
               [METHOD_SHAREMINIPROGRAM isEqualToString:call.method]) {
        [self handleShareMediaCall:call result:result];
    } else if ([METHOD_SUBSCRIBEMSG isEqualToString:call.method]) {
        [self handleSubscribeMsgCall:call result:result];
    } else if ([METHOD_LAUNCHMINIPROGRAM isEqualToString:call.method]) {
        [self handleLaunchMiniProgramCall:call result:result];
    }
#ifndef NO_PAY
    else if ([METHOD_PAY isEqualToString:call.method]) {
        [self handlePayCall:call result:result];
    }
#endif
    else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)handleAuthCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = call.arguments[ARGUMENT_KEY_SCOPE];
    req.state = call.arguments[ARGUMENT_KEY_STATE];
    [WXApi sendReq:req
        completion:^(BOOL success){
            // do nothing
        }];
    result(nil);
}

- (void)handleQRAuthCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
    if ([METHOD_STARTQRAUTH isEqualToString:call.method]) {
        NSString *appId = call.arguments[ARGUMENT_KEY_APPID];
        NSString *scope = call.arguments[ARGUMENT_KEY_SCOPE];
        NSString *noncestr = call.arguments[ARGUMENT_KEY_NONCESTR];
        NSString *timestamp = call.arguments[ARGUMENT_KEY_TIMESTAMP];
        NSString *signature = call.arguments[ARGUMENT_KEY_SIGNATURE];
        [_qrauth Auth:appId
              nonceStr:noncestr
             timeStamp:timestamp
                 scope:scope
             signature:signature
            schemeData:nil];
    } else if ([METHOD_STOPQRAUTH isEqualToString:call.method]) {
        [_qrauth StopAuth];
    }
    result(nil);
}

- (void)handleOpenUrlCall:(FlutterMethodCall *)call
                   result:(FlutterResult)result {
    OpenWebviewReq *req = [[OpenWebviewReq alloc] init];
    req.url = call.arguments[ARGUMENT_KEY_URL];
    [WXApi sendReq:req
        completion:^(BOOL success){
            // do nothing
        }];
    result(nil);
}

- (void)handleOpenRankListCall:(FlutterMethodCall *)call
                        result:(FlutterResult)result {
    OpenRankListReq *req = [[OpenRankListReq alloc] init];
    [WXApi sendReq:req
        completion:^(BOOL success){
            // do nothing
        }];
    result(nil);
}

- (void)handleShareTextCall:(FlutterMethodCall *)call
                     result:(FlutterResult)result {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    NSNumber *scene = call.arguments[ARGUMENT_KEY_SCENE];
    req.scene = [scene intValue];
    req.bText = YES;
    req.text = call.arguments[ARGUMENT_KEY_TEXT];
    [WXApi sendReq:req
        completion:^(BOOL success){
            // do nothing
        }];
    result(nil);
}

- (void)handleShareMediaCall:(FlutterMethodCall *)call
                      result:(FlutterResult)result {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    NSNumber *scene = call.arguments[ARGUMENT_KEY_SCENE];
    req.scene = [scene intValue];
    req.bText = NO;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = call.arguments[ARGUMENT_KEY_TITLE];
    message.description = call.arguments[ARGUMENT_KEY_DESCRIPTION];
    FlutterStandardTypedData *thumbData = call.arguments[ARGUMENT_KEY_THUMBDATA];
    if (thumbData != nil) {
        message.thumbData = thumbData.data;
    }
    if ([METHOD_SHAREIMAGE isEqualToString:call.method]) {
        WXImageObject *mediaObject = [WXImageObject object];
        FlutterStandardTypedData *imageData =
            call.arguments[ARGUMENT_KEY_IMAGEDATA];
        if (imageData != nil) {
            mediaObject.imageData = imageData.data;
        } else {
            NSString *imageUri = call.arguments[ARGUMENT_KEY_IMAGEURI];
            NSURL *imageUrl = [NSURL URLWithString:imageUri];
            mediaObject.imageData = [NSData dataWithContentsOfFile:imageUrl.path];
        }
        message.mediaObject = mediaObject;
    } else if ([METHOD_SHAREFILE isEqualToString:call.method]) {
        WXFileObject *mediaObject = [WXFileObject object];
        FlutterStandardTypedData *fileData = call.arguments[ARGUMENT_KEY_FILEDATA];
        if (fileData != nil) {
            mediaObject.fileData = fileData.data;
        } else {
            NSString *fileUri = call.arguments[ARGUMENT_KEY_FILEURI];
            NSURL *fileUrl = [NSURL URLWithString:fileUri];
            mediaObject.fileData = [NSData dataWithContentsOfFile:fileUrl.path];
        }
        mediaObject.fileExtension = call.arguments[ARGUMENT_KEY_FILEEXTENSION];
        message.mediaObject = mediaObject;
    } else if ([METHOD_SHAREEMOJI isEqualToString:call.method]) {
        WXEmoticonObject *mediaObject = [WXEmoticonObject object];
        FlutterStandardTypedData *emojiData =
            call.arguments[ARGUMENT_KEY_EMOJIDATA];
        if (emojiData != nil) {
            mediaObject.emoticonData = emojiData.data;
        } else {
            NSString *emojiUri = call.arguments[ARGUMENT_KEY_EMOJIURI];
            NSURL *emojiUrl = [NSURL URLWithString:emojiUri];
            mediaObject.emoticonData = [NSData dataWithContentsOfFile:emojiUrl.path];
        }
        message.mediaObject = mediaObject;
    } else if ([METHOD_SHAREMUSIC isEqualToString:call.method]) {
        WXMusicObject *mediaObject = [WXMusicObject object];
        mediaObject.musicUrl = call.arguments[ARGUMENT_KEY_MUSICURL];
        mediaObject.musicDataUrl = call.arguments[ARGUMENT_KEY_MUSICDATAURL];
        mediaObject.musicLowBandUrl = call.arguments[ARGUMENT_KEY_MUSICLOWBANDURL];
        mediaObject.musicLowBandDataUrl =
            call.arguments[ARGUMENT_KEY_MUSICLOWBANDDATAURL];
        message.mediaObject = mediaObject;
    } else if ([METHOD_SHAREVIDEO isEqualToString:call.method]) {
        WXVideoObject *mediaObject = [WXVideoObject object];
        mediaObject.videoUrl = call.arguments[ARGUMENT_KEY_VIDEOURL];
        mediaObject.videoLowBandUrl = call.arguments[ARGUMENT_KEY_VIDEOLOWBANDURL];
        message.mediaObject = mediaObject;
    } else if ([METHOD_SHAREWEBPAGE isEqualToString:call.method]) {
        WXWebpageObject *mediaObject = [WXWebpageObject object];
        mediaObject.webpageUrl = call.arguments[ARGUMENT_KEY_WEBPAGEURL];
        message.mediaObject = mediaObject;
    } else if ([METHOD_SHAREMINIPROGRAM isEqualToString:call.method]) {
        WXMiniProgramObject *mediaObject = [WXMiniProgramObject object];
        mediaObject.webpageUrl = call.arguments[ARGUMENT_KEY_WEBPAGEURL];
        mediaObject.userName = call.arguments[ARGUMENT_KEY_USERNAME];
        mediaObject.path = call.arguments[ARGUMENT_KEY_PATH];
        FlutterStandardTypedData *hdImageData =
            call.arguments[ARGUMENT_KEY_HDIMAGEDATA];
        if (hdImageData != nil) {
            mediaObject.hdImageData = hdImageData.data;
        }
        NSNumber *withShareTicket = call.arguments[ARGUMENT_KEY_WITHSHARETICKET];
        mediaObject.withShareTicket = withShareTicket.boolValue;
        NSNumber *miniProgramType = call.arguments[ARGUMENT_KEY_TYPE];
        mediaObject.miniProgramType = miniProgramType.unsignedIntegerValue;
        NSNumber *disableForward = call.arguments[ARGUMENT_KEY_DISABLEFORWARD];
        mediaObject.disableForward = disableForward.boolValue;
        message.mediaObject = mediaObject;
    }
    req.message = message;
    [WXApi sendReq:req
        completion:^(BOOL success){
            // do nothing
        }];
    result(nil);
}

- (void)handleSubscribeMsgCall:(FlutterMethodCall *)call
                        result:(FlutterResult)result {
    WXSubscribeMsgReq *req = [[WXSubscribeMsgReq alloc] init];
    NSNumber *scene = call.arguments[ARGUMENT_KEY_SCENE];
#if __LP64__
    req.scene = [scene unsignedIntValue];
#else
    req.scene = [scene unsignedLongValue];
#endif
    req.templateId = call.arguments[ARGUMENT_KEY_TEMPLATEID];
    req.reserved = call.arguments[ARGUMENT_KEY_RESERVED];
    [WXApi sendReq:req
        completion:^(BOOL success){
            // do nothing
        }];
    result(nil);
}

- (void)handleLaunchMiniProgramCall:(FlutterMethodCall *)call
                             result:(FlutterResult)result {
    WXLaunchMiniProgramReq *req = [[WXLaunchMiniProgramReq alloc] init];
    req.userName = call.arguments[ARGUMENT_KEY_USERNAME];
    req.path = call.arguments[ARGUMENT_KEY_PATH];
    NSNumber *miniProgramType = call.arguments[ARGUMENT_KEY_TYPE];
    req.miniProgramType = miniProgramType.unsignedIntegerValue;
    [WXApi sendReq:req
        completion:^(BOOL success){
            // do nothing
        }];
    result(nil);
}

#ifndef NO_PAY
- (void)handlePayCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = call.arguments[ARGUMENT_KEY_PARTNERID];
    req.prepayId = call.arguments[ARGUMENT_KEY_PREPAYID];
    req.nonceStr = call.arguments[ARGUMENT_KEY_NONCESTR];
    NSString *timeStamp = call.arguments[ARGUMENT_KEY_TIMESTAMP];
    req.timeStamp = [timeStamp intValue];
    req.package = call.arguments[ARGUMENT_KEY_PACKAGE];
    req.sign = call.arguments[ARGUMENT_KEY_SIGN];
    [WXApi sendReq:req
        completion:^(BOOL success){
            // do nothing
        }];
    result(nil);
}
#endif

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
              openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:
                (NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
    continueUserActivity:(NSUserActivity *)userActivity
      restorationHandler:(void (^)(NSArray *_Nonnull))restorationHandler {
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq *)req {
}

- (void)onResp:(BaseResp *)resp {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:[NSNumber numberWithInt:resp.errCode]
                  forKey:ARGUMENT_KEY_RESULT_ERRORCODE];
    if (resp.errStr != nil) {
        [dictionary setValue:resp.errStr forKey:ARGUMENT_KEY_RESULT_ERRORMSG];
    }
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        // 授权
        if (resp.errCode == WXSuccess) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [dictionary setValue:authResp.code forKey:ARGUMENT_KEY_RESULT_CODE];
            [dictionary setValue:authResp.state forKey:ARGUMENT_KEY_RESULT_STATE];
            [dictionary setValue:authResp.lang forKey:ARGUMENT_KEY_RESULT_LANG];
            [dictionary setValue:authResp.country forKey:ARGUMENT_KEY_RESULT_COUNTRY];
        }
        [_channel invokeMethod:METHOD_ONAUTHRESP arguments:dictionary];
    } else if ([resp isKindOfClass:[OpenWebviewResp class]]) {
        // 浏览器
        [_channel invokeMethod:METHOD_ONOPENURLRESP arguments:dictionary];
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        // 分享
        [_channel invokeMethod:METHOD_ONSHAREMSGRESP arguments:dictionary];
    } else if ([resp isKindOfClass:[WXSubscribeMsgResp class]]) {
        // 一次性订阅消息
        if (resp.errCode == WXSuccess) {
            WXSubscribeMsgResp *subscribeMsgResp = (WXSubscribeMsgResp *)resp;
            [dictionary setValue:subscribeMsgResp.templateId
                          forKey:ARGUMENT_KEY_RESULT_TEMPLATEID];
            [dictionary
                setValue:[NSNumber numberWithUnsignedInt:subscribeMsgResp.scene]
                  forKey:ARGUMENT_KEY_RESULT_SCENE];
            [dictionary setValue:subscribeMsgResp.action
                          forKey:ARGUMENT_KEY_RESULT_ACTION];
            [dictionary setValue:subscribeMsgResp.reserved
                          forKey:ARGUMENT_KEY_RESULT_RESERVED];
            [dictionary setValue:subscribeMsgResp.openId
                          forKey:ARGUMENT_KEY_RESULT_OPENID];
        }
        [_channel invokeMethod:METHOD_ONSUBSCRIBEMSGRESP arguments:dictionary];
    } else if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]) {
        // 打开小程序
        if (resp.errCode == WXSuccess) {
            WXLaunchMiniProgramResp *launchMiniProgramResp =
                (WXLaunchMiniProgramResp *)resp;
            [dictionary setValue:launchMiniProgramResp.extMsg
                          forKey:ARGUMENT_KEY_RESULT_EXTMSG];
        }
        [_channel invokeMethod:METHOD_ONLAUNCHMINIPROGRAMRESP arguments:dictionary];
    } else {
#ifndef NO_PAY
        if ([resp isKindOfClass:[PayResp class]]) {
            // 支付
            if (resp.errCode == WXSuccess) {
                PayResp *payResp = (PayResp *)resp;
                [dictionary setValue:payResp.returnKey
                              forKey:ARGUMENT_KEY_RESULT_RETURNKEY];
            }
            [_channel invokeMethod:METHOD_ONPAYRESP arguments:dictionary];
        }
#endif
    }
}

#pragma mark - WechatAuthAPIDelegate

- (void)onAuthGotQrcode:(UIImage *)image {
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData == nil) {
        imageData = UIImageJPEGRepresentation(image, 1);
    }
    NSDictionary *dictionary = @{
        ARGUMENT_KEY_RESULT_IMAGEDATA : imageData,
    };
    [_channel invokeMethod:METHOD_ONAUTHGOTQRCODE arguments:dictionary];
}

- (void)onQrcodeScanned {
    [_channel invokeMethod:METHOD_ONAUTHQRCODESCANNED arguments:nil];
}

- (void)onAuthFinish:(int)errCode AuthCode:(NSString *)authCode {
    NSDictionary *dictionary = @{
        ARGUMENT_KEY_RESULT_ERRORCODE : [NSNumber numberWithInt:errCode],
        ARGUMENT_KEY_RESULT_AUTHCODE : authCode,
    };
    [_channel invokeMethod:METHOD_ONAUTHFINISH arguments:dictionary];
}

@end
