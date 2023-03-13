package com.hina.cloud.hina_flutter_plugin;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.hinacloud.analytics.HinaCloudSDK;

import org.json.JSONObject;

import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * HinaFlutterPlugin
 */
public class HinaFlutterPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Activity mActivity;
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "hina_flutter_plugin");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        List list = ((List) call.arguments());
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("init")) {
            Map map = (Map) list.get(0);
            String serverUrl = (String) map.get("serverUrl");
            int flushInterval = (int) map.get("flushInterval");
            int flushBulkSize = (int) map.get("flushBulkSize");
            boolean enableLog = (boolean) map.get("enableLog");

            new HinaCloudSDK.Builder()
                    .enableLog(enableLog)
                    .setServerUrl(serverUrl)
                    .setFlushInterval(flushInterval)
                    .setFlushPendSize(flushBulkSize)
                    .build(mActivity);
        } else if (call.method.equals("track")) {
            HinaCloudSDK.getInstance().track((String) list.get(0), assertProperties((Map) list.get(1)));
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private JSONObject assertProperties(Map map) {
        if (map != null) {
            return new JSONObject(map);
        } else {
            return null;
        }
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        mActivity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }
}
