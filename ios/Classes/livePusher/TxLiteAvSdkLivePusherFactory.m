//
//  TxLiteAvSdkPusherFactory.m
//  Pods-Runner
//
//  Created by moosoul on 2020/9/17.
//

#import "TxLiteAvSdkLivePusherFactory.h"
#import "TxLiteAvSdkLivePusher.h"

@interface TxLiteAvSdkLivePusherFactory()

@property (nonatomic, strong) NSObject<FlutterBinaryMessenger>* messenger;

@end


@implementation TxLiteAvSdkLivePusherFactory

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    self.messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args {
  return [[TxLiteAvSdkLivePusher alloc] initWithFrame:frame viewId:viewId args:args messenger:self.messenger];
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

@end
