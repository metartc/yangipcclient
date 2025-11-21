package com.yangipcclient8;

import android.util.Log;
import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import io.flutter.plugin.common.StandardMessageCodec;
import java.util.Map;
import java.util.Collections;


public class YangOpenGLViewFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;
    private final int viewId;
    public YangOpenGLViewFactory(BinaryMessenger messenger, int viewId) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
        this.viewId = viewId;
    }

    @NonNull
    @Override
    public PlatformView create(@NonNull Context context, int id, @Nullable Object args) {
        Map<?, ?> params = (args instanceof Map) ? (Map<?, ?>) args : Collections.emptyMap();
        return new YangOpenGLViewWrapper(context, messenger, viewId);

    }
}