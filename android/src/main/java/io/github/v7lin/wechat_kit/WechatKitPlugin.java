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
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;
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

/**
 * WechatKitPlugin
 */
public class WechatKitPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler {

    //

    private static final String METHOD_REGISTERAPP = "registerApp";
    private static final String METHOD_ISINSTALLED = "isInstalled";
    private static final String METHOD_ISSUPPORTAPI = "isSupportApi";
    private static final String METHOD_OPENWECHAT = "openWechat";
    private static final String METHOD_AUTH = "auth";
    private static final String METHOD_STARTQRAUTH = "startQrauth";
    private static final String METHOD_STOPQRAUTH = "stopQrauth";
    private static final String METHOD_OPENURL = "openUrl";
    private static final String METHOD_OPENRANKLIST = "openRankList";
    private static final String METHOD_SHARETEXT = "shareText";
    private static final String METHOD_SHAREIMAGE = "shareImage";
    private static final String METHOD_SHAREFILE = "shareFile";
    private static final String METHOD_SHAREEMOJI = "shareEmoji";
    private static final String METHOD_SHAREMUSIC = "shareMusic";
    private static final String METHOD_SHAREVIDEO = "shareVideo";
    private static final String METHOD_SHAREWEBPAGE = "shareWebpage";
    private static final String METHOD_SHAREMINIPROGRAM = "shareMiniProgram";
    private static final String METHOD_SUBSCRIBEMSG = "subscribeMsg";
    private static final String METHOD_LAUNCHMINIPROGRAM = "launchMiniProgram";
    private static final String METHOD_PAY = "pay";

    private static final String METHOD_ONAUTHRESP = "onAuthResp";
    private static final String METHOD_ONOPENURLRESP = "onOpenUrlResp";
    private static final String METHOD_ONSHAREMSGRESP = "onShareMsgResp";
    private static final String METHOD_ONSUBSCRIBEMSGRESP = "onSubscribeMsgResp";
    private static final String METHOD_ONLAUNCHMINIPROGRAMRESP = "onLaunchMiniProgramResp";
    private static final String METHOD_ONPAYRESP = "onPayResp";
    private static final String METHOD_ONAUTHGOTQRCODE = "onAuthGotQrcode";
    private static final String METHOD_ONAUTHQRCODESCANNED = "onAuthQrcodeScanned";
    private static final String METHOD_ONAUTHFINISH = "onAuthFinish";


