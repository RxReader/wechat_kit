package io.github.v7lin.fakewechat;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

public class WechatCallbackActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        handleIntent(getIntent());
        finish();
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        handleIntent(intent);
        finish();
    }

    private void handleIntent(Intent intent) {
        WechatReceiver.sendWechatResp(this, intent);
    }
}
