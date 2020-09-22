package com.moosoul.tx_lite_av_sdk;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.tencent.rtmp.TXLiveBase;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** TxLiteAvSdkPlugin */
public class TxLiteAvSdkPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;
  private static final int PERMISSION_CAMERA_REQUEST_CODE = 0x00000012;
  private FlutterPluginBinding flutterPluginBinding;


  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {


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

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "tx_lite_av_sdk");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
    flutterPluginBinding.getPlatformViewRegistry().registerViewFactory("tx_lite_av_sdk_live_player", new TxLiteAvSdkLivePlayerFactory(flutterPluginBinding.getBinaryMessenger()));
    flutterPluginBinding.getPlatformViewRegistry().registerViewFactory("tx_lite_av_sdk_live_pusher", new TxLiteAvSdkLivePusherFactory(flutterPluginBinding.getBinaryMessenger()));
  }

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
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "tx_lite_av_sdk");
    channel.setMethodCallHandler(new TxLiteAvSdkPlugin());
    registrar.platformViewRegistry().registerViewFactory("tx_lite_av_sdk_live_player", new TxLiteAvSdkLivePlayerFactory(registrar.messenger()));
    registrar.platformViewRegistry().registerViewFactory("tx_lite_av_sdk_live_pusher", new TxLiteAvSdkLivePusherFactory(registrar.messenger()));
  }


  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if(call.method.equals("registerApp")) {
      this.registerApp(call, result);
    } else {
      result.notImplemented();
    }
  }

  public void registerApp(@NonNull MethodCall call, @NonNull Result result) {
    String licenceURL = call.argument("licenceURL");
    String licenceKey = call.argument("licenceKey");
    TXLiveBase.setLogLevel(1);
    TXLiveBase.getInstance().setLicence(this.context, licenceURL, licenceKey);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
