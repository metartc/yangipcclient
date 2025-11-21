import 'package:flutter/material.dart';

class YangConfig{
    static String stringserverTopic="test1001";
    static String mqttServerIp="192.168.0.104";
    static String mqttUsername="";
    static String mqttPassword="";
    static String iceServerIp="192.168.0.104";
    static String iceUsername="metartc";
    static String icePassword="metartc";

    static int mqttPort = 1883;
    static int icePort = 3478;

    static int decoderSoft=0;
    static int decoderHardware=1;

    static int logLevel=5;

    static bool isInited=false;
    static bool startingPlay=false;

}
