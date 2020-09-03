//
//  TxLiteAvSdkLivePlayerFactory.m
//  Pods-Runner
//
//  Created by moosoul on 2020/8/30.
//

#import "TxLiteAvSdkLivePlayer.h"
#import "TxLiteAvSdkLivePlayerFactory.h"

@interface TxLiteAvSdkLivePlayerFactory()

@property (nonatomic, strong) NSObject<FlutterBinaryMessenger>* messenger;

@end

@implementation TxLiteAvSdkLivePlayerFactory

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    self.messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args {
  return [[TxLiteAvSdkLivePlayer alloc] initWithFrame:frame viewId:viewId args:args messenger:self.messenger];
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

@end
