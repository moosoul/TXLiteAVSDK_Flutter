import 'package:flutter/material.dart';
import 'package:tx_lite_av_sdk/tx_lite_av_sdk.dart';
import 'package:tx_lite_av_sdk/tx_lite_av_sdk_live_player.dart';

class Pusher extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PusherState();
  }
}

class _PusherState extends State<Pusher> {
  TxLiteAvSdkLivePusher _livePusher = TxLiteAvSdkLivePusher();
  bool fullscreen = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (fullscreen) {
      height = height - 148;
    } else {
      height = width * 9 / 16;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pusher'),
      ),
      body: Column(
        children: [
          Container(
            width: width,
            height: height,
            child: _livePusher,
          ),
          Row(
            children: [
              Expanded(
                child: FlatButton(
                  onPressed: () {
                    _livePusher.startPreview();
                  },
                  child: Text('开始推流'),
                ),
              ),
              Expanded(
                child: FlatButton(
                  onPressed: () async {
                    // await _livePusher.stopPreview();
                    // WidgetsBinding.instance.addPostFrameCallback(
                    //   (timeStamp) {
                    //     _livePusher.startPreview();
                    //   },
                    // );
                    setState(() {
                      fullscreen = !fullscreen;
                    });
                  },
                  child: Text('全屏'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
