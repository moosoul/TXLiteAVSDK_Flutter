//
//  TxLiteAvSdkVodPlayerFactory.m
//  Pods-Runner
//
//  Created by moosoul on 2020/8/30.
//

#import "TxLiteAvSdkVodPlayer.h"
#import "TxLiteAvSdkVodPlayerFactory.h"

@interface TxLiteAvSdkVodPlayerFactory()

@property (nonatomic, strong) NSObject<FlutterBinaryMessenger>* messenger;

@end

@implementation TxLiteAvSdkVodPlayerFactory

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    self.messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args {
  return [[TxLiteAvSdkVodPlayer alloc] initWithFrame:frame viewId:viewId args:args messenger:self.messenger];
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

@end
