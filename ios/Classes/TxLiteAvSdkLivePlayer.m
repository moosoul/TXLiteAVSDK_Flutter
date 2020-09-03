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
    self.livePlayer = [[TXLivePlayer alloc] init];
    [self.livePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:self.contentView insertIndex:0];
    
    self.channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"tx_lite_av_sdk_live_player_%ld", (long)viewId] binaryMessenger:messenger];
    
    __weak typeof(self) weakSelf = self;
    [self.channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
      NSLog(@"tx_lite_av_sdk_live_player call method: %@", call.method);
      if ([@"startPlay" isEqualToString:call.method]) {
        [weakSelf startPlay:call result:result];
      } else if ([@"stoptPlay" isEqualToString:call.method]) {
        [weakSelf stopPlay:call result:result];
      } else if ([@"pause" isEqualToString:call.method]) {
        [weakSelf pause:call result:result];
      } else if ([@"resume" isEqualToString:call.method]) {
        [weakSelf resume:call result:result];
      } else {
        
      }
    }];
    

    
  }
  return self;
}

- (void)startPlay:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  NSString *url = [call.arguments objectForKey:@"url"];
  NSNumber *type = [call.arguments objectForKey:@"type"];
  [self.livePlayer startPlay:url type:[type integerValue]];
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


- (UIView *)view{
  return self.contentView;
}

@end
