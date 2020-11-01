//
//  TXLiteAvSdkLivePlayerFactory.h
//  Pods-Runner
//
//  Created by moosoul on 2020/8/30.
//

#import <Foundation/Foundation.h>
@import Flutter;


NS_ASSUME_NONNULL_BEGIN

@interface TxLiteAvSdkLivePlayerFactory : NSObject<FlutterPlatformViewFactory>

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end

NS_ASSUME_NONNULL_END
