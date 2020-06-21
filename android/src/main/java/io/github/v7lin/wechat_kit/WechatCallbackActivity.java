package io.github.v7lin.wechat_kit;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

public class WechatCallbackActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        handleIntent(getIntent());
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        handleIntent(intent);
    }

    private void handleIntent(Intent intent) {
        WechatReceiver.sendWechatResp(this, intent);
        finish();
    }
}
