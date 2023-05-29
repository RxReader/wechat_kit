#import "WechatKitPlugin.h"
#ifdef NO_PAY
#import <WXApi.h>
#import <WechatAuthSDK.h>
#else
#import <WXApi.h>
#import <WechatAuthSDK.h>
#endif

typedef void (^WechatKitWXReqRunnable)(void);

@interface WechatKitPlugin () <WXApiDelegate, WechatAuthAPIDelegate>

@end

@implementation WechatKitPlugin {
    FlutterMethodChannel *_channel;
    WechatAuthSDK *_qrauth;
    BOOL _isRunning;
    BOOL _handleInitialWXReqFlag;
    WechatKitWXReqRunnable _initialWXReqRunnable;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel =
        [FlutterMethodChannel methodChannelWithName:@"v7lin.github.io/wechat_kit"
                                    binaryMessenger:[registrar messenger]];
    WechatKitPlugin *instance = [[WechatKitPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
        _qrauth = [[WechatAuthSDK alloc] init];
        _qrauth.delegate = self;
        _isRunning = NO;
        _handleInitialWXReqFlag = NO;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
    if ([@"registerApp" isEqualToString:call.method]) {
        NSString *appId = call.arguments[@"appId"];
        NSString *universalLink = call.arguments[@"universalLink"];
        [WXApi registerApp:appId universalLink:universalLink];
        _isRunning = YES;
        result(nil);
    } else if ([@"handleInitialWXReq" isEqualToString:call.method]) {
        if (!_handleInitialWXReqFlag) {
            _handleInitialWXReqFlag = YES;
            if (_initialWXReqRunnable != nil) {
                _initialWXReqRunnable();
                _initialWXReqRunnable = nil;
            }
            result(nil);
        } else {
            result([FlutterError errorWithCode:@"FAILED" message:nil details:nil]);
        }
    } else if ([@"isInstalled" isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[WXApi isWXAppInstalled]]);
    } else if ([@"isSupportApi" isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[WXApi isWXAppSupportApi]]);
    } else if ([@"isSupportStateApi" isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[WXApi isWXAppSupportStateAPI]]);
    } else if ([@"openWechat" isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[WXApi openWXApp]]);
    } else if ([@"auth" isEqualToString:call.method]) {
        [self handleAuthCall:call result:result];
    } else if ([@"startQrauth" isEqualToString:call.method] ||
               [@"stopQrauth" isEqualToString:call.method]) {
        [self handleQRAuthCall:call result:result];
    } else if ([@"openUrl" isEqualToString:call.method]) {
        [self handleOpenUrlCall:call result:result];
    } else if ([@"openRankList" isEqualToString:call.method]) {
        [self handleOpenRankListCall:call result:result];
    } else if ([@"shareText" isEqualToString:call.method]) {
        [self handleShareTextCall:call result:result];
    } else if ([@"shareImage" isEqualToString:call.method] ||
               [@"shareFile" isEqualToString:call.method] ||
               [@"shareEmoji" isEqualToString:call.method] ||
               [@"shareMusic" isEqualToString:call.method] ||
               [@"shareVideo" isEqualToString:call.method] ||
               [@"shareWebpage" isEqualToString:call.method] ||
               [@"shareMiniProgram" isEqualToString:call.method]) {
        [self handleShareMediaCall:call result:result];
    } else if ([@"subscribeMsg" isEqualToString:call.method]) {
        [self handleSubscribeMsgCall:call result:result];
    } else if ([@"launchMiniProgram" isEqualToString:call.method]) {
        [self handleLaunchMiniProgramCall:call result:result];
    } else if ([@"openCustomerServiceChat" isEqualToString:call.method]) {
        [self handleOpenCustomerServiceChatCall:call result:result];
    } else if ([@"openBusinessView" isEqualToString:call.method]) {
        [self handleOpenBusinessViewCall:call result:result];
    } else if ([@"openBusinessWebview" isEqualToString:call.method]) {
        [self handleOpenBusinessWebviewCall:call result:result];
    }
#ifndef NO_PAY
    else if ([@"pay" isEqualToString:call.method]) {
        [self handlePayCall:call result:result];
    }
