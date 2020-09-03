import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

class TxLiteAvSdk {
  static const MethodChannel _channel = const MethodChannel('tx_lite_av_sdk');
  static MethodChannel _playerChannel;

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

  static Widget getPlayer() {
    Widget player = _TXLiteAVPlayer(
      onCreated: (id) async {
        _playerChannel = MethodChannel('tx_lite_av_sdk_live_player_$id');
      },
    );
    return player;
  }

  static Future<void> startPlay(String url, int type) async {
    await _playerChannel.invokeMethod('startPlay', {
      "url": url,
      "type": type,
    });
  }

  static Future<void> pause() async {
    return await _playerChannel.invokeMethod('pause');
  }

  static Future<void> resume() async {
    return await _playerChannel.invokeMethod('resume');
  }

  static Future<void> stopPlay() async {
    return await _playerChannel.invokeMethod('stopPlay');
  }
}

typedef void OnCreated(int id);

class _TXLiteAVPlayer extends StatefulWidget {
  final OnCreated onCreated;

  _TXLiteAVPlayer({Key key, this.onCreated}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TXLiteAVPlayerState();
  }
}

class _TXLiteAVPlayerState extends State<_TXLiteAVPlayer> {
  @override
  Widget build(BuildContext context) {
    Widget nativeView;
    if (Platform.isIOS) {
      nativeView = UiKitView(
        viewType: 'tx_lite_av_sdk_live_player',
        creationParams: <String, dynamic>{"text": "iOS"},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: widget.onCreated,
      );
    } else if (Platform.isAndroid) {
      // nativeView = AndroidView(
      //   viewType: 'tx_lite_av_live_player',
      //   creationParams: <String, dynamic>{"text": "Android"},
      //   creationParamsCodec: const StandardMessageCodec(),
      //   onPlatformViewCreated: widget.onCreated,
      // );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: nativeView,
    );
  }
}
