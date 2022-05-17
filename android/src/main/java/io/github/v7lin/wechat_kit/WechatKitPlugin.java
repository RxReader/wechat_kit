package io.github.v7lin.wechat_kit;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ProviderInfo;
import android.net.Uri;

import androidx.annotation.NonNull;
import androidx.core.content.FileProvider;

import com.tencent.mm.opensdk.constants.Build;
import com.tencent.mm.opensdk.diffdev.DiffDevOAuthFactory;
import com.tencent.mm.opensdk.diffdev.IDiffDevOAuth;
import com.tencent.mm.opensdk.diffdev.OAuthErrCode;
import com.tencent.mm.opensdk.diffdev.OAuthListener;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.modelbiz.OpenRankList;
import com.tencent.mm.opensdk.modelbiz.OpenWebview;
import com.tencent.mm.opensdk.modelbiz.SubscribeMessage;
import com.tencent.mm.opensdk.modelbiz.WXLaunchMiniProgram;
import com.tencent.mm.opensdk.modelbiz.WXOpenBusinessView;
import com.tencent.mm.opensdk.modelbiz.WXOpenBusinessWebview;
import com.tencent.mm.opensdk.modelbiz.WXOpenCustomerServiceChat;
import com.tencent.mm.opensdk.modelmsg.LaunchFromWX;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;
import com.tencent.mm.opensdk.modelmsg.ShowMessageFromWX;
import com.tencent.mm.opensdk.modelmsg.WXEmojiObject;
import com.tencent.mm.opensdk.modelmsg.WXFileObject;
import com.tencent.mm.opensdk.modelmsg.WXImageObject;
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage;
import com.tencent.mm.opensdk.modelmsg.WXMiniProgramObject;
import com.tencent.mm.opensdk.modelmsg.WXMusicObject;
import com.tencent.mm.opensdk.modelmsg.WXTextObject;
import com.tencent.mm.opensdk.modelmsg.WXVideoObject;
import com.tencent.mm.opensdk.modelmsg.WXWebpageObject;
import com.tencent.mm.opensdk.modelpay.PayReq;
import com.tencent.mm.opensdk.modelpay.PayResp;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/**
 * WechatKitPlugin
 */