#endif
    else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)handleAuthCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = call.arguments[@"scope"];
    req.state = call.arguments[@"state"];
    NSNumber *type = call.arguments[@"type"];
    if ([type intValue] == 0) {
        [WXApi sendReq:req
            completion:^(BOOL success){
                result([NSNumber numberWithBool:success]);
            }];
    } else if ([type intValue] == 1) {
        UIViewController *viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [WXApi sendAuthReq:req
            viewController:viewController
                  delegate:self
                completion:^(BOOL success){
                    result([NSNumber numberWithBool:success]);
                }];
    }
}

- (void)handleQRAuthCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
    if ([@"startQrauth" isEqualToString:call.method]) {
        NSString *appId = call.arguments[@"appId"];
        NSString *scope = call.arguments[@"scope"];
        NSString *noncestr = call.arguments[@"noncestr"];
        NSString *timestamp = call.arguments[@"timestamp"];
        NSString *signature = call.arguments[@"signature"];
        [_qrauth Auth:appId
              nonceStr:noncestr
             timeStamp:timestamp
                 scope:scope
             signature:signature
            schemeData:nil];
    } else if ([@"stopQrauth" isEqualToString:call.method]) {
        [_qrauth StopAuth];
    }
    result(nil);
}

- (void)handleOpenUrlCall:(FlutterMethodCall *)call
                   result:(FlutterResult)result {
    OpenWebviewReq *req = [[OpenWebviewReq alloc] init];
    req.url = call.arguments[@"url"];
    [WXApi sendReq:req
        completion:^(BOOL success){
            result([NSNumber numberWithBool:success]);
        }];
}

- (void)handleOpenRankListCall:(FlutterMethodCall *)call
                        result:(FlutterResult)result {
    OpenRankListReq *req = [[OpenRankListReq alloc] init];
    [WXApi sendReq:req
        completion:^(BOOL success){
            result([NSNumber numberWithBool:success]);
        }];
}

- (void)handleShareTextCall:(FlutterMethodCall *)call
                     result:(FlutterResult)result {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    NSNumber *scene = call.arguments[@"scene"];
    req.scene = [scene intValue];
    req.bText = YES;
    req.text = call.arguments[@"text"];
    [WXApi sendReq:req
        completion:^(BOOL success){
            result([NSNumber numberWithBool:success]);
        }];
}

