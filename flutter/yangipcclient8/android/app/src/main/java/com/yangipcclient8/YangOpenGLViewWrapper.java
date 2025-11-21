
package com.yangipcclient8;

import android.util.Log;
import android.content.Context;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class YangOpenGLViewWrapper implements PlatformView {
    private final YangOpenGLView yangView;
    private final MethodChannel methodChannel;

    public YangOpenGLViewWrapper(Context context, BinaryMessenger messenger, int viewId) {
        yangView = new YangOpenGLView(context);
        methodChannel = new MethodChannel(messenger, "YangNativeChannel");
        methodChannel.setMethodCallHandler((call, result) -> {
            if (call.method.equals("play")) {
                YangConfig.serverTopic=(String) call.argument("serverTopic");
                yangView.play();
                Log.d("metaRTC", "play>>>>>>>serverTopic="+(String) call.argument("serverTopic"));
                result.success("play successfully");       
            }else if (call.method.equals("unplay")) {
                yangView.unplay();
                Log.d("metaRTC", "unplay>>>>>>>");
                result.success("unplay successfully");       
            }else if (call.method.equals("setLoglevel")) {
                YangConfig.logLevel=((Integer) call.argument("logLevel")).intValue();
                Log.d("metaRTC", "setLoglevel>>>>>>>logLevel="+((Integer) call.argument("logLevel")).intValue());
                result.success("setLoglevel successfully");       
            }else if (call.method.equals("setDecodeHw")) {
                YangConfig.decoderHw = ((Integer) call.argument("isHw")).intValue();
                Log.d("metaRTC", "setDecodeHw>>>>>>>isHw="+((Integer) call.argument("isHw")).intValue());
                result.success("setDecodeHw successfully");       
            }else if (call.method.equals("setIceConfig")) {
                YangConfig.iceTransportPolicy = ((Integer) call.argument("iceTransportPolicy")).intValue();
                YangConfig.iceCandidateType = ((Integer) call.argument("iceCandidateType")).intValue();
                Log.d("metaRTC", "setIceConfig>>>>>>>iceTransportPolicy="+
                ((Integer) call.argument("iceTransportPolicy")).intValue()+",iceCandidateType="+
                ((Integer) call.argument("iceCandidateType")).intValue());
                result.success("setIceConfig successfully");       
            }else if (call.method.equals("setMqttServer")) {
                YangConfig.mqttServerIp=(String) call.argument("ip");
                YangConfig.mqttPort=((Integer) call.argument("port")).intValue();
                YangConfig.mqttUsername=(String) call.argument("username");
                YangConfig.mqttPassword=(String) call.argument("password");
                Log.d("metaRTC", "setMqttServer>>>>>>>ip="+(String) call.argument("ip")+
                ",port="+((Integer) call.argument("port")).intValue()+",username="+(String) call.argument("username")
                +",password="+(String) call.argument("password")
                );
                result.success("setMqttServer successfully");
            } else if (call.method.equals("setIceServer")) {
                YangConfig.iceServerIp=(String) call.argument("ip");
                YangConfig.icePort=((Integer) call.argument("port")).intValue();
                YangConfig.iceUsername=(String) call.argument("username");
                YangConfig.icePassword=(String) call.argument("password");
                Log.d("metaRTC", "setIceServer>>>>>>>ip="+(String) call.argument("ip")+
                ",port="+((Integer) call.argument("port")).intValue()+",username="+(String) call.argument("username")
                +",password="+(String) call.argument("password")
                );
                result.success("setIceServer successfully");
            } else{
                result.notImplemented();
            }       
        });
    }

    @NonNull
    @Override
    public android.view.View getView() {
        return yangView;
    }

    @Override
    public void dispose() {
        methodChannel.setMethodCallHandler(null);
    }
}