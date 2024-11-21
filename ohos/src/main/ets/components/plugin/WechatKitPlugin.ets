import {
  AbilityAware,
  AbilityPluginBinding,
  Any,
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
  NewWantListener,
} from '@ohos/flutter_ohos'
import { AbilityConstant, bundleManager, Want } from '@kit.AbilityKit'
import * as WeChatSDK from "@tencent/wechat_open_sdk"
import { buffer, util } from '@kit.ArkTS'

/** WechatKitPlugin **/
export default class WechatKitPlugin implements FlutterPlugin, AbilityAware, NewWantListener, MethodCallHandler {
  private channel: MethodChannel | null = null
  private abilityBinding: AbilityPluginBinding | null = null
  private wxApi: WeChatSDK.WXApi | null = null
  private diffDevOauth: WeChatSDK.IDiffDevOAuth | null = null

  getUniqueClassName(): string {
    return "WechatKitPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "v7lin.github.io/wechat_kit");
    this.channel.setMethodCallHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    this.abilityBinding = binding
    this.abilityBinding.addOnNewWantListener(this)
  }

  onDetachedFromAbility(): void {
    if (this.abilityBinding != null) {
      this.abilityBinding.removeOnNewWantListener(this)
    }
    this.abilityBinding = null
  }

  onNewWant(want: Want, launchParams: AbilityConstant.LaunchParam): void {
    this.wxApi?.handleWant(want, this.wxApiEventHandler)
  }