- (void)handleShareMediaCall:(FlutterMethodCall *)call
                      result:(FlutterResult)result {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    NSNumber *scene = call.arguments[@"scene"];
    req.scene = [scene intValue];
    req.bText = NO;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = call.arguments[@"title"];
    message.description = call.arguments[@"description"];
    FlutterStandardTypedData *thumbData = call.arguments[@"thumbData"];
    if (thumbData != nil) {
        message.thumbData = thumbData.data;
    }
    if ([@"shareImage" isEqualToString:call.method]) {
        WXImageObject *mediaObject = [WXImageObject object];
        FlutterStandardTypedData *imageData =
            call.arguments[@"imageData"];
        if (imageData != nil) {
            mediaObject.imageData = imageData.data;
        } else {
            NSString *imageUri = call.arguments[@"imageUri"];
            NSURL *imageUrl = [NSURL URLWithString:imageUri];
            mediaObject.imageData = [NSData dataWithContentsOfFile:imageUrl.path];
        }
        message.mediaObject = mediaObject;
    } else if ([@"shareFile" isEqualToString:call.method]) {
        WXFileObject *mediaObject = [WXFileObject object];
        FlutterStandardTypedData *fileData = call.arguments[@"fileData"];
        if (fileData != nil) {
            mediaObject.fileData = fileData.data;
        } else {
            NSString *fileUri = call.arguments[@"fileUri"];
            NSURL *fileUrl = [NSURL URLWithString:fileUri];
            mediaObject.fileData = [NSData dataWithContentsOfFile:fileUrl.path];
        }
        mediaObject.fileExtension = call.arguments[@"fileExtension"];
        message.mediaObject = mediaObject;
    } else if ([@"shareEmoji" isEqualToString:call.method]) {
        WXEmoticonObject *mediaObject = [WXEmoticonObject object];
        FlutterStandardTypedData *emojiData =
            call.arguments[@"emojiData"];
        if (emojiData != nil) {
            mediaObject.emoticonData = emojiData.data;
        } else {
            NSString *emojiUri = call.arguments[@"emojiUri"];
            NSURL *emojiUrl = [NSURL URLWithString:emojiUri];
            mediaObject.emoticonData = [NSData dataWithContentsOfFile:emojiUrl.path];
        }
        message.mediaObject = mediaObject;
    } else if ([@"shareMusic" isEqualToString:call.method]) {
        WXMusicObject *mediaObject = [WXMusicObject object];
        mediaObject.musicUrl = call.arguments[@"musicUrl"];
        mediaObject.musicDataUrl = call.arguments[@"musicDataUrl"];
        mediaObject.musicLowBandUrl = call.arguments[@"musicLowBandUrl"];
        mediaObject.musicLowBandDataUrl =
            call.arguments[@"musicLowBandDataUrl"];
        message.mediaObject = mediaObject;
    } else if ([@"shareVideo" isEqualToString:call.method]) {
        WXVideoObject *mediaObject = [WXVideoObject object];
        mediaObject.videoUrl = call.arguments[@"videoUrl"];
        mediaObject.videoLowBandUrl = call.arguments[@"videoLowBandUrl"];
        message.mediaObject = mediaObject;
    } else if ([@"shareWebpage" isEqualToString:call.method]) {
        WXWebpageObject *mediaObject = [WXWebpageObject object];
        mediaObject.webpageUrl = call.arguments[@"webpageUrl"];
        message.mediaObject = mediaObject;
    } else if ([@"shareMiniProgram" isEqualToString:call.method]) {
        WXMiniProgramObject *mediaObject = [WXMiniProgramObject object];
        mediaObject.webpageUrl = call.arguments[@"webpageUrl"];
        mediaObject.userName = call.arguments[@"username"];
        mediaObject.path = call.arguments[@"path"];
        FlutterStandardTypedData *hdImageData =
            call.arguments[@"hdImageData"];
        if (hdImageData != nil) {
            mediaObject.hdImageData = hdImageData.data;
        }
        NSNumber *withShareTicket = call.arguments[@"withShareTicket"];
        mediaObject.withShareTicket = withShareTicket.boolValue;
        NSNumber *miniProgramType = call.arguments[@"type"];
        mediaObject.miniProgramType = miniProgramType.unsignedIntegerValue;
        NSNumber *disableForward = call.arguments[@"disableForward"];
        mediaObject.disableForward = disableForward.boolValue;
        message.mediaObject = mediaObject;
    }
    req.message = message;
    [WXApi sendReq:req
        completion:^(BOOL success){
            result([NSNumber numberWithBool:success]);
        }];
}

- (void)handleSubscribeMsgCall:(FlutterMethodCall *)call
                        result:(FlutterResult)result {
    WXSubscribeMsgReq *req = [[WXSubscribeMsgReq alloc] init];
    NSNumber *scene = call.arguments[@"scene"];
#if __LP64__
    req.scene = [scene unsignedIntValue];
#else
    req.scene = [scene unsignedLongValue];
#endif
    req.templateId = call.arguments[@"templateId"];
    req.reserved = call.arguments[@"reserved"];
    [WXApi sendReq:req
        completion:^(BOOL success){
            result([NSNumber numberWithBool:success]);
        }];
}

- (void)handleLaunchMiniProgramCall:(FlutterMethodCall *)call
                             result:(FlutterResult)result {
    WXLaunchMiniProgramReq *req = [[WXLaunchMiniProgramReq alloc] init];
    req.userName = call.arguments[@"username"];
    req.path = call.arguments[@"path"];
    NSNumber *miniProgramType = call.arguments[@"type"];
    req.miniProgramType = miniProgramType.unsignedIntegerValue;
    [WXApi sendReq:req
        completion:^(BOOL success){
            result([NSNumber numberWithBool:success]);
        }];
}

