package io.github.v7lin.fakewechat;

import android.content.Intent;

import com.tencent.mm.opensdk.constants.Build;
import com.tencent.mm.opensdk.diffdev.DiffDevOAuthFactory;
import com.tencent.mm.opensdk.diffdev.IDiffDevOAuth;
import com.tencent.mm.opensdk.diffdev.OAuthErrCode;
import com.tencent.mm.opensdk.diffdev.OAuthListener;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.modelbiz.JumpToBizProfile;
import com.tencent.mm.opensdk.modelbiz.JumpToBizWebview;
import com.tencent.mm.opensdk.modelbiz.OpenRankList;
import com.tencent.mm.opensdk.modelbiz.OpenWebview;
import com.tencent.mm.opensdk.modelbiz.SubscribeMessage;
import com.tencent.mm.opensdk.modelbiz.WXLaunchMiniProgram;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;
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

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.view.FlutterNativeView;

/**
 * FakeWechatPlugin
 */
public class FakeWechatPlugin implements MethodCallHandler, PluginRegistry.ViewDestroyListener {
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "v7lin.github.io/fake_wechat");
        FakeWechatPlugin plugin = new FakeWechatPlugin(registrar, channel);
        registrar.addViewDestroyListener(plugin);
        channel.setMethodCallHandler(plugin);
    }

    private static final String METHOD_REGISTERAPP = "registerApp";
    private static final String METHOD_ISWECHATINSTALLED = "isWechatInstalled";
    private static final String METHOD_ISWECHATSUPPORTAPI = "isWechatSupportApi";
    private static final String METHOD_OPENWECHAT = "openWechat";
    private static final String METHOD_AUTH = "auth";
    private static final String METHOD_STARTQRAUTH = "startQrauth";
    private static final String METHOD_STOPQRAUTH = "stopQrauth";
    private static final String METHOD_OPENURL = "openUrl";
    private static final String METHOD_OPENRANKLIST = "openRankList";
    private static final String METHOD_OPENBIZPROFILE = "openBizProfile";
    private static final String METHOD_OPENBIZURL = "openBizUrl";
    private static final String METHOD_SHARETEXT = "shareText";
    private static final String METHOD_SHAREIMAGE = "shareImage";
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
    private static final String ARGUMENT_KEY_SCOPE = "scope";
    private static final String ARGUMENT_KEY_STATE = "state";
    private static final String ARGUMENT_KEY_NONCESTR = "noncestr";
    private static final String ARGUMENT_KEY_TIMESTAMP = "timestamp";
    private static final String ARGUMENT_KEY_SIGNATURE = "signature";
    private static final String ARGUMENT_KEY_URL = "url";
    private static final String ARGUMENT_KEY_PROFILETYPE = "profileType";
    private static final String ARGUMENT_KEY_USERNAME = "username";
    private static final String ARGUMENT_KEY_EXTMSG = "extMsg";
    private static final String ARGUMENT_KEY_WEBTYPE = "webType";
    private static final String ARGUMENT_KEY_SCENE = "scene";
    private static final String ARGUMENT_KEY_TEXT = "text";
    private static final String ARGUMENT_KEY_TITLE = "title";
    private static final String ARGUMENT_KEY_DESCRIPTION = "description";
    private static final String ARGUMENT_KEY_THUMBDATA = "thumbData";
    private static final String ARGUMENT_KEY_IMAGEDATA = "imageData";
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

    private final Registrar registrar;
    private final MethodChannel channel;
    private final IDiffDevOAuth qrauth;
    private final AtomicBoolean register = new AtomicBoolean(false);

    private IWXAPI iwxapi;

    private FakeWechatPlugin(Registrar registrar, MethodChannel channel) {
        this.registrar = registrar;
        this.channel = channel;
        this.qrauth = DiffDevOAuthFactory.getDiffDevOAuth();
        this.qrauth.addListener(qrauthListener);
        if (register.compareAndSet(false, true)) {
            WechatReceiver.registerReceiver(registrar.context(), wechatReceiver);
        }
    }

    private OAuthListener qrauthListener = new OAuthListener() {
        @Override
        public void onAuthGotQrcode(@Deprecated String qrcodeImgPath, byte[] imgBuf) {
            Map<String, Object> map = new HashMap<>();
            map.put(ARGUMENT_KEY_RESULT_IMAGEDATA, imgBuf);
            channel.invokeMethod(METHOD_ONAUTHGOTQRCODE, map);
        }

        @Override
        public void onQrcodeScanned() {
            channel.invokeMethod(METHOD_ONAUTHQRCODESCANNED, null);
        }

        @Override
        public void onAuthFinish(OAuthErrCode errCode, String authCode) {
            Map<String, Object> map = new HashMap<>();
            map.put(ARGUMENT_KEY_RESULT_ERRORCODE, errCode.getCode());
            map.put(ARGUMENT_KEY_RESULT_AUTHCODE, authCode);
            channel.invokeMethod(METHOD_ONAUTHFINISH, map);
        }
    };

    private WechatReceiver wechatReceiver = new WechatReceiver() {
        @Override
        public void handleIntent(Intent intent) {
            iwxapi.handleIntent(intent, iwxapiEventHandler);
        }
    };

    private IWXAPIEventHandler iwxapiEventHandler = new IWXAPIEventHandler() {
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
                channel.invokeMethod(METHOD_ONAUTHRESP, map);
            } else if (resp instanceof OpenWebview.Resp) {
                // 浏览器
                channel.invokeMethod(METHOD_ONOPENURLRESP, map);
            } else if (resp instanceof SendMessageToWX.Resp) {
                // 分享
                channel.invokeMethod(METHOD_ONSHAREMSGRESP, map);
            } else if (resp instanceof SubscribeMessage.Resp) {
                // 一次性订阅消息
                SubscribeMessage.Resp subscribeMsgResp = (SubscribeMessage.Resp) resp;
                map.put(ARGUMENT_KEY_RESULT_TEMPLATEID, subscribeMsgResp.templateID);
                map.put(ARGUMENT_KEY_RESULT_SCENE, subscribeMsgResp.scene);
                map.put(ARGUMENT_KEY_RESULT_ACTION, subscribeMsgResp.action);
                map.put(ARGUMENT_KEY_RESULT_RESERVED, subscribeMsgResp.reserved);
                map.put(ARGUMENT_KEY_RESULT_OPENID, subscribeMsgResp.openId);
                channel.invokeMethod(METHOD_ONSUBSCRIBEMSGRESP, map);
            } else if (resp instanceof WXLaunchMiniProgram.Resp) {
                // 打开小程序
                WXLaunchMiniProgram.Resp launchMiniProgramResp = (WXLaunchMiniProgram.Resp) resp;
                map.put(ARGUMENT_KEY_RESULT_EXTMSG, launchMiniProgramResp.extMsg);
                channel.invokeMethod(METHOD_ONLAUNCHMINIPROGRAMRESP, map);
            } else if (resp instanceof PayResp) {
                // 支付
                PayResp payResp = (PayResp) resp;
                map.put(ARGUMENT_KEY_RESULT_RETURNKEY, payResp.returnKey);
                channel.invokeMethod(METHOD_ONPAYRESP, map);
            }
        }
    };

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (METHOD_REGISTERAPP.equals(call.method)) {
            String appId = call.argument(ARGUMENT_KEY_APPID);
            iwxapi = WXAPIFactory.createWXAPI(registrar.context().getApplicationContext(), appId);
            iwxapi.registerApp(appId);
            result.success(null);
        } else if (METHOD_ISWECHATINSTALLED.equals(call.method)) {
            result.success(iwxapi.isWXAppInstalled());
        } else if (METHOD_ISWECHATSUPPORTAPI.equals(call.method)) {
            result.success(iwxapi.getWXAppSupportAPI() >= Build.OPENID_SUPPORTED_SDK_INT);
        } else if (METHOD_OPENWECHAT.equals(call.method)) {
            result.success(iwxapi.openWXApp());
        } else if (METHOD_AUTH.equals(call.method)) {
            handleAuthCall(call, result);
        } else if (METHOD_STARTQRAUTH.equals(call.method) ||
                METHOD_STOPQRAUTH.equals(call.method)) {
            handleQRAuthCall(call, result);
        } else if (METHOD_OPENURL.equals(call.method)) {
            handleOpenUrlCall(call, result);
        } else if (METHOD_OPENRANKLIST.equals(call.method)) {
            handleOpenRankListCall(call, result);
        } else if (METHOD_OPENBIZPROFILE.equals(call.method)) {
            handleOpenBizProfileCall(call, result);
        } else if (METHOD_OPENBIZURL.equals(call.method)) {
            handleOpenBizUrlCall(call, result);
        } else if (METHOD_SHARETEXT.equals(call.method)) {
            handleShareTextCall(call, result);
        } else if (METHOD_SHAREIMAGE.equals(call.method) ||
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

    private void handleAuthCall(MethodCall call, Result result) {
        SendAuth.Req req = new SendAuth.Req();
        req.scope = call.argument(ARGUMENT_KEY_SCOPE);
        req.state = call.argument(ARGUMENT_KEY_STATE);
        iwxapi.sendReq(req);
        result.success(null);
    }

    private void handleQRAuthCall(MethodCall call, Result result) {
        if (METHOD_STARTQRAUTH.equals(call.method)) {
            String appId = call.argument(ARGUMENT_KEY_APPID);
            String scope = call.argument(ARGUMENT_KEY_SCOPE);
            String noncestr = call.argument(ARGUMENT_KEY_NONCESTR);
            String timestamp = call.argument(ARGUMENT_KEY_TIMESTAMP);
            String signature = call.argument(ARGUMENT_KEY_SIGNATURE);
            qrauth.auth(appId, scope, noncestr, timestamp, signature, null);
        } else if (METHOD_STOPQRAUTH.equals(call.method)) {
            qrauth.stopAuth();
        }
        result.success(null);
    }

    private void handleOpenUrlCall(MethodCall call, Result result) {
        OpenWebview.Req req = new OpenWebview.Req();
        req.url = call.argument(ARGUMENT_KEY_URL);
        iwxapi.sendReq(req);
        result.success(null);
    }

    private void handleOpenRankListCall(MethodCall call, Result result) {
        OpenRankList.Req req = new OpenRankList.Req();
        iwxapi.sendReq(req);
        result.success(null);
    }

    private void handleOpenBizProfileCall(MethodCall call, Result result) {
        JumpToBizProfile.Req req = new JumpToBizProfile.Req();
        req.profileType = call.argument(ARGUMENT_KEY_PROFILETYPE);
        req.toUserName = call.argument(ARGUMENT_KEY_USERNAME);
        req.extMsg = call.argument(ARGUMENT_KEY_EXTMSG);
        iwxapi.sendReq(req);
        result.success(null);
    }

    private void handleOpenBizUrlCall(MethodCall call, Result result) {
        JumpToBizWebview.Req req = new JumpToBizWebview.Req();
        req.webType = call.argument(ARGUMENT_KEY_WEBTYPE);
        req.toUserName = call.argument(ARGUMENT_KEY_USERNAME);
        req.extMsg = call.argument(ARGUMENT_KEY_EXTMSG);
        iwxapi.sendReq(req);
        result.success(null);
    }

    private void handleShareTextCall(MethodCall call, Result result) {
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
        iwxapi.sendReq(req);
        result.success(null);
    }

    private void handleShareMediaCall(MethodCall call, Result result) {
        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = call.method + ": " + System.currentTimeMillis();
        req.scene = call.argument(ARGUMENT_KEY_SCENE);
        WXMediaMessage message = new WXMediaMessage();
        message.title = call.argument(ARGUMENT_KEY_TITLE);
        message.description = call.argument(ARGUMENT_KEY_DESCRIPTION);
        message.thumbData = call.argument(ARGUMENT_KEY_THUMBDATA);
        if (METHOD_SHAREIMAGE.equals(call.method)) {
            WXImageObject object = new WXImageObject();
            object.imageData = call.argument(ARGUMENT_KEY_IMAGEDATA);
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
            object.withShareTicket = call.argument(ARGUMENT_KEY_WITHSHARETICKET);
            byte[] hdImageData = call.argument(ARGUMENT_KEY_HDIMAGEDATA);
            if (hdImageData != null) {
                message.thumbData = hdImageData;
            }
            message.mediaObject = object;
        }
        req.message = message;
        iwxapi.sendReq(req);
        result.success(null);
    }

    private void handleSubscribeMsgCall(MethodCall call, Result result) {
        SubscribeMessage.Req req = new SubscribeMessage.Req();
        req.scene = call.argument(ARGUMENT_KEY_SCENE);
        req.templateID = call.argument(ARGUMENT_KEY_TEMPLATEID);
        req.reserved = call.argument(ARGUMENT_KEY_RESERVED);
        iwxapi.sendReq(req);
        result.success(null);
    }

    private void handleLaunchMiniProgramCall(MethodCall call, Result result) {
        WXLaunchMiniProgram.Req req = new WXLaunchMiniProgram.Req();
        req.userName = call.argument(ARGUMENT_KEY_USERNAME);
        req.path = call.argument(ARGUMENT_KEY_PATH);
        iwxapi.sendReq(req);
        result.success(null);
    }

    private void handlePayCall(MethodCall call, Result result) {
        PayReq req = new PayReq();
        req.appId = call.argument(ARGUMENT_KEY_APPID);
        req.partnerId = call.argument(ARGUMENT_KEY_PARTNERID);
        req.prepayId = call.argument(ARGUMENT_KEY_PREPAYID);
        req.nonceStr = call.argument(ARGUMENT_KEY_NONCESTR);
        req.timeStamp = call.argument(ARGUMENT_KEY_TIMESTAMP);
        req.packageValue = call.argument(ARGUMENT_KEY_PACKAGE);
        req.sign = call.argument(ARGUMENT_KEY_SIGN);
        iwxapi.sendReq(req);
        result.success(null);
    }

    // --- ViewDestroyListener

    @Override
    public boolean onViewDestroy(FlutterNativeView flutterNativeView) {
        if (register.compareAndSet(true, false)) {
            WechatReceiver.unregisterReceiver(registrar.context(), wechatReceiver);
        }
        qrauth.removeAllListeners();
        return false;
    }
}
