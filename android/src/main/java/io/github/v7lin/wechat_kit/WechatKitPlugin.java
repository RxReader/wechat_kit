package io.github.v7lin.wechat_kit;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** WechatKitPlugin */
public class WechatKitPlugin implements FlutterPlugin, ActivityAware {
  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    WechatKit wechatKit = new WechatKit(registrar.context(), registrar.activity());
    registrar.addViewDestroyListener(wechatKit);
    wechatKit.startListening(registrar.messenger());
  }

  // --- FlutterPlugin

  private final WechatKit wechatKit;

  public WechatKitPlugin() {
    wechatKit = new WechatKit();
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    wechatKit.setApplicationContext(binding.getApplicationContext());
    wechatKit.setActivity(null);
    wechatKit.startListening(binding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    wechatKit.stopListening();
    wechatKit.setActivity(null);
    wechatKit.setApplicationContext(null);
  }

  // --- ActivityAware

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    wechatKit.setActivity(binding.getActivity());
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
    wechatKit.setActivity(null);
  }
}