public class WechatKitPlugin implements FlutterPlugin, ActivityAware, PluginRegistry.NewIntentListener, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context applicationContext;
    private ActivityPluginBinding activityPluginBinding;

    private final IDiffDevOAuth qrauth = DiffDevOAuthFactory.getDiffDevOAuth();

    private IWXAPI iwxapi;
    private AtomicBoolean handleInitialWXReqFlag = new AtomicBoolean(false);

    // --- FlutterPlugin

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "v7lin.github.io/wechat_kit");
        channel.setMethodCallHandler(this);
        applicationContext = binding.getApplicationContext();
    }


    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        channel = null;
        applicationContext = null;
    }

    // --- ActivityAware

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activityPluginBinding = binding;
        activityPluginBinding.addOnNewIntentListener(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        qrauth.removeAllListeners();
        activityPluginBinding = null;
    }

    // --- NewIntentListener

    @Override
    public boolean onNewIntent(@NonNull Intent intent) {
        final Intent resp = WechatCallbackActivity.extraCallback(intent);
        if (resp != null) {
            if (iwxapi != null) {
                iwxapi.handleIntent(resp, iwxapiEventHandler);
            }
            return true;
        }
        return false;
    }

    private final IWXAPIEventHandler iwxapiEventHandler = new IWXAPIEventHandler() {
        @Override
        public void onReq(BaseReq req) {
            final Map<String, Object> map = new HashMap<>();
            if (req instanceof LaunchFromWX.Req) {
                final LaunchFromWX.Req launchFromWXReq = (LaunchFromWX.Req) req;
                map.put("messageAction", launchFromWXReq.messageAction);
                map.put("messageExt", launchFromWXReq.messageExt);
                map.put("lang", launchFromWXReq.lang);
                map.put("country", launchFromWXReq.country);
                if (channel != null) {
                    channel.invokeMethod("onLaunchFromWXReq", map);
                }
            } else if (req instanceof ShowMessageFromWX.Req) {
                final ShowMessageFromWX.Req showMessageFromWXReq = (ShowMessageFromWX.Req) req;
                map.put("messageAction", showMessageFromWXReq.message.messageAction);
                map.put("messageExt", showMessageFromWXReq.message.messageExt);
                map.put("lang", showMessageFromWXReq.lang);
                map.put("country", showMessageFromWXReq.country);
                if (channel != null) {
                    channel.invokeMethod("onShowMessageFromWXReq", map);
                }
            }
        }

        @Override
        public void onResp(BaseResp resp) {
            final Map<String, Object> map = new HashMap<>();
            map.put("errorCode", resp.errCode);
            map.put("errorMsg", resp.errStr);
            if (resp instanceof SendAuth.Resp) {
                // 授权
                if (resp.errCode == BaseResp.ErrCode.ERR_OK) {
                    final SendAuth.Resp authResp = (SendAuth.Resp) resp;
                    map.put("code", authResp.code);
                    map.put("state", authResp.state);
                    map.put("lang", authResp.lang);
                    map.put("country", authResp.country);
                }
                if (channel != null) {
                    channel.invokeMethod("onAuthResp", map);
                }
            } else if (resp instanceof OpenWebview.Resp) {
                // 浏览器
                if (channel != null) {
                    channel.invokeMethod("onOpenUrlResp", map);
                }
            } else if (resp instanceof SendMessageToWX.Resp) {
                // 分享
                if (channel != null) {
                    channel.invokeMethod("onShareMsgResp", map);
                }
            } else if (resp instanceof SubscribeMessage.Resp) {
                // 一次性订阅消息
                if (resp.errCode == BaseResp.ErrCode.ERR_OK) {
                    final SubscribeMessage.Resp subscribeMsgResp = (SubscribeMessage.Resp) resp;
                    map.put("templateId", subscribeMsgResp.templateID);
                    map.put("scene", subscribeMsgResp.scene);
                    map.put("action", subscribeMsgResp.action);
                    map.put("reserved", subscribeMsgResp.reserved);
                }
                if (channel != null) {
                    channel.invokeMethod("onSubscribeMsgResp", map);
                }
            } else if (resp instanceof WXLaunchMiniProgram.Resp) {
                // 打开小程序
                if (resp.errCode == BaseResp.ErrCode.ERR_OK) {
                    final WXLaunchMiniProgram.Resp launchMiniProgramResp = (WXLaunchMiniProgram.Resp) resp;
                    map.put("extMsg", launchMiniProgramResp.extMsg);
                }
                if (channel != null) {
                    channel.invokeMethod("onLaunchMiniProgramResp", map);
                }
            } else if (resp instanceof WXOpenCustomerServiceChat.Resp) {
                if (channel != null) {
                    channel.invokeMethod("onOpenCustomerServiceChatResp", map);
                }
            } else if (resp instanceof WXOpenBusinessView.Resp) {
                if (resp.errCode == BaseResp.ErrCode.ERR_OK) {
                    final WXOpenBusinessView.Resp openBusinessViewResp = (WXOpenBusinessView.Resp) resp;
                    map.put("businessType", openBusinessViewResp.businessType);
                    map.put("extMsg", openBusinessViewResp.extMsg);
                }
                if (channel != null) {
                    channel.invokeMethod("onOpenBusinessViewResp", map);
                }
            } else if (resp instanceof WXOpenBusinessWebview.Resp) {
                if (resp.errCode == BaseResp.ErrCode.ERR_OK) {
                    final WXOpenBusinessWebview.Resp openBusinessWebviewResp = (WXOpenBusinessWebview.Resp) resp;
                    map.put("businessType", openBusinessWebviewResp.businessType);
                    map.put("resultInfo", openBusinessWebviewResp.resultInfo);
                }
                if (channel != null) {
                    channel.invokeMethod("onOpenBusinessWebviewResp", map);
                }
            } else if (resp instanceof PayResp) {
                // 支付
                if (resp.errCode == BaseResp.ErrCode.ERR_OK) {
                    final PayResp payResp = (PayResp) resp;
                    map.put("returnKey", payResp.returnKey);
                }
                if (channel != null) {
                    channel.invokeMethod("onPayResp", map);
                }
            }
        }
    };

    // --- MethodCallHandler

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if ("registerApp".equals(call.method)) {
            registerApp(call, result);
        } else if ("handleInitialWXReq".equals(call.method)) {
            handleInitialWXReq(call, result);
        } else if ("isInstalled".equals(call.method)) {
            result.success(iwxapi != null && iwxapi.isWXAppInstalled());
        } else if ("isSupportApi".equals(call.method)) {
            result.success(iwxapi != null && iwxapi.getWXAppSupportAPI() >= Build.OPENID_SUPPORTED_SDK_INT);
        } else if ("isSupportStateApi".equals(call.method)) {
            result.success(iwxapi != null && iwxapi.getWXAppSupportAPI() >= Build.SUPPORTED_SEND_TO_STATUS);
        } else if ("openWechat".equals(call.method)) {
            result.success(iwxapi != null && iwxapi.openWXApp());
        } else if ("auth".equals(call.method)) {
            handleAuthCall(call, result);
        } else if ("startQrauth".equals(call.method) ||
                "stopQrauth".equals(call.method)) {
            handleQRAuthCall(call, result);
        } else if ("openUrl".equals(call.method)) {
            handleOpenUrlCall(call, result);
        } else if ("openRankList".equals(call.method)) {
            handleOpenRankListCall(call, result);
        } else if ("shareText".equals(call.method)) {
            handleShareTextCall(call, result);
        } else if ("shareImage".equals(call.method) ||
                "shareFile".equals(call.method) ||
                "shareEmoji".equals(call.method) ||
                "shareMusic".equals(call.method) ||
                "shareVideo".equals(call.method) ||
                "shareWebpage".equals(call.method) ||
                "shareMiniProgram".equals(call.method)) {
            handleShareMediaCall(call, result);
        } else if ("subscribeMsg".equals(call.method)) {
            handleSubscribeMsgCall(call, result);
        } else if ("launchMiniProgram".equals(call.method)) {
            handleLaunchMiniProgramCall(call, result);
        } else if ("openCustomerServiceChat".equals(call.method)) {
            handleOpenCustomerServiceChat(call, result);
        } else if ("openBusinessView".equals(call.method)) {
            handleOpenBusinessView(call, result);
        } else if ("openBusinessWebview".equals(call.method)) {
            handleOpenBusinessWebview(call, result);
        } else if ("pay".equals(call.method)) {
            handlePayCall(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void registerApp(@NonNull MethodCall call, @NonNull Result result) {
        final String appId = call.argument("appId");
//        final String universalLink = call.argument("universalLink");
        iwxapi = WXAPIFactory.createWXAPI(applicationContext, appId);
        iwxapi.registerApp(appId);
        result.success(null);
    }

    private void handleInitialWXReq(@NonNull MethodCall call, @NonNull Result result) {
        if (handleInitialWXReqFlag.compareAndSet(false, true)) {
            final Activity activity = activityPluginBinding != null ? activityPluginBinding.getActivity() : null;
            if (activity != null) {
                final Intent resp = WechatCallbackActivity.extraCallback(activity.getIntent());
                if (resp != null) {
                    if (iwxapi != null) {
                        iwxapi.handleIntent(resp, iwxapiEventHandler);
                    }
                }
            }
            result.success(null);
        } else {
            result.error("FAILED", null, null);
        }
    }

    private void handleAuthCall(@NonNull MethodCall call, @NonNull Result result) {
        final SendAuth.Req req = new SendAuth.Req();
        req.scope = call.argument("scope");
        req.state = call.argument("state");
        if (iwxapi != null) {
            iwxapi.sendReq(req);
        }
        result.success(null);
    }

    private void handleQRAuthCall(@NonNull MethodCall call, @NonNull Result result) {
        if ("startQrauth".equals(call.method)) {
            final String appId = call.argument("appId");
            final String scope = call.argument("scope");
            final String noncestr = call.argument("noncestr");
            final String timestamp = call.argument("timestamp");
            final String signature = call.argument("signature");
            qrauth.auth(appId, scope, noncestr, timestamp, signature, qrauthListener);
        } else if ("stopQrauth".equals(call.method)) {
            qrauth.stopAuth();
        }
        result.success(null);
    }

    private final OAuthListener qrauthListener = new OAuthListener() {
        @Override
        public void onAuthGotQrcode(@Deprecated String qrcodeImgPath, byte[] imgBuf) {
            final Map<String, Object> map = new HashMap<>();
            map.put("imageData", imgBuf);
            if (channel != null) {
                channel.invokeMethod("onAuthGotQrcode", map);
            }
        }

        @Override
        public void onQrcodeScanned() {
            if (channel != null) {
                channel.invokeMethod("onAuthQrcodeScanned", null);
            }
        }

        @Override
        public void onAuthFinish(OAuthErrCode errCode, String authCode) {
            final Map<String, Object> map = new HashMap<>();
            map.put("errorCode", errCode.getCode());
            map.put("authCode", authCode);
            if (channel != null) {
                channel.invokeMethod("onAuthFinish", map);
            }
        }
    };

    private void handleOpenUrlCall(@NonNull MethodCall call, @NonNull Result result) {
        final OpenWebview.Req req = new OpenWebview.Req();
        req.url = call.argument("url");
        if (iwxapi != null) {
            iwxapi.sendReq(req);
        }
        result.success(null);
    }

    private void handleOpenRankListCall(@NonNull MethodCall call, @NonNull Result result) {
        final OpenRankList.Req req = new OpenRankList.Req();
        if (iwxapi != null) {
            iwxapi.sendReq(req);
        }
        result.success(null);
    }

    private void handleShareTextCall(@NonNull MethodCall call, @NonNull Result result) {
        final SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = call.method + ": " + System.currentTimeMillis();
        req.scene = call.argument("scene");
        final String text = call.argument("text");
        final WXMediaMessage message = new WXMediaMessage();
        message.description = text.length() <= 1024 ? text : text.substring(0, 1024);// 必选项，否则无法分享
        final WXTextObject object = new WXTextObject();
        object.text = text;
        message.mediaObject = object;
        req.message = message;
        if (iwxapi != null) {
            iwxapi.sendReq(req);
        }
        result.success(null);
    }

    private void handleShareMediaCall(@NonNull MethodCall call, @NonNull Result result) {
        final SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = call.method + ": " + System.currentTimeMillis();
        req.scene = call.argument("scene");
        final WXMediaMessage message = new WXMediaMessage();
        message.title = call.argument("title");
        message.description = call.argument("description");
        message.thumbData = call.argument("thumbData");
        if ("shareImage".equals(call.method)) {
            final WXImageObject object = new WXImageObject();
            if (call.hasArgument("imageData")) {
                object.imageData = call.argument("imageData");
            } else if (call.hasArgument("imageUri")) {
                final String imageUri = call.argument("imageUri");
                object.imagePath = getShareFilePath(imageUri);//Uri.parse(imageUri).getPath();
            }
            message.mediaObject = object;
        } else if ("shareFile".equals(call.method)) {
            final WXFileObject object = new WXFileObject();
            if (call.hasArgument("fileData")) {
                object.fileData = call.argument("fileData");
            } else if (call.hasArgument("fileUri")) {
                final String fileUri = call.argument("fileUri");
                object.filePath = getShareFilePath(fileUri);//Uri.parse(fileUri).getPath();
            }
//            final String fileExtension = call.argument("fileExtension");
            message.mediaObject = object;
        } else if ("shareEmoji".equals(call.method)) {
            final WXEmojiObject object = new WXEmojiObject();
            if (call.hasArgument("emojiData")) {
                object.emojiData = call.argument("emojiData");
            } else if (call.hasArgument("emojiUri")) {
                final String emojiUri = call.argument("emojiUri");
                object.emojiPath = getShareFilePath(emojiUri);//Uri.parse(emojiUri).getPath();
            }
            message.mediaObject = object;
        } else if ("shareMusic".equals(call.method)) {
            final WXMusicObject object = new WXMusicObject();
            object.musicUrl = call.argument("musicUrl");
            object.musicDataUrl = call.argument("musicDataUrl");
            object.musicLowBandUrl = call.argument("musicLowBandUrl");
            object.musicLowBandDataUrl = call.argument("musicLowBandDataUrl");
            message.mediaObject = object;
        } else if ("shareVideo".equals(call.method)) {
            final WXVideoObject object = new WXVideoObject();
            object.videoUrl = call.argument("videoUrl");
            object.videoLowBandUrl = call.argument("videoLowBandUrl");
            message.mediaObject = object;
        } else if ("shareWebpage".equals(call.method)) {
            final WXWebpageObject object = new WXWebpageObject();
            object.webpageUrl = call.argument("webpageUrl");
            message.mediaObject = object;
        } else if ("shareMiniProgram".equals(call.method)) {
            final WXMiniProgramObject object = new WXMiniProgramObject();
            object.webpageUrl = call.argument("webpageUrl");
            object.userName = call.argument("username");
            object.path = call.argument("path");
            final byte[] hdImageData = call.argument("hdImageData");
            if (hdImageData != null) {
                message.thumbData = hdImageData;
            }
            object.withShareTicket = call.argument("withShareTicket");
            object.miniprogramType = call.argument("type");
            final boolean disableforward = call.argument("disableForward");
            object.disableforward = disableforward ? 1 : 0;
            message.mediaObject = object;
        }
        req.message = message;
        if (iwxapi != null) {
            iwxapi.sendReq(req);
        }
        result.success(null);
    }

    private void handleSubscribeMsgCall(@NonNull MethodCall call, @NonNull Result result) {
        final SubscribeMessage.Req req = new SubscribeMessage.Req();
        req.scene = call.argument("scene");
        req.templateID = call.argument("templateId");
        req.reserved = call.argument("reserved");
        if (iwxapi != null) {
            iwxapi.sendReq(req);
        }
        result.success(null);
    }

    private void handleLaunchMiniProgramCall(@NonNull MethodCall call, @NonNull Result result) {
        final WXLaunchMiniProgram.Req req = new WXLaunchMiniProgram.Req();
        req.userName = call.argument("username");
        req.path = call.argument("path");
        req.miniprogramType = call.argument("type");
        if (iwxapi != null) {
            iwxapi.sendReq(req);
        }
        result.success(null);
    }

    private void handleOpenCustomerServiceChat(@NonNull MethodCall call, @NonNull Result result) {
        final WXOpenCustomerServiceChat.Req req = new WXOpenCustomerServiceChat.Req();
        req.corpId = call.argument("corpId");
        req.url = call.argument("url");
        if (iwxapi != null) {
            iwxapi.sendReq(req);
        }
        result.success(null);
    }

    private void handleOpenBusinessView(@NonNull MethodCall call, @NonNull Result result) {
        final WXOpenBusinessView.Req req = new WXOpenBusinessView.Req();
        req.businessType = call.argument("businessType");
        req.query = call.argument("query");
        req.extInfo = call.argument("extInfo");
        if (iwxapi != null) {
            iwxapi.sendReq(req);
        }
        result.success(null);
    }

    private void handleOpenBusinessWebview(@NonNull MethodCall call, @NonNull Result result) {
        final WXOpenBusinessWebview.Req req = new WXOpenBusinessWebview.Req();
        req.businessType = call.argument("businessType");
        req.queryInfo = call.argument("queryInfo");
        if (iwxapi != null) {
            iwxapi.sendReq(req);
        }
        result.success(null);
    }

    private void handlePayCall(@NonNull MethodCall call, @NonNull Result result) {
        final PayReq req = new PayReq();
        req.appId = call.argument("appId");
        req.partnerId = call.argument("partnerId");
        req.prepayId = call.argument("prepayId");
        req.nonceStr = call.argument("noncestr");
        req.timeStamp = call.argument("timestamp");
        req.packageValue = call.argument("package");
        req.sign = call.argument("sign");
        if (iwxapi != null) {
            iwxapi.sendReq(req);
        }
        result.success(null);
    }

    //

    private String getShareFilePath(@NonNull String fileUri) {
        if (iwxapi != null && iwxapi.getWXAppSupportAPI() >= 0x27000D00) {
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
                try {
                    final ProviderInfo providerInfo = applicationContext.getPackageManager().getProviderInfo(new ComponentName(applicationContext, WechatFileProvider.class), PackageManager.MATCH_DEFAULT_ONLY);
                    final Uri shareFileUri = FileProvider.getUriForFile(applicationContext, providerInfo.authority, new File(Uri.parse(fileUri).getPath()));
                    applicationContext.grantUriPermission("com.tencent.mm", shareFileUri, Intent.FLAG_GRANT_READ_URI_PERMISSION);
                    return shareFileUri.toString();
                } catch (PackageManager.NameNotFoundException e) {
                    // ignore
                }
            }
        }
        return Uri.parse(fileUri).getPath();
    }
}
