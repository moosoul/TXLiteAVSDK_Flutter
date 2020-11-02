package com.moosoul.tx_lite_av_sdk;
import android.content.Context;
import android.os.Bundle;
import android.text.Layout;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.tencent.rtmp.TXLivePlayer;
import com.tencent.rtmp.ui.TXCloudVideoView;
import com.tencent.rtmp.ITXLivePlayListener;

import java.lang.reflect.Method;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class TxLiteAvSdkLivePlayer implements PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler, ITXLivePlayListener  {
    private final TXCloudVideoView view;
    private final TXLivePlayer livePlayer;
    private EventChannel.EventSink eventSink;

    TxLiteAvSdkLivePlayer(Context context, BinaryMessenger messenger, int id) {
        LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View layout = inflater.inflate(R.layout.layout, null);

        view = (TXCloudVideoView)layout.findViewById(R.id.video_view);
        livePlayer = new TXLivePlayer(context);
        livePlayer.setPlayerView(view);
        MethodChannel channel = new MethodChannel(messenger, "tx_lite_av_sdk_live_player_"+id);
        EventChannel eventChannel = new EventChannel(messenger, "com.moosoul.tx_lite_av_sdk_live_player_event");
        eventChannel.setStreamHandler(this);
        channel.setMethodCallHandler(this);

    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Log.i("TxLiteAvSdkLivePlayer", "call method: " + call.method + " and arguments: " + call.arguments());
        try {
            Class t_class = this.getClass();
            Method method = t_class.getDeclaredMethod(call.method, new Class[]{MethodCall.class, MethodChannel.Result.class});
            Log.i("TxLiteAvSdkLivePlayer", method.toString());
            method.invoke(this, call, result);
        } catch (Exception e) {
            Log.e("TxLiteAvSdkLivePlayer", e.toString());
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
    public void onPlayEvent(int i, Bundle bundle) {
        Log.i("TxLiteAvSdkLivePlayer", "on play event: " + i);
    }

    @Override
    public void onNetStatus(Bundle bundle) {

    }

    public void startPlay(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean isPlaying = this.livePlayer.isPlaying();
        if (isPlaying) {
            result.success(0);
            return;
        }
        String url = (String) call.argument("url");
        int type = (int)call.argument("type");
        int code = this.livePlayer.startPlay(url, type);
        result.success(code);
    }

    public void stopPlay(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean isNeedClearLastImg = (boolean)call.argument("isNeedClearLastImg");
        int code = this.livePlayer.stopPlay(isNeedClearLastImg);
        result.success(code);
    }

    public void isPlaying(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean code = this.livePlayer.isPlaying();
        result.success(code);
    }

    public void pause(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        this.livePlayer.pause();
        result.success(null);
    }

    public void resume(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        this.livePlayer.resume();
        result.success(null);
    }

    public void setRenderRotation(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        int orientation = (int)call.argument("orientation");
        this.livePlayer.setRenderRotation(orientation);
        result.success(orientation);
    }

    public void setRenderMode(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        int mode = (int)call.argument("mode");
        this.livePlayer.setRenderMode(mode);
        result.success(mode);
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
