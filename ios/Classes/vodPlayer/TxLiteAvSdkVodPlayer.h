//
//  TxLiteAvSdkVodPlayer.h
//  Pods-Runner
//
//  Created by moosoul on 2020/8/30.
//

#import <Foundation/Foundation.h>
@import Flutter;

NS_ASSUME_NONNULL_BEGIN

@interface TxLiteAvSdkVodPlayer : NSObject<FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame viewId:(NSInteger)viewId args: (id)args messenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end

NS_ASSUME_NONNULL_END
