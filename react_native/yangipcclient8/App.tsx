/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React,{useEffect,useState,useRef} from 'react';
import {
  StyleSheet,
  TouchableOpacity,
  UIManager,
  findNodeHandle,
  View,
  Text,
  useWindowDimensions,
  requireNativeComponent,
  PermissionsAndroid,
  Platform,
} from 'react-native';
//import { requireNativeComponent } from 'react-native/Libraries/ReactNative/requireNativeComponent';
import { request, PERMISSIONS, RESULTS } from 'react-native-permissions';

import YangConfig from './YangConfig';

const YangOpenGLView = requireNativeComponent('YangOpenGLView');
//const Commands = UIManager.getViewManagerConfig('YangOpenGLView').Commands;
const App = () => {
  const screenHeight  = useWindowDimensions().height;
  const glHeight = screenHeight * 0.8;

  const [m_title, setButtonTitle] = useState('play');
  const ref=useRef(null);
  const yang_on_play = () =>{
        const viewId = findNodeHandle(ref.current);
        console.debug("viewId==="+viewId);
        if(!YangConfig.isInited){
          UIManager.dispatchViewManagerCommand(viewId,'setLoglevel',[YangConfig.logLevel]);
          UIManager.dispatchViewManagerCommand(viewId,'setDecodeHw',[YangConfig.decoderSoft]);
          UIManager.dispatchViewManagerCommand(viewId,'setIceConfig',[0,2]);
          UIManager.dispatchViewManagerCommand(viewId,'setMqttServer',
            [YangConfig.mqttServerIp,YangConfig.mqttPort,YangConfig.mqttUsername,YangConfig.mqttPassword]);
          UIManager.dispatchViewManagerCommand(viewId,'setIceServer',
            [YangConfig.iceServerIp,YangConfig.icePort,YangConfig.iceUsername,YangConfig.icePassword]);
          
            YangConfig.isInited=true;
        }

        if(YangConfig.startingPlay){
            
            setButtonTitle("play");             
            UIManager.dispatchViewManagerCommand(viewId,'play',[1,'test1001']);
            YangConfig.startingPlay=false;
        }else {  
            setButtonTitle("stop");
            UIManager.dispatchViewManagerCommand(viewId,'play',[0,'test1001']);
            YangConfig.startingPlay = true;
        }
  };

  const yang_on_set = () =>{
       // 其它代码
  };

   
  useEffect(() => {
    const requestMicrophonePermission = async () => {
      try {
        if (Platform.OS === 'android') {
       
          const granted = await PermissionsAndroid.request(
            PermissionsAndroid.PERMISSIONS.RECORD_AUDIO,
            {
              title: '麦克风权限请求',
              message: '应用需要访问麦克风以进行语音录制、语音识别等功能',
              buttonNeutral: '稍后询问',
              buttonNegative: '取消',
              buttonPositive: '确定',
            }
          );
          
          return granted === PermissionsAndroid.RESULTS.GRANTED;
        } else {
          // iOS
          const result = await request(PERMISSIONS.IOS.MICROPHONE);
          return result === RESULTS.GRANTED;
        }
      } catch (err) {
        console.warn('权限请求错误:', err);
        return false;
      }
    };
    
    requestMicrophonePermission();
  }, []);
  

  return (
     <View style={[styles.container, {
      flexDirection: "column"
    }]}>


   <YangOpenGLView 
        ref={ref}
        style={[styles.openglView, { height: glHeight }]}
      />

 <View style={[styles.box,{  backgroundColor:"#841584",flexDirection: "row"}]} >
  <TouchableOpacity
      style={styles.button}
      onPress={yang_on_play}
    >
      <Text style={styles.buttonText}>{m_title}</Text>
    </TouchableOpacity>
      <TouchableOpacity
      style={styles.button}
      onPress={yang_on_set}
    >
      <Text style={styles.buttonText}>设置</Text>
    </TouchableOpacity>
  
   </View>

   </View>
  
  );
};

const styles = StyleSheet.create({
  controlsContainer: {
    flex: 1,
    padding: 15,
    height: 100,
  },
  container: {
    flex: 1,
    padding: 20,
  },
  button: {
    backgroundColor: '#841584', // 背景颜色
    padding: 12,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    margin: 10,
  },
  buttonText: {
    color: 'white', // 文字颜色
    fontSize: 16,
    fontWeight: 'bold',
  },
  box: {
    justifyContent: "center",
    alignItems: "center",
    zIndex:10,
    height:100, 
  },
  openglView: {
    backgroundColor: 'transparent',
  },
  
});

export default App;