  wxApiEventHandler: WeChatSDK.WXApiEventHandler = {
    onReq: (req: WeChatSDK.BaseReq): void => {
      // TODO: 受限于 SDK, 当前无需实现
    },
    onResp: (resp: WeChatSDK.BaseResp): void => {
      const map: Map<string, Any> = new Map()
      map.set("errorCode", resp.errCode)
      map.set("errorMsg", resp.errStr)

      if (resp instanceof WeChatSDK.SendAuthResp) {
        if(resp.errCode == WeChatSDK.ErrCode.ERR_OK) {
          map.set("code", resp.code)
          map.set("state", resp.state)
          map.set("lang", resp.lang)
          map.set("country", resp.country)
        }
        this.channel?.invokeMethod("onAuthResp", map)
      } else if (resp instanceof WeChatSDK.SendMessageToWXResp) {
        this.channel?.invokeMethod("onShareMsgResp", map)
      } else if (resp instanceof WeChatSDK.PayResp) {
        if(resp.errCode == WeChatSDK.ErrCode.ERR_OK) {
          map.set("returnKey", resp.returnKey)
        }
        this.channel?.invokeMethod("onPayResp", map)
      } else if (resp instanceof WeChatSDK.LaunchMiniProgramResp) {
        if(resp.errCode == WeChatSDK.ErrCode.ERR_OK) {
          map.set("extMsg", resp.extMsg)
        }
        this.channel?.invokeMethod("onLaunchMiniProgramResp", map)
      }
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    switch (call.method) {
      case "registerApp":
        this.registerApp(call, result)
        break;
      case "handleInitialWXReq":
        this.handleInitialWXReq(call, result)
        break;
      case "isInstalled":
        const installed = bundleManager.canOpenLink("weixin://")
        result.success(installed)
        break;
      case "isSupportApi":
        // 受限于 SDK, 当前直接返回 false
        result.success(false)
        break;
      case "isSupportStateApi":
        // 受限于 SDK, 当前直接返回 false
        result.success(false)
        break;
      case "openWechat":
        this.handleOpenWechatCall(call, result)
        break;
      case "auth":
        this.handleAuthCall(call, result)
        break;
      case "startQrauth":
      case "stopQrauth":
        this.handleQRAuthCall(call, result)
        break;
      case "openUrl":
        // 受限于 SDK, 当前直接返回 null
        result.success(null)
        break;
      case "openRankList":
        // 受限于 SDK, 当前直接返回 null
        result.success(null)
        break;
      case "shareText":
        this.handleShareTextCall(call, result)
        break;
      case "shareImage":
      case "shareFile":
      case "shareEmoji":
      case "shareMusic":
      case "shareVideo":
      case "shareWebpage":
      case "shareMiniProgram":
        this.handleShareMediaCall(call, result)
        break;
      case "subscribeMsg":
        // 受限于 SDK, 当前直接返回 null
        result.success(null)
        break;
      case "launchMiniProgram":
        this.handleLaunchMiniProgramCall(call, result)
        break;
      case "openCustomerServiceChat":
        // 受限于 SDK, 当前直接返回 null
        break;
      case "openBusinessView":
        // 受限于 SDK, 当前直接返回 null
        break;
      case "openBusinessWebview":
        // 受限于 SDK, 当前直接返回 null
        break;
      case "pay":
        this.handlePayCall(call, result)
        break;
      default:
        result.notImplemented()
        break;
    }
  }

  registerApp(call: MethodCall, result: MethodResult): void {
    const appId: string = call.argument("appId")
    this.wxApi = WeChatSDK.WXAPIFactory.createWXAPI(appId)
    this.diffDevOauth = WeChatSDK.DiffDevOAuthFactory.getDiffDevOAuth()
    result.success(null)
  }

  handleInitialWXReq(call: MethodCall, result: MethodResult): void {
    if(this.abilityBinding) {
      this.wxApi?.handleWant(this.abilityBinding.getAbility().launchWant, this.wxApiEventHandler)
    }
    result.success(null)
  }

  async handleOpenWechatCall(call: MethodCall, result: MethodResult): Promise<void> {
    const didOpen = await this.wxApi?.openWechat(this.abilityBinding?.getAbility().context)
    result.success(didOpen)
  }

  handleAuthCall(call: MethodCall, result: MethodResult): void {
    const request = new WeChatSDK.SendAuthReq()
    request.scope = call.argument("scope")
    request.state = call.argument("state")
    this.wxApi?.sendReq(this.abilityBinding?.getAbility().context, request)
    result.success(null)
  }

  handleQRAuthCall(call: MethodCall, result: MethodResult): void {
    if (call.method === "startQrauth") {
      const appId: string = call.argument("appId")
      const scope: string = call.argument("scope")
      const noncestr: string = call.argument("noncestr")
      const timestamp: string = call.argument("timestamp")
      const signature: string = call.argument("signature")
      this.diffDevOauth?.startOAuth(appId, scope, noncestr, timestamp, signature, this.qrAuthListener)
    } else if (call.method === "stopQrauth") {
      this.diffDevOauth?.stopOAuth()
    }
    result.success(null)
  }

  qrAuthListener: WeChatSDK.OAuthCallback = {
    onGotQRCode: (base64JpegImageBuffer: string): void => {
      const base64Codec = new util.Base64Helper()
      const bytes = base64Codec.decodeSync(base64JpegImageBuffer)
      const resp: Map<string, Any> = new Map()
      resp.set("imageData", bytes)
      this.channel?.invokeMethod("onAuthGotQrcode", resp)
    },
    onQRCodeScanned: (): void => {
      this.channel?.invokeMethod("onAuthQrcodeScanned", null)
    },
    onAuthFinish: (authCode: string): void => {
      const resp: Map<string, Any> = new Map()
      resp.set("errorCode", 0)
      resp.set("authCode", authCode)
      this.channel?.invokeMethod("onAuthFinish", resp)
    },
    onAuthError: (errCode: WeChatSDK.OAuthErrCode, errMsg: string): void => {
      const resp: Map<string, Any> = new Map()
      resp.set("errorCode", errCode)
      resp.set("errorMsg", errMsg)
      this.channel?.invokeMethod("onAuthError", resp)
    }
  }

  handleLaunchMiniProgramCall(call: MethodCall, result: MethodResult): void {
    const request = new WeChatSDK.LaunchMiniProgramReq()
    request.userName = call.argument("username")
    request.path = call.argument("path")
    request.miniprogramType = call.argument("type")
    this.wxApi?.sendReq(this.abilityBinding?.getAbility().context, request)
    result.success(null)
  }

  handlePayCall(call: MethodCall, result: MethodResult): void {
    const request = new WeChatSDK.PayReq()
    request.appId = call.argument("appId")
    request.partnerId = call.argument("partnerId")
    request.prepayId = call.argument("prepayId")
    request.nonceStr = call.argument("noncestr")
    request.timeStamp = call.argument("timestamp")
    request.packageValue = call.argument("package")
    request.sign = call.argument("sign")
    this.wxApi?.sendReq(this.abilityBinding?.getAbility().context, request)
    result.success(null)
  }

  handleShareTextCall(call: MethodCall, result: MethodResult): void {
    const textObj = new WeChatSDK.WXTextObject()
    textObj.text = call.argument("text")

    const mediaMsg = new WeChatSDK.WXMediaMessage()
    mediaMsg.mediaObject = textObj

    const req = new WeChatSDK.SendMessageToWXReq()
    req.scene = call.argument("scene")
    req.message = mediaMsg

    this.wxApi?.sendReq(this.abilityBinding?.getAbility().context, req)

    result.success(null)
  }

  handleShareMediaCall(call: MethodCall, result: MethodResult): void {
    const req = new WeChatSDK.SendMessageToWXReq()
    const mediaMsg = new WeChatSDK.WXMediaMessage()
    if(call.method == "shareImage") {
      const imageObj = new WeChatSDK.WXImageObject()
      if(call.hasArgument("imageData")) {
        const buff: buffer.Buffer = buffer.from(call.argument("imageData"))
        imageObj.imageData = buff.toString("base64", 0, buff.length)
      } else if (call.hasArgument("imageUri")) {
        imageObj.uri = call.argument("imageUri")
      }
      mediaMsg.mediaObject = imageObj
    } else  {
      // 受限于 SDK, 其他分享类型暂时不支持
    }
    this.wxApi?.sendReq(this.abilityBinding?.getAbility().context, req)
    result.success(null)
  }
}