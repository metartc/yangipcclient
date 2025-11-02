package com.metartc.player;



import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

public class YangConfigActivity extends Dialog {
    private Button m_b_save=null;
    private Button m_b_cancel=null;
    private EditText m_t_topic=null;
    private EditText m_t_ip=null;
    private EditText m_t_port=null;
    private EditText m_t_mqttUsername=null;
    private EditText m_t_mqttPassword=null;
    private EditText m_t_iceIp=null;
    private EditText m_t_icePort=null;
    private EditText m_t_iceUsername=null;
    private EditText m_t_icePassword=null;
    Activity context;
    public YangConfigActivity(@NonNull Activity pcontext) {
        super(pcontext);
        context=pcontext;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

       setContentView(R.layout.activity_yang_config);
        init();
    }
    private void hideme(){
        this.hide();
    }
    private void init(){
        m_b_save=findViewById(R.id.m_b_ok);
        m_b_cancel=findViewById(R.id.m_b_cancel);
        m_t_topic=findViewById(R.id.m_t_serverTopic);
        m_t_ip=findViewById(R.id.m_t_serverIp);
        m_t_port=findViewById(R.id.m_t_port);
        m_t_mqttUsername=findViewById(R.id.m_t_mqttUsername);
        m_t_mqttPassword=findViewById(R.id.m_t_mqttPassword);
        m_t_iceIp=findViewById(R.id.m_t_iceServerIp);
        m_t_icePort=findViewById(R.id.m_t_icePort);
        m_t_iceUsername=findViewById(R.id.m_t_iceUsername);
        m_t_icePassword=findViewById(R.id.m_t_icePassword);
        m_b_save.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                YangConfig.serverTopic=m_t_topic.getText().toString();
                YangConfig.mqttServerIp=m_t_ip.getText().toString();
                YangConfig.mqttPort=Integer.parseInt(m_t_port.getText().toString());
                YangConfig.mqttUsername=m_t_mqttUsername.getText().toString();
                YangConfig.mqttPassword=m_t_mqttPassword.getText().toString();

                YangConfig.iceServerIp=m_t_iceIp.getText().toString();
                YangConfig.icePort=Integer.parseInt(m_t_icePort.getText().toString());
                YangConfig.iceUsername=m_t_iceUsername.getText().toString();
                YangConfig.icePassword=m_t_icePassword.getText().toString();

                hideme();
            }
        });

        m_b_cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                hideme();
            }
        });
    }


}