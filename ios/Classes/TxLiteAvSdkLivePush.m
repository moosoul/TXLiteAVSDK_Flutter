//
//  TxLiteAvSdkLivePush.m
//  Pods-Runner
//
//  Created by moosoul on 2020/9/17.
//

#import "TxLiteAvSdkLivePush.h"
@import Flutter;
@import TXLiteAVSDK_Professional;

@interface TxLiteAvSdkLivePush()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) TXLivePush *push;
@property (nonatomic, strong) FlutterMethodChannel *channel;

@end


@implementation TxLiteAvSdkLivePush

- (instancetype)initWithFrame:(CGRect)frame viewId:(NSInteger)viewId args:(id)args messenger:(NSObject<FlutterBinaryMessenger> *)messenger {
  if (self = [super init]) {
    self.contentView = [[UIView alloc] initWithFrame:frame];
    
    TXLivePushConfig *_config = [[TXLivePushConfig alloc] init];  // 一般情况下不需要修改默认 config
    self.push = [[TXLivePush alloc] initWithConfig: _config]; // config 参数不能为空
 
    self.channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"tx_lite_av_sdk_live_push_%ld", (long)viewId] binaryMessenger:messenger];

    __weak typeof(self) weakSelf = self;
    [self.channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
      NSLog(@"tx_lite_av_sdk_live_push call method: %@, arguments: %@", call.method, call.arguments);
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

- (void)startPreview:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  UIView *_localView = [[UIView alloc] initWithFrame:self.view.bounds];
  [self.contentView  insertSubview:_localView atIndex:0];
  _localView.center = self.contentView.center;
  int code = [self.push startPreview:_localView];
  result(@(code));
}

- (void)stopPreview:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  [self.push stopPreview];
}

- (void)startPush:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  NSString *rtmpURL = [call.arguments objectForKey:@"rtmpURL"];
  int code = [self.push startPush:rtmpURL];
  result(@(code));
}

- (void)stopPush:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  [self.push stopPreview];
  [self.push stopPush];
}

- (void)pausePush:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  [self.push pausePush];
}

- (void)resumePush:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  [self.push resumePush];
}

- (void)isPublishing:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  result(@(self.push.isPublishing));
}

- (void)frontCamera:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  result(@(self.push.frontCamera));
}

- (void)setVideoQuality:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  TX_Enum_Type_VideoQuality quality = [[call.arguments objectForKey:@"quality"] intValue];
  BOOL adjustBitrate = [[call.arguments objectForKey:@"adjustBitrate"] boolValue];
  BOOL adjustResolution = [[call.arguments objectForKey:@"adjustResolution"] boolValue];
  [self.push setVideoQuality:quality adjustBitrate:adjustBitrate adjustResolution:adjustResolution];
}

- (void)switchCamera:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  int code = [self.push switchCamera];
  result(@(code));
}

// macOS
//- (void)selectCamera:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
//
//}

- (void)setMirror:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  BOOL isMirror = [[call.arguments objectForKey:@"isMirror"] boolValue];
  [self.push setMirror:isMirror];
}

- (void)setRenderRotation:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  
  int rotation = [[call.arguments objectForKey:@"rotation"] intValue];
  [self.push setRenderRotation:rotation];
}

- (void)toggleTorch:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  BOOL bEnable = [[call.arguments objectForKey:@"bEnable"] boolValue];
  BOOL code = [self.push toggleTorch:bEnable];
  result(@(code));
}

- (void)setZoom:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  CGFloat distance = [[call.arguments objectForKey:@"distance"] doubleValue];
  [self.push setZoom:distance];
}

- (void)setFocusPosition:(FlutterMethodCall * _Nonnull)call result:(FlutterResult  _Nonnull)result {
  CGFloat x = [[call.arguments objectForKey:@"x"] doubleValue];
  CGFloat y = [[call.arguments objectForKey:@"y"] doubleValue];
  [self.push setFocusPosition:CGPointMake(x, y)];
}






- (UIView *)view{
  return self.contentView;
}

@end
