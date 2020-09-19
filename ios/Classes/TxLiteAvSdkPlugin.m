#import "TxLiteAvSdkPlugin.h"
#import "TxLiteAvSdkLivePlayerFactory.h"
#import "TxLiteAvSdkLivePushFactory.h"
@import TXLiteAVSDK_Professional;


@implementation TxLiteAvSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"tx_lite_av_sdk"
            binaryMessenger:[registrar messenger]];
  TxLiteAvSdkPlugin* instance = [[TxLiteAvSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

  TxLiteAvSdkLivePlayerFactory* playerFactory = [[TxLiteAvSdkLivePlayerFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:playerFactory withId:@"tx_lite_av_sdk_live_player"];
  
  TxLiteAvSdkLivePushFactory* pushFactory = [[TxLiteAvSdkLivePushFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:pushFactory withId:@"tx_lite_av_sdk_live_push"];
  
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
  [TXLiveBase setLogLevel:LOGLEVEL_ERROR];
  NSString *licenceURL = [call.arguments objectForKey:@"licenceURL"];
  NSString *licenceKey = [call.arguments objectForKey:@"licenceKey"];
  [TXLiveBase setLicenceURL:licenceURL key:licenceKey];
  NSLog(@"%@", [TXLiveBase getLicenceInfo]);
  result([NSString stringWithFormat:@"TxLiteAvSdk %@", [TXLiveBase getSDKVersionStr]]);
}

@end
