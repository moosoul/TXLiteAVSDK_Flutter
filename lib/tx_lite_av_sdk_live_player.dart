import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tx_lite_av_sdk/tx_lite_av_sdk_enums.dart';

class TxLiteAvSdkLivePlayer extends StatefulWidget {
  MethodChannel _channel;

  @override
  State<StatefulWidget> createState() {
    return _TxLiteAvSdkLivePlayerState();
  }

  /// 启动从指定 URL 播放 RTMP 音视频流
  Future<int> startPlay(String url, TX_Enum_PlayType type) async {
    return await _channel.invokeMethod('startPlay', {
      "url": url,
      "type": type.index,
    });
  }

  /// 停止播放音视频流。
  Future<void> stopPlay() async {
    await _channel.invokeMethod('stopPlay');
  }

  /// 是否正在播放。
  ///
  /// YES 拉流中，NO 没有拉流。
  Future<bool> isPlaying() async {
    return await _channel.invokeMethod('isPlaying');
  }

  /// 暂停播放
  Future<void> pause() async {
    return await _channel.invokeMethod('pause');
  }

  /// 继续播放
  Future<void> resume() async {
    return await _channel.invokeMethod('resume');
  }

  /// 设置画面的方向
  Future<void> setRenderRotation(int rotation) async {
    return await _channel
        .invokeMethod('setRenderRotation', {"rotation": rotation});
  }

  /// 设置画面的裁剪模式。
  Future<void> setRenderMode(TX_Enum_Type_RenderMode mode) async {
    return await _channel.invokeMethod('setRenderMode', {"mode": mode});
  }

  /// 截图
  // Future<void>snapshot() async {}

  /// 设置静音
  Future<void> setMute(bool bEnable) async {
    return await _channel.invokeMethod('setMute', {"bEnable": bEnable});
  }

  /// 设置音量
  Future<void> setVolume(int volume) async {
    return await _channel.invokeMethod('setVolume', {"volume": volume});
  }

  /// 设置声音模式
  // Future<void> setAudioRoute(int audioRoute) async {
  //   return await _channel
  //       .invokeMethod('setAudioRoute', {"audioRoute": audioRoute});
  // }

  /// 设置状态浮层 view 在渲染 view 上的边距
  Future<void> setLogViewMargin(int margin) async {
    return await _channel.invokeMethod("setLogViewMargin", {"margin": margin});
  }

  /// 是否显示播放状态统计及事件消息浮层 view
  Future<void> showVideoDebugLog(bool isShow) async {
    return await _channel.invokeMethod("showVideoDebugLog", {"isShow": isShow});
  }
}

class _TxLiteAvSdkLivePlayerState extends State<TxLiteAvSdkLivePlayer> {
  @override
  void initState() {
    EventChannel eventChannel =
        EventChannel("com.moosoul.tx_lite_av_sdk_live_player_event");
    eventChannel.receiveBroadcastStream().listen((event) {
      print("com.moosoul.tx_lite_av_sdk_live_player_event: $event");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: 'tx_lite_av_sdk_live_player',
        creationParams: <String, dynamic>{},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          widget._channel = MethodChannel('tx_lite_av_sdk_live_player_$id');
          print('channel id: ${widget._channel.name}');
        },
      );
    } else if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'tx_lite_av_sdk_live_player',
        creationParams: <String, dynamic>{},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          widget._channel = MethodChannel('tx_lite_av_sdk_live_player_$id');
          print('channel id: ${widget._channel.name}');
        },
      );
    }
  }
}
