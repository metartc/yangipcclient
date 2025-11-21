import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 MethodChannel yang_channel = MethodChannel("YangNativeChannel");


Future<void> setLoglevel(
  int viewId,
  int logLevel,
) async {
  await yang_channel.invokeMethod("setLoglevel", {
    "viewId": viewId,
    "logLevel": logLevel,
  });
}

Future<void> setDecodeHw(
  int viewId,
  int isHw,
) async {
  await yang_channel.invokeMethod("setDecodeHw", {
    "viewId": viewId,
    "isHw": isHw,
  });
}

Future<void> setIceConfig(
  int viewId,
  int iceTransportPolicy,
  int iceCandidateType,
) async {
  await yang_channel.invokeMethod("setIceConfig", {
    "viewId": viewId,
    "iceTransportPolicy": iceTransportPolicy,
    "iceCandidateType": iceCandidateType,
  });
}


Future<void> setMqttServer(
  int viewId,
  String ip,
  int port,
  String username,
  String password,
) async {
  await yang_channel.invokeMethod("setMqttServer", {
    "viewId": viewId,
    "ip": ip,
    "port": port,
    "username": username,
    "password": password,
  });
}


Future<void> setIceServer(
  int viewId,
  String ip,
  int port,
  String username,
  String password,
) async {
  await yang_channel.invokeMethod("setIceServer", {
    "viewId": viewId,
    "ip": ip,
    "port": port,
    "username": username,
    "password": password,
  });
}

Future<void> play(
  int viewId,
  String serverTopic,
) async {
  await yang_channel.invokeMethod("play", {
    "viewId": viewId,
    "serverTopic": serverTopic,
  });
}

Future<void> unplay(
  int viewId,
) async {
  await yang_channel.invokeMethod("unplay", {
    "viewId": viewId,
  });
}


class YangNativeView extends StatelessWidget {

  final void Function(int viewId)? onViewCreated;
  const YangNativeView({super.key, this.onViewCreated});

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {

      return AndroidView(

        viewType: 'YangNativeView', // 必须与 Java/Kotlin 中 registerViewFactory 的名称一致

        onPlatformViewCreated: (int id) {

          onViewCreated?.call(id);

        },

        creationParams: const {}, // 非 null 空 Map

        creationParamsCodec: const StandardMessageCodec(),

      );

    } else if (defaultTargetPlatform == TargetPlatform.iOS) {

      return UiKitView(

        viewType: 'YangNativeView',

        onPlatformViewCreated: (int id) {

          onViewCreated?.call(id);

        },

        creationParams: const {},

        creationParamsCodec: const StandardMessageCodec(),

      );

    } else {

      return const SizedBox.shrink(); // 其他平台（如 Web）不支持

    }

  
  }
}