package com.yangipcclient8;


import android.content.Context;

import com.facebook.react.uimanager.ThemedReactContext;

import android.util.Log;
import android.view.SurfaceView;
import android.view.SurfaceHolder;


import com.yangipcclient8.*;
import com.metartc.ipcclient.*;

public class YangOpenGLView extends SurfaceView implements  SurfaceHolder.Callback{
    
    private YangIpcClient m_player=null;
    private boolean m_startingPlay=false;

    public YangOpenGLView(ThemedReactContext context) {
        super(context);
        getHolder().addCallback(this);
        if(m_player==null)
            m_player=new YangIpcClient();
        
       
    }

    public int play(){
        if(m_startingPlay) return 0;
        if(!YangConfig.isInited) {

            m_player.setLogLevel(YangConfig.logLevel);
            m_player.setDecoder(YangConfig.decoderHw);
            m_player.setMqttServer(0, YangConfig.mqttServerIp, YangConfig.mqttPort, YangConfig.mqttUsername, YangConfig.mqttPassword);
            m_player.setIceServer(YangConfig.iceServerIp, YangConfig.icePort, YangConfig.iceUsername, YangConfig.icePassword);
            m_player.setIceConfig(YangConfig.iceTransportPolicy,YangConfig.iceCandidateType);
            YangConfig.isInited=true;
        }
        if(m_player.startMqtt( YangConfig.serverTopic) != 0){
            //mqtt connect fail
            Log.e("metaRTC", "mqtt start fail!");
            return 1;
        }
        //m_player.mqttALive() 0:connect fail 1:connect success
        if (m_player.mqttALive()==1 && m_player.startPlayer() == 0) {
            m_startingPlay = true;      
        }


        return 0;
    }
     public int unplay(){
        if(!m_startingPlay) return 0;
        m_startingPlay=false;
        m_player.stopPlayer();
        return 0;
    }

    @Override
    public void surfaceCreated(SurfaceHolder holder) {
      //  Log.i("metaRTC", "surfaceCreated!");
       m_player.setSurface(holder.getSurface());
    }

    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
        // 处理表面变化
      //  Log.i("metaRTC", "surfaceChanged! width="+width+",height="+height);
        m_player.setSurfaceSize(width, height);
    }

    @Override
    public void surfaceDestroyed(SurfaceHolder holder) {
        Log.i("metaRTC", "surfaceDestroyed!");
        if(m_player!=null){
            m_player.releaseResources();
            m_player=null;
        }
      
    }


}