    private static final String ARGUMENT_KEY_APPID = "appId";
    //    private static final String ARGUMENT_KEY_UNIVERSALLINK = "universalLink";
    private static final String ARGUMENT_KEY_SCOPE = "scope";
    private static final String ARGUMENT_KEY_STATE = "state";
    private static final String ARGUMENT_KEY_NONCESTR = "noncestr";
    private static final String ARGUMENT_KEY_TIMESTAMP = "timestamp";
    private static final String ARGUMENT_KEY_SIGNATURE = "signature";
    private static final String ARGUMENT_KEY_URL = "url";
    private static final String ARGUMENT_KEY_USERNAME = "username";
    private static final String ARGUMENT_KEY_SCENE = "scene";
    private static final String ARGUMENT_KEY_TEXT = "text";
    private static final String ARGUMENT_KEY_TITLE = "title";
    private static final String ARGUMENT_KEY_DESCRIPTION = "description";
    private static final String ARGUMENT_KEY_THUMBDATA = "thumbData";
    private static final String ARGUMENT_KEY_IMAGEDATA = "imageData";
    private static final String ARGUMENT_KEY_IMAGEURI = "imageUri";
    private static final String ARGUMENT_KEY_EMOJIDATA = "emojiData";
    private static final String ARGUMENT_KEY_EMOJIURI = "emojiUri";
    private static final String ARGUMENT_KEY_FILEDATA = "fileData";
    private static final String ARGUMENT_KEY_FILEURI = "fileUri";
    //    private static final String ARGUMENT_KEY_FILEEXTENSION = "fileExtension";
    private static final String ARGUMENT_KEY_MUSICURL = "musicUrl";
    private static final String ARGUMENT_KEY_MUSICDATAURL = "musicDataUrl";
    private static final String ARGUMENT_KEY_MUSICLOWBANDURL = "musicLowBandUrl";
    private static final String ARGUMENT_KEY_MUSICLOWBANDDATAURL = "musicLowBandDataUrl";
    private static final String ARGUMENT_KEY_VIDEOURL = "videoUrl";
    private static final String ARGUMENT_KEY_VIDEOLOWBANDURL = "videoLowBandUrl";
    private static final String ARGUMENT_KEY_WEBPAGEURL = "webpageUrl";
    private static final String ARGUMENT_KEY_PATH = "path";
    private static final String ARGUMENT_KEY_HDIMAGEDATA = "hdImageData";
    private static final String ARGUMENT_KEY_WITHSHARETICKET = "withShareTicket";
    private static final String ARGUMENT_KEY_TYPE = "type";
    private static final String ARGUMENT_KEY_DISABLEFORWARD = "disableForward";
    private static final String ARGUMENT_KEY_TEMPLATEID = "templateId";
    private static final String ARGUMENT_KEY_RESERVED = "reserved";
    private static final String ARGUMENT_KEY_PARTNERID = "partnerId";
    private static final String ARGUMENT_KEY_PREPAYID = "prepayId";
    //    private static final String ARGUMENT_KEY_NONCESTR = "noncestr";
    //    private static final String ARGUMENT_KEY_TIMESTAMP = "timestamp";
    private static final String ARGUMENT_KEY_PACKAGE = "package";
    private static final String ARGUMENT_KEY_SIGN = "sign";

    private static final String ARGUMENT_KEY_RESULT_ERRORCODE = "errorCode";
    private static final String ARGUMENT_KEY_RESULT_ERRORMSG = "errorMsg";
    private static final String ARGUMENT_KEY_RESULT_CODE = "code";
    private static final String ARGUMENT_KEY_RESULT_STATE = "state";
    private static final String ARGUMENT_KEY_RESULT_LANG = "lang";
    private static final String ARGUMENT_KEY_RESULT_COUNTRY = "country";
    private static final String ARGUMENT_KEY_RESULT_TEMPLATEID = "templateId";
    private static final String ARGUMENT_KEY_RESULT_SCENE = "scene";
    private static final String ARGUMENT_KEY_RESULT_ACTION = "action";
    private static final String ARGUMENT_KEY_RESULT_RESERVED = "reserved";
    private static final String ARGUMENT_KEY_RESULT_OPENID = "openId";
    private static final String ARGUMENT_KEY_RESULT_EXTMSG = "extMsg";
    private static final String ARGUMENT_KEY_RESULT_RETURNKEY = "returnKey";
    private static final String ARGUMENT_KEY_RESULT_IMAGEDATA = "imageData";
    private static final String ARGUMENT_KEY_RESULT_AUTHCODE = "authCode";

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context applicationContext;
    private Activity activity;

    private final AtomicBoolean register = new AtomicBoolean(false);

    private final IDiffDevOAuth qrauth = DiffDevOAuthFactory.getDiffDevOAuth();

