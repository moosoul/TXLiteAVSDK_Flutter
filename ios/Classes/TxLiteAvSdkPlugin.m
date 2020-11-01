#import "TxLiteAvSdkPlugin.h"
#import "TxLiteAvSdkLivePlayerFactory.h"
#import "TxLiteAvSdkLivePusherFactory.h"
#import "TxLiteAvSdkVodPlayerFactory.h"
@import TXLiteAVSDK_Professional;


@implementation TxLiteAvSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"tx_lite_av_sdk"
            binaryMessenger:[registrar messenger]];
  TxLiteAvSdkPlugin* instance = [[TxLiteAvSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

  TxLiteAvSdkLivePlayerFactory* livePlayerFactory = [[TxLiteAvSdkLivePlayerFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:livePlayerFactory withId:@"tx_lite_av_sdk_live_player"];
  
  TxLiteAvSdkVodPlayerFactory* vodPlayerFactory = [[TxLiteAvSdkVodPlayerFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:vodPlayerFactory withId:@"tx_lite_av_sdk_vod_player"];
  
  TxLiteAvSdkLivePusherFactory* pushFactory = [[TxLiteAvSdkLivePusherFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:pushFactory withId:@"tx_lite_av_sdk_live_pusher"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }  else if ([@"registerApp" isEqualToString:call.method]) {
    [self registerApp:call result:result];
  }  else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)registerApp:(FlutterMethodCall *)call result:(FlutterResult)result {
  [TXLiveBase setLogLevel:LOGLEVEL_VERBOSE];
  NSString *licenceURL = [call.arguments objectForKey:@"licenceURL"];
  NSString *licenceKey = [call.arguments objectForKey:@"licenceKey"];
  [TXLiveBase setLicenceURL:licenceURL key:licenceKey];
  NSLog(@"%@", [TXLiveBase getLicenceInfo]);
  result([NSString stringWithFormat:@"TxLiteAvSdk %@", [TXLiveBase getSDKVersionStr]]);
}

@end
