import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:tx_lite_av_sdk/tx_lite_av_sdk.dart';
import 'package:tx_lite_av_sdk_example/pusher.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  TxLiteAvSdkLivePusher _pusher = TxLiteAvSdkLivePusher();
  TxLiteAvSdkLivePlayer _livePlayer = TxLiteAvSdkLivePlayer();
  TxLiteAvSdkVodPlayer _vodPlayer = TxLiteAvSdkVodPlayer();
  bool fullsize = false;
  bool playing = false;
  bool pausing = false;
  bool dragging = false;
  double progressValue = 0.0;
  double progressMax = 0.0;
  double progressMin = 0.0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _vodPlayer.onProgress = (progress, duration) {
      setState(() {
        if (this.dragging == false) {
          this.progressMax = duration;
          this.progressValue = progress;
        }
      });
    };
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 188.0;
    if (this.fullsize == false) {
      height = width * 9.0 / 16.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: [
            FlatButton(
              child: Text('推流'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Pusher(),
                  ),
                );
              },
            ),
            Container(
              width: width,
              height: height,
              child: _vodPlayer,
              padding: EdgeInsets.zero,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  FlatButton(
                    onPressed: () {
                      // _player.startPlay(
                      //   "https://static.bikaoci.com/videos/GRE_Verbal_Intro.mp4",
                      // );

                      // _pusher.setMirror(true);
                      // _pusher.startPreview();
                      _vodPlayer.startPlay(
                        "https://static.bikaoci.com/videos/GRE_Verbal_Intro.mp4",
                      );
                    },
                    child: Text(this.pausing == false ? '播放' : '暂停'),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        this.fullsize = !this.fullsize;
                      });
                    },
                    child: Text('全屏'),
                  ),
                ],
              ),
            ),
            Slider(
              value: this.progressValue,
              inactiveColor: Colors.black12, //进度中不活动部分的颜色
              label: '${this.progressValue.round()}',
              min: 0.0,
              max: this.progressMax,
              divisions: 1000,
              activeColor: Colors.blue, //进度中活动部分的颜色
              onChangeStart: (value) {
                setState(() {
                  this.dragging = true;
                });
              },
              onChangeEnd: (value) async {
                await _vodPlayer.seek(value);
                setState(() {
                  this.dragging = false;
                });
              },
              onChanged: (value) {
                if (this.dragging == true) {
                  setState(() {
                    this.progressValue = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
