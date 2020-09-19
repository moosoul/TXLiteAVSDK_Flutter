//
//  TxLiteAvSdkLivePlayer.m
//  Pods-Runner
//
//  Created by moosoul on 2020/8/30.
//

#import "TxLiteAvSdkLivePlayer.h"
@import Flutter;
@import TXLiteAVSDK_Professional;

@interface TxLiteAvSdkLivePlayer()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) TXLivePlayer *livePlayer;
@property (nonatomic, strong) FlutterMethodChannel *channel;

@end

@implementation TxLiteAvSdkLivePlayer

- (instancetype)initWithFrame:(CGRect)frame viewId:(NSInteger)viewId args: (id)args messenger:(NSObject<FlutterBinaryMessenger>*)messenger{
  if (self = [super init]) {
    self.contentView = [[UIView alloc] initWithFrame:frame];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.contentView addGestureRecognizer:singleFingerTap];
    
    self.livePlayer = [[TXLivePlayer alloc] init];
    [self.livePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:self.contentView insertIndex:0];
    
    self.channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"tx_lite_av_sdk_live_player_%ld", (long)viewId] binaryMessenger:messenger];
    
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
  NSString *url = [[call.arguments objectForKey:@"url"] stringValue];
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

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
  NSLog(@"HANDLE SINGLE TAP");
}


- (UIView *)view{
  return self.contentView;
}

@end
