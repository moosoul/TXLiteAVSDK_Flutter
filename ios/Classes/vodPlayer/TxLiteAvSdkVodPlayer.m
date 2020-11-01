//
//  TxLiteAvSdkVodPlayer.m
//  Pods-Runner
//
//  Created by moosoul on 2020/8/30.
//

#import "TxLiteAvSdkVodPlayer.h"
@import Flutter;
@import TXLiteAVSDK_Professional;

@interface TxLiteAvSdkVodPlayer()<TXVodPlayListener, FlutterStreamHandler>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) TXVodPlayer *vodPlayer;
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) FlutterEventChannel *eventChannel;
@property (nonatomic, strong) FlutterEventSink eventSink;
@end

@implementation TxLiteAvSdkVodPlayer

- (instancetype)initWithFrame:(CGRect)frame viewId:(NSInteger)viewId args: (id)args messenger:(NSObject<FlutterBinaryMessenger>*)messenger{
  if (self = [super init]) {
    self.contentView = [[UIView alloc] initWithFrame:frame];
    self.vodPlayer = [[TXVodPlayer alloc] init];
    [self.vodPlayer setupVideoWidget:self.contentView insertIndex:0];
    self.vodPlayer.vodDelegate = self;
    self.channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"tx_lite_av_sdk_vod_player_%ld", (long)viewId] binaryMessenger:messenger];
    self.eventChannel = [FlutterEventChannel eventChannelWithName:@"com.moosoul.tx_lite_av_sdk_vod_player_event" binaryMessenger:messenger];
    [self.eventChannel setStreamHandler:self];

    
    __weak typeof(self) weakSelf = self;
    [self.channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
      NSLog(@"tx_lite_av_sdk_vod_player call method: %@, arguments: %@", call.method, call.arguments);
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
  [self.vodPlayer startPlay:url];
}

- (void)stopPlay:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  [self.vodPlayer stopPlay];
  [self.vodPlayer removeVideoWidget];
}

- (void)pause:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  [self.vodPlayer pause];
}

- (void)resume:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  [self.vodPlayer resume];
}

- (void)isPlaying:(FlutterMethodCall * _Nonnull)call result:(FlutterResult _Nonnull)result {
  BOOL isPlaying = [self.vodPlayer isPlaying];
  result(@(isPlaying));
}

- (void)setRenderRotation:(FlutterMethodCall * _Nonnull)call result:(FlutterResult _Nonnull)result  {
  
  TX_Enum_Type_HomeOrientation orientation = [[call.arguments objectForKey:@"orientation"] integerValue];
  [self.vodPlayer setRenderRotation: orientation];
  result(@(orientation));
}

- (void)seek:(FlutterMethodCall * _Nonnull)call result:(FlutterResult _Nonnull)result {
  float progress = [[call.arguments objectForKey:@"progress"] floatValue];
  [self.vodPlayer seek:progress];
  result(@(progress));
}


- (UIView *)view{
  return self.contentView;
}



- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
  self.eventSink = events;
  return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
  self.eventSink = nil;
  return nil;
}

- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param {

}

- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary *)param {
  if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
    // 播放进度, 单位是秒, 小数部分为毫秒
    float progress = [param[EVT_PLAY_PROGRESS] floatValue];

    // 视频总长, 单位是秒, 小数部分为毫秒
    float duration = [param[EVT_PLAY_DURATION] floatValue];

    if (self.eventSink) {
      self.eventSink(@{@"progress": @(progress), @"duration": @(duration)});
    }
  }
}

@end
