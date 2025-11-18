
class YangConfig {
    static serverTopic="test1001";
    static mqttServerIp="192.168.0.104";
    static mqttUsername="";
    static mqttPassword="";
    static iceServerIp="192.168.0.104";
    static iceUsername="metartc";
    static icePassword="metartc";

    static mqttPort = 1883;
    static icePort = 3478;

    static decoderSoft=0;
    static decoderHardware=1;

    static logLevel=5;

    static isInited=false;
    static startingPlay=false;
}


export default YangConfig;