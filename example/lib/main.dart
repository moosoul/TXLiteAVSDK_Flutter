import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:tx_lite_av_sdk/tx_lite_av_sdk.dart';
import 'package:tx_lite_av_sdk/tx_lite_av_sdk_enums.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  TxLiteAvSdkPusher _pusher = TxLiteAvSdkPusher();
  TxLiteAvSdkPlayer _player = TxLiteAvSdkPlayer();
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await TxLiteAvSdk.platformVersion;
      String licenceURL = "";
      String licenceKey = "";
      await TxLiteAvSdk.registerApp(licenceURL, licenceKey);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  width: 320,
                  child: _pusher,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    FlatButton(
                      onPressed: () {
                        _pusher.startPreview();
                        // _player.startPlay(
                        //   "http://ivi.bupt.edu.cn/hls/cctv1hd.m3u8",
                        //   TX_Enum_PlayType.PLAY_TYPE_VOD_HLS,
                        // );
                      },
                      child: Text('预览'),
                    ),
                    FlatButton(
                      onPressed: () {
                        _pusher.startPush(
                          'rtmp://93873.livepush.myqcloud.com/live/live?txSecret=1066b23fe94374af9d9e453d914960ea&txTime=5F6EA2DC',
                        );
                      },
                      child: Text('开始直播'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
