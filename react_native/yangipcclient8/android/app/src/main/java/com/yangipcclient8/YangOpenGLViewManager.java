package com.yangipcclient8;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import com.metartc.ipcclient.*;
import com.yangipcclient8.YangConfig;

public class YangOpenGLViewManager extends SimpleViewManager<YangOpenGLView> {
    
    public static final String REACT_CLASS = "YangOpenGLView";

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    public YangOpenGLView createViewInstance(ThemedReactContext context) {
      
        return new YangOpenGLView(context);
    }

    @Override
    public void onDropViewInstance(YangOpenGLView view) {
       // view.cleanup();
        super.onDropViewInstance(view);
    }

    // 可以添加属性
    @ReactProp(name = "color")
    public void setColor(YangOpenGLView view, String color) {
        // 处理颜色属性
    }


  // 处理命令
    @Override
    public void receiveCommand(YangOpenGLView view, String commandId,ReadableArray args) {
      // Log.i("metaRTC", "commandId=="+commandId);
        switch (commandId) {
            case "play": // play
                if (args != null && args.size() == 2) {
                    int playState = (int) args.getInt(0);
                    if(playState==0){
                        YangConfig.serverTopic=args.getString(1);
                        view.play();
                    }else{
                        view.unplay();
                    }
                }
                break;
            case "setLoglevel": // setLoglevel
                if (args != null && args.size() == 1) {
                    YangConfig.logLevel=args.getInt(0);
                    Log.d("metaRTC","setLoglevel loglevel="+args.getInt(0));
                }
                break;
            case "setDecodeHw": // setDecodeHw
                if (args != null && args.size() == 1) {
                    YangConfig.decoderHw=args.getInt(0);
                    Log.d("metaRTC","setDecodeHw decoderHw="+args.getInt(0));
                }
                break;
            case "setIceConfig": // setIceConfig
                if (args != null && args.size() == 2) {
                    YangConfig.iceTransportPolicy=args.getInt(0);
                    YangConfig.iceCandidateType=args.getInt(1);
                    Log.d("metaRTC","setIceConfig iceTransportPolicy="+args.getInt(0)+",iceCandidateType="+args.getInt(1));
                }
                break;
            case "setMqttServer": // setMqttServer
                if (args != null && args.size() > 0) {
                    
                    YangConfig.mqttServerIp=args.getString(0);
                    YangConfig.mqttPort=args.getInt(1);
                    YangConfig.mqttUsername=args.getString(2);
                    YangConfig.mqttPassword=args.getString(3);
                    Log.d("metaRTC","setMqttServer mqttServerIp="
                    +args.getString(0)+",mqttPort="+args.getInt(1)+",username="+args.getString(2)
                    +",password="+args.getString(3));
                }
                break;
            case "setIceServer": // setIceServer
                if (args != null && args.size() > 0) {
                    
                    YangConfig.iceServerIp=args.getString(0);
                    YangConfig.icePort=args.getInt(1);
                    YangConfig.iceUsername=args.getString(2);
                    YangConfig.icePassword=args.getString(3);
                      Log.d("metaRTC","setIceServer iceServerIp="
                    +args.getString(0)+",icePort="+args.getInt(1)+",username="+args.getString(2)
                    +",password="+args.getString(3));
                }
                break;
        }
    }
}
