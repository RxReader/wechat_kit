package io.github.v7lin.wechat_kit;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.text.TextUtils;

public abstract class WechatReceiver extends BroadcastReceiver {

    private static final String ACTION_WECHAT_RESP = WechatReceiver.class.getPackage() + ".action.WECHAT_RESP";

    private static final String KEY_WECHAT_RESP = "wechat_resp";

    @Override
    public void onReceive(Context context, Intent intent) {
        if (TextUtils.equals(ACTION_WECHAT_RESP, intent.getAction())) {
            Intent resp = intent.getParcelableExtra(KEY_WECHAT_RESP);
            handleIntent(resp);
        }
    }

    public abstract void handleIntent(Intent intent);

    public static void registerReceiver(Context context, WechatReceiver receiver) {
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(ACTION_WECHAT_RESP);
        context.registerReceiver(receiver, intentFilter);
    }

    public static void unregisterReceiver(Context context, WechatReceiver receiver) {
        context.unregisterReceiver(receiver);
    }

    public static void sendWechatResp(Context context, Intent resp) {
        Intent intent = new Intent();
        intent.setAction(ACTION_WECHAT_RESP);
        intent.putExtra(KEY_WECHAT_RESP, resp);
        intent.setPackage(context.getPackageName());
        context.sendBroadcast(intent);
    }
}
