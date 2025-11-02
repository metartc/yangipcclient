//
// Copyright (c) 2019-2022 yanggaofeng
//
package com.metartc.player;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.net.wifi.WifiManager;
import android.opengl.GLSurfaceView;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import com.metartc.ipcclient.*;

public class YangMainActivity extends AppCompatActivity implements View.OnClickListener {
    private Button m_b_play=null;
    private Button m_b_config=null;
    //private EditText m_url=null;
    private YangYuvPlayer m_surface_view=null;
    private boolean m_startingPlay=false;
    private boolean isPermissionGranted = false;
    private YangIpcClient m_player=null;
    private YangConfigActivity m_configView=null;
    public final static int GET_RECODE_AUDIO = 100;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_main);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
       // WifiManager manager = (WifiManager) this
               // .getSystemService(Context.WIFI_SERVICE);
        if(m_player==null)
            m_player=new YangIpcClient();

        init();
        initSurfaceView();
        requestPermission();
    }

    private void showConfig(){
        if(m_configView==null){
            m_configView=new YangConfigActivity(this);
        }
        m_configView.show();
    }

    private void init() {
        m_b_play = findViewById(R.id.m_b_player);
        m_b_config =  findViewById(R.id.m_b_config);
       // m_url=findViewById(R.id.m_t_url);
        m_b_play.setOnClickListener(this);
        m_b_config.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showConfig();
            }
        });
    }

    @Override
    public void onClick(View v) {
        if(m_startingPlay){
            m_b_play.setText("start");
            m_startingPlay=false;
            m_player.stopPlayer();
        }else {
            if(!YangConfig.isInited) {
                m_player.setLogLevel(YangConfig.logLevelInfo);
                m_player.setDecoder(YangConfig.decoderSoft);
                m_player.setMqttServer(0, YangConfig.mqttServerIp, YangConfig.mqttPort, YangConfig.mqttUsername, YangConfig.mqttPassword);
                m_player.setIceServer(YangConfig.iceServerIp, YangConfig.icePort, YangConfig.iceUsername, YangConfig.icePassword);
                YangConfig.isInited=true;
            }
            if(m_player.startMqtt( YangConfig.serverTopic) != 0){
                //mqtt connect fail
                Log.e("metaRTC", "mqtt start fail!");
                return;
            }
            //m_player.mqttALive() 0:connect fail 1:connect success
            if (m_player.mqttALive()==1 && m_player.startPlayer() == 0) {
                m_startingPlay = true;
                m_b_play.setText("stop");
            }
        }
    }

    private void initSurfaceView() {
        m_surface_view = findViewById(R.id.m_v_surfaceView);
        m_surface_view.getHolder().addCallback(new SurfaceHolder.Callback() {
            @Override
            public void surfaceCreated(SurfaceHolder holder) {
                m_player.setSurface(holder.getSurface());
            }

            @Override
            public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
                m_player.setSurfaceSize(width, height);
            }

            @Override
            public void surfaceDestroyed(SurfaceHolder holder) {
                m_player.releaseResources();
            }
        });
    }

    private void requestPermission() {
        //1. 检查是否已经有该权限
        if (Build.VERSION.SDK_INT >= 23 && (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
                != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED)) {
    //,Manifest.permission.ACCESS_WIFI_STATE
//2. 权限没有开启，请求权限
            ActivityCompat.requestPermissions(this,
                    new String[]{Manifest.permission.RECORD_AUDIO, Manifest.permission.WRITE_EXTERNAL_STORAGE}, GET_RECODE_AUDIO);


        }else{
            //权限已经开启，做相应事情
            isPermissionGranted = true;

            init();
        }
    }
}