package com.canyou.flu_ding;

import android.content.Context;

import androidx.annotation.NonNull;

import com.android.dingtalk.share.ddsharemodule.DDShareApiFactory;
import com.android.dingtalk.share.ddsharemodule.IDDShareApi;
import com.android.dingtalk.share.ddsharemodule.message.SendAuth;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FluDingPlugin */
public class FluDingPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private IDDShareApi iddShareApi;
  private Context applicationContext;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flu_ding");
    channel.setMethodCallHandler(this);
    applicationContext = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "registerApp":
        registerApp(call, result);
        break;
      case "openAPIVersion":
        result.success("a " + android.os.Build.VERSION.RELEASE);
        break;
      case "isDingTalkInstalled":
        if(iddShareApi == null) {
          result.success(false);
          return;
        }
        result.success(iddShareApi.isDDAppInstalled());
        break;
      case "isDingTalkSupportSSO":
        if(iddShareApi == null) {
          result.success(false);
          return;
        }
        SendAuth.Req req = new SendAuth.Req();
        boolean isSupport = req.getSupportVersion() <= iddShareApi.getDDSupportAPI();
        result.success(isSupport);
        break;
      case "openDingTalk":
        if(iddShareApi == null) {
          result.success(false);
          return;
        }
        result.success(iddShareApi.openDDApp());
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private void registerApp(@NonNull MethodCall call, @NonNull Result result) {
    if (iddShareApi != null) {
      result.success(true);
      return;
    }
    String appId = call.argument("appId");
    if (appId.isEmpty()) {
      result.error("invalid app id", "are you sure your app id is correct ?", appId);
      return;
    }
    //todo: Constant.APP_ID 需要更新为用户测试的app_id
    iddShareApi = DDShareApiFactory.createDDShareApi(applicationContext, appId, true);
    boolean isInstalled = iddShareApi.isDDAppInstalled();
    result.success(isInstalled);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