    private IWXAPI iwxapi;

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
        activity = binding.getActivity();
        if (register.compareAndSet(false, true)) {
            WechatReceiver.registerReceiver(activity, wechatReceiver);
        }
    }

    private final WechatReceiver wechatReceiver = new WechatReceiver() {
        @Override
        public void handleIntent(Intent intent) {
            if (iwxapi != null) {
                iwxapi.handleIntent(intent, iwxapiEventHandler);
            }
        }
    };

    private final IWXAPIEventHandler iwxapiEventHandler = new IWXAPIEventHandler() {
        @Override
        public void onReq(BaseReq req) {

        }

        @Override
        public void onResp(BaseResp resp) {
            Map<String, Object> map = new HashMap<>();
            map.put(ARGUMENT_KEY_RESULT_ERRORCODE, resp.errCode);
            map.put(ARGUMENT_KEY_RESULT_ERRORMSG, resp.errStr);
            if (resp instanceof SendAuth.Resp) {
                // 授权
                SendAuth.Resp authResp = (SendAuth.Resp) resp;
                map.put(ARGUMENT_KEY_RESULT_CODE, authResp.code);
                map.put(ARGUMENT_KEY_RESULT_STATE, authResp.state);
                map.put(ARGUMENT_KEY_RESULT_LANG, authResp.lang);
                map.put(ARGUMENT_KEY_RESULT_COUNTRY, authResp.country);
                if (channel != null) {
                    channel.invokeMethod(METHOD_ONAUTHRESP, map);
                }
            } else if (resp instanceof OpenWebview.Resp) {
                // 浏览器
                if (channel != null) {
                    channel.invokeMethod(METHOD_ONOPENURLRESP, map);
                }
            } else if (resp instanceof SendMessageToWX.Resp) {
                // 分享
                if (channel != null) {
                    channel.invokeMethod(METHOD_ONSHAREMSGRESP, map);
                }
            } else if (resp instanceof SubscribeMessage.Resp) {
                // 一次性订阅消息
                SubscribeMessage.Resp subscribeMsgResp = (SubscribeMessage.Resp) resp;
                map.put(ARGUMENT_KEY_RESULT_TEMPLATEID, subscribeMsgResp.templateID);
                map.put(ARGUMENT_KEY_RESULT_SCENE, subscribeMsgResp.scene);
                map.put(ARGUMENT_KEY_RESULT_ACTION, subscribeMsgResp.action);
                map.put(ARGUMENT_KEY_RESULT_RESERVED, subscribeMsgResp.reserved);
                map.put(ARGUMENT_KEY_RESULT_OPENID, subscribeMsgResp.openId);
                if (channel != null) {
                    channel.invokeMethod(METHOD_ONSUBSCRIBEMSGRESP, map);
                }
            } else if (resp instanceof WXLaunchMiniProgram.Resp) {
                // 打开小程序
                WXLaunchMiniProgram.Resp launchMiniProgramResp = (WXLaunchMiniProgram.Resp) resp;
                map.put(ARGUMENT_KEY_RESULT_EXTMSG, launchMiniProgramResp.extMsg);
                if (channel != null) {
                    channel.invokeMethod(METHOD_ONLAUNCHMINIPROGRAMRESP, map);
                }
            } else if (resp instanceof PayResp) {
                // 支付
                PayResp payResp = (PayResp) resp;
                map.put(ARGUMENT_KEY_RESULT_RETURNKEY, payResp.returnKey);
                if (channel != null) {
                    channel.invokeMethod(METHOD_ONPAYRESP, map);
                }
            }
        }
    };

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
        if (register.compareAndSet(true, false)) {
            WechatReceiver.unregisterReceiver(activity, wechatReceiver);
        }
        qrauth.removeAllListeners();
        activity = null;
    }

    // --- MethodCallHandler

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (METHOD_REGISTERAPP.equals(call.method)) {
            registerApp(call, result);
        } else if (METHOD_ISINSTALLED.equals(call.method)) {
            result.success(iwxapi != null && iwxapi.isWXAppInstalled());
        } else if (METHOD_ISSUPPORTAPI.equals(call.method)) {
            result.success(iwxapi != null && iwxapi.getWXAppSupportAPI() >= Build.OPENID_SUPPORTED_SDK_INT);
        } else if (METHOD_OPENWECHAT.equals(call.method)) {
            result.success(iwxapi != null && iwxapi.openWXApp());
        } else if (METHOD_AUTH.equals(call.method)) {
            handleAuthCall(call, result);
        } else if (METHOD_STARTQRAUTH.equals(call.method) ||
                METHOD_STOPQRAUTH.equals(call.method)) {
            handleQRAuthCall(call, result);
        } else if (METHOD_OPENURL.equals(call.method)) {
            handleOpenUrlCall(call, result);
        } else if (METHOD_OPENRANKLIST.equals(call.method)) {
            handleOpenRankListCall(call, result);
        } else if (METHOD_SHARETEXT.equals(call.method)) {
            handleShareTextCall(call, result);
        } else if (METHOD_SHAREIMAGE.equals(call.method) ||
                METHOD_SHAREFILE.equals(call.method) ||
                METHOD_SHAREEMOJI.equals(call.method) ||
                METHOD_SHAREMUSIC.equals(call.method) ||
                METHOD_SHAREVIDEO.equals(call.method) ||
                METHOD_SHAREWEBPAGE.equals(call.method) ||
                METHOD_SHAREMINIPROGRAM.equals(call.method)) {
            handleShareMediaCall(call, result);
        } else if (METHOD_SUBSCRIBEMSG.equals(call.method)) {
            handleSubscribeMsgCall(call, result);
        } else if (METHOD_LAUNCHMINIPROGRAM.equals(call.method)) {
            handleLaunchMiniProgramCall(call, result);
        } else if (METHOD_PAY.equals(call.method)) {
            handlePayCall(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void registerApp(@NonNull MethodCall call, @NonNull Result result) {
        final String appId = call.argument(ARGUMENT_KEY_APPID);
//        final String universalLink = call.argument(ARGUMENT_KEY_UNIVERSALLINK);
        iwxapi = WXAPIFactory.createWXAPI(applicationContext, appId);
        iwxapi.registerApp(appId);
        result.success(null);
    }

    private void handleAuthCall(@NonNull MethodCall call, @NonNull Result result) {
        SendAuth.Req req = new SendAuth.Req();
        req.scope = call.argument(ARGUMENT_KEY_SCOPE);
        req.state = call.argument(ARGUMENT_KEY_STATE);
        if (iwxapi != null) {
            iwxapi.sendReq(req);
        }
        result.success(null);
    }

    private void handleQRAuthCall(@NonNull MethodCall call, @NonNull Result result) {
        if (METHOD_STARTQRAUTH.equals(call.method)) {
            String appId = call.argument(ARGUMENT_KEY_APPID);
            String scope = call.argument(ARGUMENT_KEY_SCOPE);
            String noncestr = call.argument(ARGUMENT_KEY_NONCESTR);
            String timestamp = call.argument(ARGUMENT_KEY_TIMESTAMP);
            String signature = call.argument(ARGUMENT_KEY_SIGNATURE);
            qrauth.auth(appId, scope, noncestr, timestamp, signature, qrauthListener);
        } else if (METHOD_STOPQRAUTH.equals(call.method)) {
            qrauth.stopAuth();
        }
        result.success(null);
    }

    private final OAuthListener qrauthListener = new OAuthListener() {
        @Override
        public void onAuthGotQrcode(@Deprecated String qrcodeImgPath, byte[] imgBuf) {
            Map<String, Object> map = new HashMap<>();
            map.put(ARGUMENT_KEY_RESULT_IMAGEDATA, imgBuf);
            if (channel != null) {
                channel.invokeMethod(METHOD_ONAUTHGOTQRCODE, map);
            }
        }

        @Override
        public void onQrcodeScanned() {
            if (channel != null) {
                channel.invokeMethod(METHOD_ONAUTHQRCODESCANNED, null);
            }
        }

        @Override
        public void onAuthFinish(OAuthErrCode errCode, String authCode) {
            Map<String, Object> map = new HashMap<>();
            map.put(ARGUMENT_KEY_RESULT_ERRORCODE, errCode.getCode());
            map.put(ARGUMENT_KEY_RESULT_AUTHCODE, authCode);
            if (channel != null) {
                channel.invokeMethod(METHOD_ONAUTHFINISH, map);
            }
        }
    };

    private void handleOpenUrlCall(@NonNull MethodCall call, @NonNull Result result) {
        OpenWebview.Req req = new OpenWebview.Req();
        req.url = call.argument(ARGUMENT_KEY_URL);
        if (iwxapi != null) {
            iwxapi.sendReq(req);
        }
        result.success(null);
    }

    private void handleOpenRankListCall(@NonNull MethodCall call, @NonNull Result result) {
        OpenRankList.Req req = new OpenRankList.Req();
        if (iwxapi != null) {
            iwxapi.sendReq(req);
        }
        result.success(null);
    }

    private void handleShareTextCall(@NonNull MethodCall call, @NonNull Result result) {
        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = call.method + ": " + System.currentTimeMillis();
        req.scene = call.argument(ARGUMENT_KEY_SCENE);
        String text = call.argument(ARGUMENT_KEY_TEXT);
        WXMediaMessage message = new WXMediaMessage();
        message.description = text.length() <= 1024 ? text : text.substring(0, 1024);// 必选项，否则无法分享
        WXTextObject object = new WXTextObject();
        object.text = text;
        message.mediaObject = object;
        req.message = message;
        if (iwxapi != null) {
            iwxapi.sendReq(req);
        }
        result.success(null);
    }

    private void handleShareMediaCall(@NonNull MethodCall call, @NonNull Result result) {
        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = call.method + ": " + System.currentTimeMillis();
        req.scene = call.argument(ARGUMENT_KEY_SCENE);
        WXMediaMessage message = new WXMediaMessage();
        message.title = call.argument(ARGUMENT_KEY_TITLE);
        message.description = call.argument(ARGUMENT_KEY_DESCRIPTION);
        message.thumbData = call.argument(ARGUMENT_KEY_THUMBDATA);
        if (METHOD_SHAREIMAGE.equals(call.method)) {
            WXImageObject object = new WXImageObject();
            if (call.hasArgument(ARGUMENT_KEY_IMAGEDATA)) {
                object.imageData = call.argument(ARGUMENT_KEY_IMAGEDATA);
            } else if (call.hasArgument(ARGUMENT_KEY_IMAGEURI)) {
                String imageUri = call.argument(ARGUMENT_KEY_IMAGEURI);
                object.imagePath = getShareFilePath(imageUri);//Uri.parse(imageUri).getPath();
            }
            message.mediaObject = object;
        } else if (METHOD_SHAREFILE.equals(call.method)) {
            WXFileObject object = new WXFileObject();
            if (call.hasArgument(ARGUMENT_KEY_FILEDATA)) {
                object.fileData = call.argument(ARGUMENT_KEY_FILEDATA);
            } else if (call.hasArgument(ARGUMENT_KEY_FILEURI)) {
                String fileUri = call.argument(ARGUMENT_KEY_FILEURI);
                object.filePath = getShareFilePath(fileUri);//Uri.parse(fileUri).getPath();
            }
//            String fileExtension = call.argument(ARGUMENT_KEY_FILEEXTENSION);
            message.mediaObject = object;
        } else if (METHOD_SHAREEMOJI.equals(call.method)) {
            WXEmojiObject object = new WXEmojiObject();
            if (call.hasArgument(ARGUMENT_KEY_EMOJIDATA)) {
                object.emojiData = call.argument(ARGUMENT_KEY_EMOJIDATA);
            } else if (call.hasArgument(ARGUMENT_KEY_EMOJIURI)) {
                String emojiUri = call.argument(ARGUMENT_KEY_EMOJIURI);
                object.emojiPath = getShareFilePath(emojiUri);//Uri.parse(emojiUri).getPath();
            }
            message.mediaObject = object;
        } else if (METHOD_SHAREMUSIC.equals(call.method)) {
            WXMusicObject object = new WXMusicObject();
            object.musicUrl = call.argument(ARGUMENT_KEY_MUSICURL);
            object.musicDataUrl = call.argument(ARGUMENT_KEY_MUSICDATAURL);
            object.musicLowBandUrl = call.argument(ARGUMENT_KEY_MUSICLOWBANDURL);
            object.musicLowBandDataUrl = call.argument(ARGUMENT_KEY_MUSICLOWBANDDATAURL);
            message.mediaObject = object;
        } else if (METHOD_SHAREVIDEO.equals(call.method)) {
            WXVideoObject object = new WXVideoObject();
            object.videoUrl = call.argument(ARGUMENT_KEY_VIDEOURL);
            object.videoLowBandUrl = call.argument(ARGUMENT_KEY_VIDEOLOWBANDURL);
            message.mediaObject = object;
        } else if (METHOD_SHAREWEBPAGE.equals(call.method)) {
            WXWebpageObject object = new WXWebpageObject();
            object.webpageUrl = call.argument(ARGUMENT_KEY_WEBPAGEURL);
            message.mediaObject = object;
        } else if (METHOD_SHAREMINIPROGRAM.equals(call.method)) {
            WXMiniProgramObject object = new WXMiniProgramObject();
            object.webpageUrl = call.argument(ARGUMENT_KEY_WEBPAGEURL);
            object.userName = call.argument(ARGUMENT_KEY_USERNAME);
            object.path = call.argument(ARGUMENT_KEY_PATH);
            byte[] hdImageData = call.argument(ARGUMENT_KEY_HDIMAGEDATA);
            if (hdImageData != null) {
                message.thumbData = hdImageData;
            }
            object.withShareTicket = call.argument(ARGUMENT_KEY_WITHSHARETICKET);
            object.miniprogramType = call.argument(ARGUMENT_KEY_TYPE);
            boolean disableforward = call.argument(ARGUMENT_KEY_DISABLEFORWARD);
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
        SubscribeMessage.Req req = new SubscribeMessage.Req();
        req.scene = call.argument(ARGUMENT_KEY_SCENE);
        req.templateID = call.argument(ARGUMENT_KEY_TEMPLATEID);
        req.reserved = call.argument(ARGUMENT_KEY_RESERVED);
        if (iwxapi != null) {
            iwxapi.sendReq(req);
        }
        result.success(null);
    }

    private void handleLaunchMiniProgramCall(@NonNull MethodCall call, @NonNull Result result) {
        WXLaunchMiniProgram.Req req = new WXLaunchMiniProgram.Req();
        req.userName = call.argument(ARGUMENT_KEY_USERNAME);
        req.path = call.argument(ARGUMENT_KEY_PATH);
        req.miniprogramType = call.argument(ARGUMENT_KEY_TYPE);
        if (iwxapi != null) {
            iwxapi.sendReq(req);
        }
        result.success(null);
    }

    private void handlePayCall(@NonNull MethodCall call, @NonNull Result result) {
        PayReq req = new PayReq();
        req.appId = call.argument(ARGUMENT_KEY_APPID);
        req.partnerId = call.argument(ARGUMENT_KEY_PARTNERID);
        req.prepayId = call.argument(ARGUMENT_KEY_PREPAYID);
        req.nonceStr = call.argument(ARGUMENT_KEY_NONCESTR);
        req.timeStamp = call.argument(ARGUMENT_KEY_TIMESTAMP);
        req.packageValue = call.argument(ARGUMENT_KEY_PACKAGE);
        req.sign = call.argument(ARGUMENT_KEY_SIGN);
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
                    ProviderInfo providerInfo = applicationContext.getPackageManager().getProviderInfo(new ComponentName(applicationContext, WechatFileProvider.class), PackageManager.MATCH_DEFAULT_ONLY);
                    Uri shareFileUri = FileProvider.getUriForFile(applicationContext, providerInfo.authority, new File(Uri.parse(fileUri).getPath()));
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
