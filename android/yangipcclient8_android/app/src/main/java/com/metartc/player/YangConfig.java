package com.metartc.player;

public class YangConfig {
   public static String serverTopic="test1001";
   public static String mqttServerIp="192.168.0.104";
    public static String mqttUsername="";
    public static String mqttPassword="";
    public static String iceServerIp="192.168.0.104";
    public static String iceUsername="metartc";
    public static String icePassword="metartc";

    public static int mqttPort = 1883;
    public static int icePort = 3478;

    public static int decoderSoft=0;
    public static int decoderHardware=1;

    public static int logLevelInfo=5;

    public static boolean isInited=false;


}