- (void)handleOpenCustomerServiceChatCall:(FlutterMethodCall *)call
                                   result:(FlutterResult)result {
    WXOpenCustomerServiceReq *req = [[WXOpenCustomerServiceReq alloc] init];
    req.corpid = call.arguments[@"corpId"];
    req.url = call.arguments[@"url"];
    [WXApi sendReq:req
        completion:^(BOOL success){
            result([NSNumber numberWithBool:success]);
        }];
}

- (void)handleOpenBusinessViewCall:(FlutterMethodCall *)call
                            result:(FlutterResult)result {
    WXOpenBusinessViewReq *req = [[WXOpenBusinessViewReq alloc] init];
    req.businessType = call.arguments[@"businessType"];
    req.query = call.arguments[@"query"];
    req.extInfo = call.arguments[@"extInfo"];
    [WXApi sendReq:req
        completion:^(BOOL success){
            result([NSNumber numberWithBool:success]);
        }];
}

- (void)handleOpenBusinessWebviewCall:(FlutterMethodCall *)call
                               result:(FlutterResult)result {
    WXOpenBusinessWebViewReq *req = [[WXOpenBusinessWebViewReq alloc] init];
    NSNumber *businessType = call.arguments[@"businessType"];
#if __LP64__
    req.businessType = [businessType unsignedIntValue];
#else
    req.businessType = [businessType unsignedLongValue];
#endif
    req.queryInfoDic = call.arguments[@"queryInfo"];
    result(nil);
}

#ifndef NO_PAY
- (void)handlePayCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = call.arguments[@"partnerId"];
    req.prepayId = call.arguments[@"prepayId"];
    req.nonceStr = call.arguments[@"noncestr"];
    NSString *timeStamp = call.arguments[@"timestamp"];
    req.timeStamp = [timeStamp intValue];
    req.package = call.arguments[@"package"];
    req.sign = call.arguments[@"sign"];
    [WXApi sendReq:req
        completion:^(BOOL success){
            result([NSNumber numberWithBool:success]);
        }];
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
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        LaunchFromWXReq *launchFromWXReq = (LaunchFromWXReq *)req;
        [dictionary setValue:launchFromWXReq.message.messageAction forKey:@"messageAction"];
        [dictionary setValue:launchFromWXReq.message.messageExt forKey:@"messageExt"];
        [dictionary setValue:launchFromWXReq.lang forKey:@"lang"];
        [dictionary setValue:launchFromWXReq.country forKey:@"country"];
        if (_isRunning) {
            [_channel invokeMethod:@"onLaunchFromWXReq" arguments:dictionary];
        } else {
            __weak typeof(self) weakSelf = self;
            _initialWXReqRunnable = ^() {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf->_channel invokeMethod:@"onLaunchFromWXReq" arguments:dictionary];
            };
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        ShowMessageFromWXReq *showMessageFromWXReq = (ShowMessageFromWXReq *)req;
        [dictionary setValue:showMessageFromWXReq.message.messageAction forKey:@"messageAction"];
        [dictionary setValue:showMessageFromWXReq.message.messageExt forKey:@"messageExt"];
        [dictionary setValue:showMessageFromWXReq.lang forKey:@"lang"];
        [dictionary setValue:showMessageFromWXReq.country forKey:@"country"];
        if (_isRunning) {
            [_channel invokeMethod:@"onShowMessageFromWXReq" arguments:dictionary];
        } else {
            __weak typeof(self) weakSelf = self;
            _initialWXReqRunnable = ^() {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf->_channel invokeMethod:@"onShowMessageFromWXReq" arguments:dictionary];
            };
        }
    }
}

