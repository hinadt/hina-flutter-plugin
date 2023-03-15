package com.hina.cloud.hina_flutter_plugin;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.hinacloud.analytics.HinaCloudSDK;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "init":
                init(list);
                break;
            case "track":
                track(list);
                break;
            case "trackTimerStart":
                trackTimerStart(list);
                break;
            case "trackTimerEnd":
                trackTimerEnd(list);
                break;
            case "getPresetProperties":
                getPresetProperties(result);
                break;
            case "userSet":
                userSet(list);
                break;
            case "userSetOnce":
                userSetOnce(list);
                break;
            case "userAdd":
                userAdd(list);
                break;
            case "userAppend":
                userAppend(list);
                break;
            case "userUnset":
                userUnset(list);
                break;
            case "userDelete":
                userDelete();
                break;
            case "setUserUId":
                setUserUId(list);
                break;
            case "setPushUId":
                setPushUId(list);
                break;
            case "setDeviceUId":
                setDeviceUId(list);
                break;
            case "getDeviceUId":
                getDeviceUId(result);
                break;
            case "setFlushPendSize":
                setFlushPendSize(list);
                break;
            case "setFlushInterval":
                setFlushInterval(list);
                break;
            case "flush":
                flush();
                break;
            case "clear":
                clear();
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void init(List list) {
        if (list == null) {
            return;
        }
        Map<String, Object> map = (Map) list.get(0);
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
    }

    private void track(List list) {
        if (list == null) {
            return;
        }
        String eventName = (String) list.get(0);
        JSONObject properties = assertProperties((Map) list.get(1));
        HinaCloudSDK.getInstance().track(eventName, properties);
    }

    private void trackTimerStart(List list) {
        if (list == null) {
            return;
        }
        String eventName = (String) list.get(0);
        HinaCloudSDK.getInstance().trackTimerStart(eventName);
    }

    private void trackTimerEnd(List list) {
        if (list == null) {
            return;
        }
        String eventName = (String) list.get(0);
        JSONObject properties = assertProperties((Map) list.get(1));
        HinaCloudSDK.getInstance().trackTimerEnd(eventName, properties);
    }

    private void getPresetProperties(Result result) {
        JSONObject jsonObject = HinaCloudSDK.getInstance().getPresetProperties();
        if (jsonObject != null) {
            Iterator<String> keys = jsonObject.keys();
            Map<String, Object> map = new HashMap<>();
            while (keys.hasNext()) {
                String key = keys.next();
                Object value = jsonObject.opt(key);
                map.put(key, value);
            }
            result.success(map);
        } else {
            result.success(null);
        }
    }

    private void userSet(List list) {
        if (list == null) {
            return;
        }
        JSONObject properties = assertProperties((Map) list.get(0));
        HinaCloudSDK.getInstance().userSet(properties);
    }

    private void userSetOnce(List list) {
        if (list == null) {
            return;
        }
        JSONObject properties = assertProperties((Map) list.get(0));
        HinaCloudSDK.getInstance().userSetOnce(properties);
    }

    private void userAdd(List list) {
        if (list == null) {
            return;
        }
        JSONObject properties = assertProperties((Map) list.get(0));
        HinaCloudSDK.getInstance().userSetOnce(properties);
    }

    private void userAppend(List list) {
        if (list == null) {
            return;
        }
        String key = (String) list.get(0);
        Set<String> values = (Set<String>) list.get(1);
        HinaCloudSDK.getInstance().userAppend(key, values);
    }

    private void userUnset(List list) {
        if (list == null) {
            return;
        }
        String key = (String) list.get(0);
        HinaCloudSDK.getInstance().userUnset(key);
    }

    private void userDelete() {
        HinaCloudSDK.getInstance().userDelete();
    }

    private void setUserUId(List list) {
        if (list == null) {
            return;
        }
        String userId = (String) list.get(0);
        HinaCloudSDK.getInstance().setUserUId(userId);
    }

    private void setPushUId(List list) {
        if (list == null) {
            return;
        }
        String pushTypeKey = (String) list.get(0);
        String pushUId = (String) list.get(1);
        HinaCloudSDK.getInstance().setPushUId(pushTypeKey, pushUId);
    }

    private void setDeviceUId(List list) {
        if (list == null) {
            return;
        }
        String deviceUId = (String) list.get(0);
        HinaCloudSDK.getInstance().setDeviceUId(deviceUId);
    }

    private void getDeviceUId(Result result) {
        if (result == null) {
            return;
        }
        String deviceUId = HinaCloudSDK.getInstance().getDeviceUId();
        result.success(deviceUId);
    }

    private void setFlushPendSize(List list) {
        if (list == null) {
            return;
        }
        int size = (int) list.get(0);
        HinaCloudSDK.getInstance().setFlushPendSize(size);
    }

    private void setFlushInterval(List list) {
        if (list == null) {
            return;
        }
        int intervalTime = (int) list.get(0);
        HinaCloudSDK.getInstance().setFlushInterval(intervalTime);
    }

    private void flush() {
        HinaCloudSDK.getInstance().flush();
    }

    private void clear() {
        HinaCloudSDK.getInstance().clear();
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
