import 'dart:async';
import 'package:flutter/services.dart';
export 'package:tx_lite_av_sdk/tx_lite_av_sdk_live_player.dart';
export 'package:tx_lite_av_sdk/tx_lite_av_sdk_vod_player.dart';
export 'package:tx_lite_av_sdk/tx_lite_av_sdk_live_pusher.dart';
export 'package:tx_lite_av_sdk/tx_lite_av_sdk_enums.dart';

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
}
