package io.github.v7lin.wechat_kit;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public final class WechatCallbackActivity extends Activity {
    private static final String KEY_WECHAT_CALLBACK = "wechat_callback";
    private static final String KEY_WECHAT_EXTRA = "wechat_extra";

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        handleIntent(getIntent());
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        handleIntent(intent);
    }

    private void handleIntent(Intent intent) {
        final Intent launchIntent = getPackageManager().getLaunchIntentForPackage(getPackageName());
        launchIntent.putExtra(KEY_WECHAT_CALLBACK, true);
        launchIntent.putExtra(KEY_WECHAT_EXTRA, intent);
//        launchIntent.setPackage(getPackageName());
        launchIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(launchIntent);
        finish();
    }

    public static Intent extraCallback(@NonNull Intent intent) {
        if (intent.getExtras() != null && intent.getBooleanExtra(KEY_WECHAT_CALLBACK, false)) {
            final Intent extra = intent.getParcelableExtra(KEY_WECHAT_EXTRA);
            return extra;
        }
        return null;
    }
}
