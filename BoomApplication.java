package com.smartisanos.textboom;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.StrictMode;
import android.util.Log;

import com.iflytek.cloud.SpeechUtility;
import com.smartisanos.textboom.statistics.Tracker;
import com.smartisanos.textboom.util.AsyncImageLoader;
import com.smartisanos.textboom.util.ConfigUtils;
import com.smartisanos.textboom.util.LogUtils;
import com.smartisanos.textboom.words.AIUIManager;

public class BoomApplication extends Application {
    private static final String TAG = "BoomApplication";
    private static BoomApplication sApp;

    @Override
    public void onCreate() {
        super.onCreate();
        sApp = this;

        performInit();
        // Setting.setShowLog(true);

        if (Build.VERSION.SDK_INT >= 24) {
            StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
            StrictMode.setVmPolicy(builder.build());
        }
    }

    public static BoomApplication getApplication() {
        return sApp;
    }

    private void performInit() {
        LogUtils.d(TAG, "performInit sApp:" + sApp);
        ConfigUtils.init(this);
        Tracker.init();
        try {
            SpeechUtility.createUtility(this, "appid=" + getString(R.string.app_id) + ",lib_name=msc_voice");
            AIUIManager.setIsInitSuccessed(true);
        } catch (Exception e) {
            Log.i("SpeechUtility", "voice correct model init failed");
            AIUIManager.setIsInitSuccessed(false);
            e.printStackTrace();
        }
        registerActivityLifecycleCallbacks(new ActivityLifecyleManager());
    }
}
