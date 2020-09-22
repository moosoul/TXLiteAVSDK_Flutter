package com.moosoul.tx_lite_av_sdk;

import android.content.Context;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class TxLiteAvSdkLivePusherFactory extends PlatformViewFactory {

    private final BinaryMessenger messenger;

    public TxLiteAvSdkLivePusherFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        return new TxLiteAvSdkLivePusher(context, messenger, viewId);
    }
}
