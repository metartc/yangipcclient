# yangipcclient

yangipcclient是一个为IPC(Internet Protocol Camera)应用提供多平台的客户端。  
提供了android/ios/浏览器/win/mac/linux六种平台的sdk和demo。  
SDK基于metaRTC8.0开发，默认信令可直接对接metaIPC2.0/metaIPC3.0  
android/ios demo为原生demo，win/mac/linux demo为qt demo。  

# SDK

## C++ SDK

```
class YangIpcPlayer {
public:
	YangIpcPlayer(){};
	~YangIpcPlayer(){};
	void init();//初始化

	int32_t startPlay();//开启客户端对讲
	int32_t stopPlay();//停止客户端对讲

	bool mqttALive(); //mqtt是否连接状态
	int32_t startMqtt(char* serverTopic); //建立mqtt连接，侦听设备端topic

	YangRenderImage* getRenderImage(); //取得设备端视频单帧数据，可用于渲染数据
    //设置是否启用硬解码 android/ios/mac适用
	void setDecodeHw(bool isHw);
    //设置日志输出信息，默认仅输出error
	void setLoglevel(int32_t logLevel);
    //设置ice iceTransportPolicy 0:all 1:relay 默认0
    //iceCandidateType 0:host 1:stun 2:turn 默认2
	void setIceConfig(int32_t iceTransportPolicy,int32_t iceCandidateType);
    //设置ice server(coturn)的ip/port/username/password
	void setIceServer(char* ip,int32_t port,char* username,char* password);
    //设置ice mqtt的ip/port/username/password,isTls:是否启用加密传输
	void setMqttServer(bool isTls,char* ip,int32_t port,char* username,char* passwork);
};
//api demo
//init and config
if(!isInited)
  player->setLoglevel(5);
  player->setDecoder(false);
  player->setMqttServer(m_isTls,m_mqttIP,m_mqttPort,NULL,NULL);
  player->setIceServer((char*)"192.168.0.104",3478,(char*)"metartc", (char*)"metartc");
  isInited=true;
}
//开始对讲
if(player->startMqtt((char*)"test1001")!=Yang_Ok){
  yang_error("mqtt connect fail!");
  return;
}
//mqtt连接成功后开始对讲
if (player->mqttALive() && m_player.startPlayer() == 0) {
  yang_trace("player start success!");
}
//停止对讲
player->stopPlayer();

```

## Html SDK
```
    $(function(){
	$('#datachannel_form').hide();
     // Global handler to do cleanup when replaying.
     $('#rtc_media_player').show();
     var requestConnect=function(){
	//嵌入式设备 mqtt topic
	 yang_pubTopic="test1001";
	 yang_iceServer =[
			{
				urls: [$("#txt_stun").val()] //stun server
			}
			, {
				urls: [$("#txt_turn").val()], //turnserver
				username: $("#txt_turnUsername").val(),
				credential: $("#txt_turnPassword").val()
			}
		];
		 yang_url = yang_get_sfuUrl();
		 if(yang_client&&yang_client.isConnected()){			
			sendLoginMsg();
		 }else{
			  yang_mqtt_connect(mqtt_ip.value,parseInt(mqtt_port.value),yang_clientId);
		}
	}	
```