- (void)onResp:(BaseResp *)resp {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:[NSNumber numberWithInt:resp.errCode]
                  forKey:@"errorCode"];
    if (resp.errStr != nil) {
        [dictionary setValue:resp.errStr forKey:@"errorMsg"];
    }
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        // 授权
        if (resp.errCode == WXSuccess) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [dictionary setValue:authResp.code forKey:@"code"];
            [dictionary setValue:authResp.state forKey:@"state"];
            [dictionary setValue:authResp.lang forKey:@"lang"];
            [dictionary setValue:authResp.country forKey:@"country"];
        }
        [_channel invokeMethod:@"onAuthResp" arguments:dictionary];
    } else if ([resp isKindOfClass:[OpenWebviewResp class]]) {
        // 浏览器
        [_channel invokeMethod:@"onOpenUrlResp" arguments:dictionary];
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        // 分享
        [_channel invokeMethod:@"onShareMsgResp" arguments:dictionary];
    } else if ([resp isKindOfClass:[WXSubscribeMsgResp class]]) {
        // 一次性订阅消息
        if (resp.errCode == WXSuccess) {
            WXSubscribeMsgResp *subscribeMsgResp = (WXSubscribeMsgResp *)resp;
            [dictionary setValue:subscribeMsgResp.openId
                          forKey:@"openId"];
            [dictionary setValue:subscribeMsgResp.templateId
                          forKey:@"templateId"];
            [dictionary
                setValue:[NSNumber numberWithUnsignedInt:subscribeMsgResp.scene]
                  forKey:@"scene"];
            [dictionary setValue:subscribeMsgResp.action
                          forKey:@"action"];
            [dictionary setValue:subscribeMsgResp.reserved
                          forKey:@"reserved"];
        }
        [_channel invokeMethod:@"onSubscribeMsgResp" arguments:dictionary];
    } else if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]) {
        // 打开小程序
        if (resp.errCode == WXSuccess) {
            WXLaunchMiniProgramResp *launchMiniProgramResp =
                (WXLaunchMiniProgramResp *)resp;
            [dictionary setValue:launchMiniProgramResp.extMsg
                          forKey:@"extMsg"];
        }
        [_channel invokeMethod:@"onLaunchMiniProgramResp" arguments:dictionary];
    } else if ([resp isKindOfClass:[WXOpenCustomerServiceResp class]]) {
        [_channel invokeMethod:@"onOpenCustomerServiceChatResp" arguments:dictionary];
    } else if ([resp isKindOfClass:[WXOpenBusinessViewResp class]]) {
        if (resp.errCode == WXSuccess) {
            WXOpenBusinessViewResp *openBusinessViewResp = (WXOpenBusinessViewResp *)resp;
            [dictionary setValue:openBusinessViewResp.businessType forKey:@"businessType"];
            [dictionary setValue:openBusinessViewResp.extMsg forKey:@"extMsg"];
        }
        [_channel invokeMethod:@"onOpenBusinessViewResp" arguments:dictionary];
    } else if ([resp isKindOfClass:[WXOpenBusinessWebViewResp class]]) {
        if (resp.errCode == WXSuccess) {
            WXOpenBusinessWebViewResp *openBusinessWebviewResp = (WXOpenBusinessWebViewResp *)resp;
            [dictionary setValue:[NSNumber numberWithUnsignedInt:openBusinessWebviewResp.businessType] forKey:@"businessType"];
            [dictionary setValue:openBusinessWebviewResp.result forKey:@"resultInfo"];
        }
        [_channel invokeMethod:@"onOpenBusinessWebviewResp" arguments:dictionary];
    }
#ifndef NO_PAY
    else if ([resp isKindOfClass:[PayResp class]]) {
        // 支付
        if (resp.errCode == WXSuccess) {
            PayResp *payResp = (PayResp *)resp;
            [dictionary setValue:payResp.returnKey forKey:@"returnKey"];
        }
        [_channel invokeMethod:@"onPayResp" arguments:dictionary];
    }
#endif
}

#pragma mark - WechatAuthAPIDelegate

- (void)onAuthGotQrcode:(UIImage *)image {
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData == nil) {
        imageData = UIImageJPEGRepresentation(image, 1);
    }
    NSDictionary *dictionary = @{
        @"imageData" : imageData,
    };
    [_channel invokeMethod:@"onAuthGotQrcode" arguments:dictionary];
}

- (void)onQrcodeScanned {
    [_channel invokeMethod:@"onAuthQrcodeScanned" arguments:nil];
}

- (void)onAuthFinish:(int)errCode AuthCode:(NSString *)authCode {
    NSDictionary *dictionary = @{
        @"errorCode" : [NSNumber numberWithInt:errCode],
        @"authCode" : authCode,
    };
    [_channel invokeMethod:@"onAuthFinish" arguments:dictionary];
}

@end
