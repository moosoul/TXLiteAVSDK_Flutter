import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tx_lite_av_sdk/tx_lite_av_sdk.dart';

void main() {
  const MethodChannel channel = MethodChannel('tx_lite_av_sdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await TxLiteAvSdk.platformVersion, '42');
  });
}
