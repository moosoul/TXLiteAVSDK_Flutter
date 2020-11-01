package com.moosoul.tx_lite_av_sdk;
import android.content.Context;
import android.os.Bundle;
import android.text.Layout;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.tencent.rtmp.ITXVodPlayListener;
import com.tencent.rtmp.TXLiveConstants;
import com.tencent.rtmp.TXVodPlayer;
import com.tencent.rtmp.ui.TXCloudVideoView;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class TxLiteAvSdkVodPlayer implements PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler, ITXVodPlayListener {
    private final TXCloudVideoView view;
    private final TXVodPlayer vodPlayer;
    private EventChannel.EventSink eventSink;

    TxLiteAvSdkVodPlayer(Context context, BinaryMessenger messenger, int id) {
        LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View layout = inflater.inflate(R.layout.layout, null);

        view = (TXCloudVideoView)layout.findViewById(R.id.video_view);
        vodPlayer = new TXVodPlayer(context);
        vodPlayer.setPlayerView(view);
        vodPlayer.setVodListener(this);
        MethodChannel channel = new MethodChannel(messenger, "tx_lite_av_sdk_vod_player_"+id);
        EventChannel eventChannel = new EventChannel(messenger, "com.moosoul.tx_lite_av_sdk_vod_player_event");
        eventChannel.setStreamHandler(this);
        channel.setMethodCallHandler(this);

    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Log.i("TxLiteAvSdkVodPlayer", "call method: " + call.method + " and arguments: " + call.arguments());
        try {
            Class t_class = this.getClass();
            Method method = t_class.getDeclaredMethod(call.method, new Class[]{MethodCall.class, MethodChannel.Result.class});
            Log.i("TxLiteAvSdkVodPlayer", method.toString());
            method.invoke(this, call, result);
        } catch (Exception e) {
            Log.e("TxLiteAvSdkVodPlayer", e.toString());
            result.notImplemented();
        }
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        this.eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {

    }

    @Override
    public void onPlayEvent(TXVodPlayer txVodPlayer, int i, Bundle bundle) {
        if (i == 2005) {
            int duration = bundle.getInt(TXLiveConstants.EVT_PLAY_DURATION_MS);
            int progress = bundle.getInt(TXLiveConstants.EVT_PLAY_PROGRESS_MS);
            Map<String, Double> map = new HashMap<String, Double>();
            map.put("duration", duration / 1000.0);
            map.put("progress", progress/ 1000.0);
            if (this.eventSink != null) {
                this.eventSink.success(map);
            }
        }
    }


    @Override
    public void onNetStatus(TXVodPlayer txVodPlayer, Bundle bundle) {

    }

    public void startPlay(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        String url = (String) call.argument("url");
        int code = this.vodPlayer.startPlay(url);
        result.success(code);
    }

    public void stopPlay(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean isNeedClearLastImg = (boolean)call.argument("isNeedClearLastImg");
        int code = this.vodPlayer.stopPlay(isNeedClearLastImg);
        result.success(code);
    }

    public void isPlaying(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean code = this.vodPlayer.isPlaying();
        result.success(code);
    }

    public void pause(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        this.vodPlayer.pause();
        result.success(null);
    }

    public void resume(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        this.vodPlayer.resume();
        result.success(null);
    }

    public void setRenderRotation(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        int orientation = (int)call.argument("orientation");
        this.vodPlayer.setRenderRotation(orientation);
        result.success(orientation);
    }

    public void seek(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        double progress = (double)call.argument("progress");
        float progressValue = (float)progress;
        this.vodPlayer.seek(progressValue);
        result.success(progressValue);
    }

    @Override
    public View getView() {
        return this.view;
    }

    @Override
    public void dispose() {
        Log.i("dispose", "PlatformView dispose");
    }
}
