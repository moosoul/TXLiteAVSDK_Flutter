package com.moosoul.tx_lite_av_sdk;

import android.content.Context;

import io.flutter.Log;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class TxLiteAvSdkLivePlayerFactory extends PlatformViewFactory {

    private final BinaryMessenger messenger;

    public TxLiteAvSdkLivePlayerFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        Log.e("", "PlatformViewFactory create > id:" + viewId);
        return new TxLiteAvSdkLivePlayer(context, messenger, viewId);
    }
}
