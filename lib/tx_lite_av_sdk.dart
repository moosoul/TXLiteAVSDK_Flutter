import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import './tx_lite_av_sdk_enums.dart';
import 'package:permission_handler/permission_handler.dart';

export './tx_lite_av_sdk_enums.dart';

typedef void OnCreated(int id);
typedef void OnTap();

class TxLiteAvSdk {
  static const MethodChannel _channel = const MethodChannel('tx_lite_av_sdk');
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> registerApp(
    String licenceURL,
    String licenceKey,
  ) async {
    return await _channel.invokeMethod(
      'registerApp',
      {
        "licenceURL": licenceURL,
        "licenceKey": licenceKey,
      },
    );
  }

  // static Widget getPlayer() {
  //   Widget player = _TXLiteAVPlayer();

  //   return player;
  // }

  // static Future<void> pause() async {
  //   return await _playerChannel.invokeMethod('pause');
  // }

  // static Future<void> resume() async {
  //   return await _playerChannel.invokeMethod('resume');
  // }

  // static Future<void> stopPlay() async {
  //   return await _playerChannel.invokeMethod('stopPlay');
  // }

}

class TxLiteAvSdkPlayer extends StatefulWidget {
  MethodChannel _channel;

  @override
  State<StatefulWidget> createState() {
    return _TxLiteAvSdkPlayerState();
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
  Future<void> setRenderMode(int renderMode) async {
    return await _channel
        .invokeMethod('setRenderMode', {"renderMode": renderMode});
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

  Future<void> setText(String text) async {
    assert(text != null);
    return _channel.invokeMethod('setText', text);
  }
}

class _TxLiteAvSdkPlayerState extends State<TxLiteAvSdkPlayer> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: 'tx_lite_av_sdk_live_player',
        creationParams: <String, dynamic>{"text": "iOS"},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          widget._channel = MethodChannel('tx_lite_av_sdk_live_player_$id');
          print('channel id: ${widget._channel.name}');
        },
      );
    } else if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'tx_lite_av_sdk_live_player',
        creationParams: <String, dynamic>{"text": "Android"},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          widget._channel = MethodChannel('tx_lite_av_sdk_live_player_$id');
          print('channel id: ${widget._channel.name}');
        },
      );
    }
  }
}

class TxLiteAvSdkPusher extends StatefulWidget {
  MethodChannel _channel;

  @override
  State<StatefulWidget> createState() {
    return _TxLiteAvSdkPusherState();
  }

  /// 开始预览
  Future<int> startPreview() async {
    await [Permission.camera].request();
    return await _channel.invokeMethod('startPreview');
  }

  /// 停止预览
  Future<void> stopPreview() async {
    await _channel.invokeMethod('stopPreview');
  }

  /// 开始推流
  Future<int> startPush(String rtmpURL) async {
    return await _channel.invokeMethod(
      'startPush',
      {"rtmpURL": rtmpURL},
    );
  }

  /// 停止推流
  Future<void> stopPush() async {
    await _channel.invokeMethod('stopPush');
  }

  /// 暂停摄像头采集并进入垫片推流状态。
  Future<void> pausePush() async {
    await _channel.invokeMethod('pausePush');
  }

  /// 恢复摄像头采集并结束垫片推流状态。
  Future<void> resumePush() async {
    await _channel.invokeMethod('resumePush');
  }

  /// 查询是否正在推流。
  Future<bool> isPublishing() async {
    return await _channel.invokeMethod('isPublishing');
  }

  /// 查询当前是否为前置摄像头。
  Future<bool> frontCamera() async {
    return await _channel.invokeMethod('frontCamera');
  }

  /// 设置视频编码质量。
  Future<void> setVideoQuality(
    TX_Enum_Type_VideoQuality quality, {
    bool adjustBitrate = false,
    bool adjustResolution = false,
  }) async {
    return await _channel.invokeMethod('setVideoQuality', {
      "quality": quality,
      "adjustBitrate": adjustBitrate,
      "adjustResolution": adjustResolution
    });
  }

  /// 切换前后摄像头（iOS）。
  Future<int> switchCamera() async {
    return await _channel.invokeMethod('switchCamera');
  }

  /// 选择摄像头（macOS）。
  Future<int> selectCamera() async {
    return await _channel.invokeMethod('selectCamera');
  }

  /// 设置视频镜像效果
  ///
  /// YES：播放端看到的是镜像画面；NO：播放端看到的是非镜像画面。
  Future<void> setMirror(bool isMirror) async {
    return await _channel.invokeMethod('setMirror', {"isMirror": isMirror});
  }

  /// 设置本地摄像头预览画面的旋转方向。
  ///
  /// 取值为0、90、180和270（其他值无效），表示主播端摄像头预览视频的顺时针旋转角度。
  Future<void> setRenderRotation(int rotation) async {
    return await _channel.invokeMethod(
      'setRenderRotation',
      {"rotation": rotation},
    );
  }

  /// 打开后置摄像头旁边的闪关灯
  ///
  /// `bEnable` YES：打开；NO：关闭。
  Future<void> toggleTorch(bool bEnable) async {
    return await _channel.invokeMethod('toggleTorch', {"bEnable": bEnable});
  }

  /// 调整摄像头的焦距。
  ///
  /// `distance` 焦距大小，取值范围：1 - 5，默认值建议设置为1即可。
  ///
  /// 当 distance 为1的时候为最远视角（正常镜头），当为5的时候为最近视角（放大镜头），最大值不要超过5，超过5后画面会模糊不清。
  Future<void> setZoom(double distance) async {
    return await _channel.invokeMethod('setZoom', {"distance": distance});
  }

  /// 设置手动对焦区域。
  ///
  /// SDK 默认使用摄像头自动对焦功能，您也可以通过 TXLivePushConfig 中的 touchFocus 选项关闭自动对焦，改用手动对焦。 改用手动对焦之后，需要由主播自己单击摄像头预览画面上的某个区域，来手动指导摄像头对焦。
  ///
  /// 早期 SDK 版本仅仅提供了手动和自动对焦的选择开关，并不支持设置对焦位置，3.0版本以后，手动对焦的接口才开放出来。
  Future<void> setFocusPosition(double x, double y) async {
    return await _channel.invokeMethod(
      'setFocusPosition',
      {"x": x, "y": y},
    );
  }
}

class _TxLiteAvSdkPusherState extends State<TxLiteAvSdkPusher> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: 'tx_lite_av_sdk_live_pusher',
        creationParams: <String, dynamic>{"text": "iOS"},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          widget._channel = MethodChannel('tx_lite_av_sdk_live_pusher_$id');
          print('channel id: ${widget._channel.name}');
        },
      );
    } else if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'tx_lite_av_sdk_live_pusher',
        creationParams: <String, dynamic>{"text": "Android"},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          widget._channel = MethodChannel('tx_lite_av_sdk_live_pusher_$id');
          print('channel id: ${widget._channel.name}');
        },
      );
    }
  }
}
