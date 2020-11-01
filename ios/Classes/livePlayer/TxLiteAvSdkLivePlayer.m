//
//  TxLiteAvSdkLivePlayer.m
//  Pods-Runner
//
//  Created by moosoul on 2020/8/30.
//

#import "TxLiteAvSdkLivePlayer.h"
@import Flutter;
@import TXLiteAVSDK_Professional;

@interface TxLiteAvSdkLivePlayer()<TXLivePlayListener, FlutterStreamHandler>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) TXLivePlayer *livePlayer;
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) FlutterEventChannel *eventChannel;
@property (nonatomic, weak) FlutterEventSink eventSink;
@end

@implementation TxLiteAvSdkLivePlayer

- (instancetype)initWithFrame:(CGRect)frame viewId:(NSInteger)viewId args: (id)args messenger:(NSObject<FlutterBinaryMessenger>*)messenger{
  if (self = [super init]) {
    self.contentView = [[UIView alloc] initWithFrame:frame];
    self.livePlayer = [[TXLivePlayer alloc] init];
    [self.livePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:self.contentView insertIndex:0];
    self.livePlayer.delegate = self;
    self.channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"tx_lite_av_sdk_live_player_%ld", (long)viewId] binaryMessenger:messenger];
    self.eventChannel = [FlutterEventChannel eventChannelWithName:@"com.moosoul.tx_lite_av_sdk_live_player_event" binaryMessenger:messenger];
    [self.eventChannel setStreamHandler:self];

    
    __weak typeof(self) weakSelf = self;
    [self.channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
      NSLog(@"tx_lite_av_sdk_live_player call method: %@, arguments: %@", call.method, call.arguments);
      NSString *method = [NSString stringWithFormat:@"%@:result:", call.method];
      SEL selector = NSSelectorFromString(method);
      if ([weakSelf respondsToSelector:selector]) {
        IMP imp = [weakSelf methodForSelector:selector];
        void(*func)(id, SEL, FlutterMethodCall *, FlutterResult) = (void *)imp;
        func(weakSelf, selector, call, result);
      }
    }];
  }
  return self;
}

- (void)startPlay:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  NSString *url = [call.arguments objectForKey:@"url"];
  TX_Enum_PlayType type = [[call.arguments objectForKey:@"type"] integerValue];
  [self.livePlayer startPlay:url type:type];
}

- (void)stopPlay:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  [self.livePlayer stopPlay];
  [self.livePlayer removeVideoWidget];
}

- (void)pause:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  [self.livePlayer pause];
}

- (void)resume:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  [self.livePlayer resume];
}

- (void)isPlaying:(FlutterMethodCall * _Nonnull)call resuult:(FlutterResult _Nonnull)result {
  BOOL isPlaying = [self.livePlayer isPlaying];
  result(@(isPlaying));
}

- (void)setRenderRotation:(FlutterMethodCall * _Nonnull)call resuult:(FlutterResult _Nonnull)result  {
  
  TX_Enum_Type_HomeOrientation orientation = [[call.arguments objectForKey:@"orientation"] integerValue];
  [self.livePlayer setRenderRotation: orientation];
  result(@(orientation));
}


- (UIView *)view{
  return self.contentView;
}

- (void)onNetStatus:(NSDictionary *)param {
  
}

- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param {
  NSLog(@"tx_lite_av_sdk_live_player on play event %d", EvtID);
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
  self.eventSink = events;
  return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
  return nil;
}

@end
