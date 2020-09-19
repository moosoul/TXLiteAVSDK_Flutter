import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:tx_lite_av_sdk/tx_lite_av_sdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  TxLiteAvSdkPush _push = TxLiteAvSdkPush();
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
      await TxLiteAvSdk.registerApp(
        "http://license.vod2.myqcloud.com/license/v1/8a04ed90353d29d10d431478c83058f0/TXLiveSDK.licence",
        "4f819a16063dd7b2ce30754c99970b14",
      );
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
              _push,
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    FlatButton(
                      onPressed: () {
                        _push.startPreview();
                        // _playerController.startPlay(
                        //   'https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8',
                        //   4,
                        // );
                      },
                      child: Text('预览'),
                    ),
                    FlatButton(
                      onPressed: () {
                        _push.startPush(
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
