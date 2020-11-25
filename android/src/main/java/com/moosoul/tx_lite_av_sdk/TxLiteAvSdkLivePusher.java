package com.moosoul.tx_lite_av_sdk;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.pm.PackageManager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.tencent.rtmp.TXLivePushConfig;
import com.tencent.rtmp.TXLivePusher;
import com.tencent.rtmp.ui.TXCloudVideoView;

import java.lang.reflect.Method;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class TxLiteAvSdkLivePusher implements PlatformView, MethodChannel.MethodCallHandler {



    private final TXCloudVideoView view;
    private final TXLivePushConfig config;
    private final TXLivePusher pusher;
    private final Context context;

    private boolean isFrontCamera = true;

    TxLiteAvSdkLivePusher(Context context, BinaryMessenger messenger, int id) {
        this.context = context;
        LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View layout = inflater.inflate(R.layout.layout, null);
        view = (TXCloudVideoView)layout.findViewById(R.id.video_view);
        config = new TXLivePushConfig();
        pusher = new TXLivePusher(context);
        pusher.setConfig(config);
        MethodChannel channel = new MethodChannel(messenger, "tx_lite_av_sdk_live_pusher_"+id);
        channel.setMethodCallHandler(this);
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

        Log.i("TxLiteAvSdkLivePush", "call method: " + call.method + " and arguments: " + call.arguments());
        try {
            Class t_class = this.getClass();
            Method method = t_class.getDeclaredMethod(call.method, new Class[]{MethodCall.class, MethodChannel.Result.class});
            Log.i("TxLiteAvSdkLivePush", method.toString());
            method.invoke(this, call, result);
        } catch (Exception e) {
            Log.e("TxLiteAvSdkLivePush", e.toString());
            result.notImplemented();
        }
    }

    public void startPreview(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        this.pusher.startCameraPreview(this.view);
        result.success(null);
    }

    public void stopPreview(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean isNeedClearLastImg = (boolean)call.argument("isNeedClearLastImg");
        this.pusher.stopCameraPreview(isNeedClearLastImg);
        result.success(null);
    }

    public void startPush(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        String rtmpURL = (String) call.argument("rtmpURL");
        int code = this.pusher.startPusher(rtmpURL);
        Log.i("TxLiteAvSdkLivePush", "startPusher code: " + code);
        result.success(code);
    }

    public void stopPush(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean isNeedClearLastImg = (boolean)call.argument("isNeedClearLastImg");
        this.pusher.stopCameraPreview(isNeedClearLastImg);
        this.pusher.stopPusher();
        result.success(null);
    }

    public void pausePush(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        this.pusher.pausePusher();
        result.success(null);
    }

    public void resumePush(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        this.pusher.resumePusher();
        result.success(null);
    }

    public void isPublishing(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean isPushing = this.pusher.isPushing();
        result.success(isPushing);
    }

    public void frontCamera(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        result.success(isFrontCamera);
    }

    public void switchCamera(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        this.pusher.switchCamera();
        this.isFrontCamera = !this.isFrontCamera;
        result.success(null);
    }

    public void setVideoQuality(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        int quality = (int)call.argument("quality");
        boolean adjustBitrate = (boolean)call.argument("adjustBitrate");
        boolean adjustResolution = (boolean)call.argument("adjustResolution");
        this.pusher.setVideoQuality(quality, adjustBitrate, adjustResolution);
        result.success(null);
    }

    public void setMirror(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean isMirror = (boolean)call.argument("isMirror");
        this.pusher.setMirror(isMirror);
        result.success(null);
    }

    public void setRenderRotation(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        int rotation = (int)call.argument("rotation");
        this.pusher.setRenderRotation(rotation);
        result.success(null);
    }

    public void toggleTorch(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean bEnable = (boolean)call.argument("bEnable");
        boolean code = this.pusher.turnOnFlashLight(bEnable);
        result.success(code);
    }

    public void getMaxZoom(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        int code = this.pusher.getMaxZoom();
        result.success(code);
    }

    public void setZoom(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        int distance = (int)call.argument("distance");
        boolean code = this.pusher.setZoom(distance);
        result.success(code);
    }

    public void setFocusPosition(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        float x = (float)call.argument("x");
        float y = (float)call.argument("y");
        this.pusher.setFocusPosition(x, y);
        result.success(null);
    }

    @Override
    public View getView() {
        return this.view;
    }

    @Override
    public void dispose() {
        this.pusher.stopCameraPreview(true);
        this.pusher.stopPusher();
    }
}
