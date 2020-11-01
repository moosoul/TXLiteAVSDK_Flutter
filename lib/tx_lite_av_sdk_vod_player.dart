import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tx_lite_av_sdk/tx_lite_av_sdk_enums.dart';

typedef OnProgress = void Function(double progress, double duration);

class TxLiteAvSdkVodPlayer extends StatefulWidget {
  MethodChannel _methodChannel;
  EventChannel _eventChannel;
  StreamSubscription _streamSubscription;

  OnProgress onProgress;

  TxLiteAvSdkVodPlayer({Key key, this.onProgress}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TxLiteAvSdkVodPlayerState();
  }

  /// 启动从指定 URL 播放 RTMP 音视频流
  Future<int> startPlay(String url) async {
    return await _methodChannel.invokeMethod('startPlay', {
      "url": url,
    });
  }

  /// 停止播放音视频流。
  Future<void> stopPlay() async {
    await _methodChannel.invokeMethod('stopPlay');
  }

  /// 是否正在播放。
  ///
  /// YES 拉流中，NO 没有拉流。
  Future<bool> isPlaying() async {
    return await _methodChannel.invokeMethod('isPlaying');
  }

  /// 暂停播放
  Future<void> pause() async {
    return await _methodChannel.invokeMethod('pause');
  }

  /// 继续播放
  Future<void> resume() async {
    return await _methodChannel.invokeMethod('resume');
  }

  /// 设置画面的方向
  Future<void> setRenderRotation(int rotation) async {
    return await _methodChannel
        .invokeMethod('setRenderRotation', {"rotation": rotation});
  }

  /// 设置画面的裁剪模式。
  Future<void> setRenderMode(int renderMode) async {
    return await _methodChannel
        .invokeMethod('setRenderMode', {"renderMode": renderMode});
  }

  /// 截图
  // Future<void>snapshot() async {}

  /// 设置静音
  Future<void> setMute(bool bEnable) async {
    return await _methodChannel.invokeMethod('setMute', {"bEnable": bEnable});
  }

  /// 设置音量
  Future<void> setVolume(int volume) async {
    return await _methodChannel.invokeMethod('setVolume', {"volume": volume});
  }

  /// 设置声音模式
  // Future<void> setAudioRoute(int audioRoute) async {
  //   return await _channel
  //       .invokeMethod('setAudioRoute', {"audioRoute": audioRoute});
  // }

  /// 设置状态浮层 view 在渲染 view 上的边距
  Future<void> setLogViewMargin(int margin) async {
    return await _methodChannel
        .invokeMethod("setLogViewMargin", {"margin": margin});
  }

  /// 是否显示播放状态统计及事件消息浮层 view
  Future<void> showVideoDebugLog(bool isShow) async {
    return await _methodChannel
        .invokeMethod("showVideoDebugLog", {"isShow": isShow});
  }

  Future<void> seek(double progress) async {
    return await _methodChannel.invokeMethod("seek", {"progress": progress});
  }
}

class _TxLiteAvSdkVodPlayerState extends State<TxLiteAvSdkVodPlayer> {
  @override
  void dispose() {
    widget._streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: 'tx_lite_av_sdk_vod_player',
        creationParams: <String, dynamic>{},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          widget._methodChannel =
              MethodChannel('tx_lite_av_sdk_vod_player_$id');
          widget._eventChannel =
              EventChannel("com.moosoul.tx_lite_av_sdk_vod_player_event");
          widget._streamSubscription =
              widget._eventChannel.receiveBroadcastStream().listen((event) {
            if (widget.onProgress != null) {
              widget.onProgress(event["progress"], event["duration"]);
            }
          });
        },
      );
    } else if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'tx_lite_av_sdk_vod_player',
        creationParams: <String, dynamic>{},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          widget._methodChannel =
              MethodChannel('tx_lite_av_sdk_vod_player_$id');
          widget._eventChannel =
              EventChannel("com.moosoul.tx_lite_av_sdk_vod_player_event");
          widget._streamSubscription =
              widget._eventChannel.receiveBroadcastStream().listen((event) {
            widget.onProgress(event["progress"], event["duration"]);
          });
        },
      );
    }
  }
}
