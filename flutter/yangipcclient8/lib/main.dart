import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'YangConfig.dart';
import 'YangChannel.dart';
import 'package:permission_handler/permission_handler.dart';


void main() {
  runApp(const YangMetaplayerApp());
}


class YangMetaplayerApp extends StatelessWidget {
  const YangMetaplayerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'yangipcclient_flutter',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const YangMetaplayerHome(title: 'yangipcclient_flutter'),
    );
  }
}

class YangMetaplayerHome extends StatefulWidget {
  const YangMetaplayerHome({super.key, required this.title});
  final String title;

  @override
  State<YangMetaplayerHome> createState() => _YangMetaplayerHomeState();
}

class _YangMetaplayerHomeState extends State<YangMetaplayerHome> {

  String m_b_text="play";
  bool m_isStart=false;
  int m_viewId=-1;

  String _status = '未请求';


 Future<void> yang_requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    setState(() {
      if (status.isGranted) {
        _status = '已授权';        
      } else if (status.isDenied) {
        _status = '被拒绝';
      } else if (status.isPermanentlyDenied) {
        _status = '永久拒绝，请前往设置开启权限';
      } else if (status.isRestricted) {
        _status = '受限（如家长控制）';
      } else {
        _status = '未知状态';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    yang_requestMicrophonePermission();
  }

  Future<void> yang_play_init() async {
      if(!YangConfig.isInited){
          setLoglevel(m_viewId,YangConfig.logLevel);
          setDecodeHw(m_viewId,YangConfig.decoderSoft);
          setIceConfig(m_viewId,0,2);
          setMqttServer(m_viewId,YangConfig.mqttServerIp,YangConfig.mqttPort,YangConfig.mqttUsername,YangConfig.mqttPassword);
          setIceServer(m_viewId,YangConfig.iceServerIp,YangConfig.icePort,YangConfig.iceUsername,YangConfig.icePassword);
	        
          YangConfig.isInited=true;
      } 
  }


  void play_click(){
    if(!m_isStart){
      yang_play_init();
      play(m_viewId,"test1001");
      setState(() {
      m_b_text="stop";
      });
      m_isStart=true;
       
    }else{
      unplay(m_viewId);
      setState(() {
      m_b_text="play";
      });
      m_isStart=false;
    }   
  }

  @override
  void dispose(){
  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: YangNativeView(
            onViewCreated: (id) {
              setState(() {
                m_viewId = id;
              });
            },
          ),
        ),

        ElevatedButton(
          onPressed: play_click,
          child: Text(m_b_text),
        )
      ],
    ); 
  }
}
