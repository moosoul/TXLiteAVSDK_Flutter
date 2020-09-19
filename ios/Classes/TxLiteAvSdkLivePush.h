//
//  TxLiteAvSdkLivePush.h
//  Pods-Runner
//
//  Created by moosoul on 2020/9/17.
//

#import <Foundation/Foundation.h>
@import Flutter;
NS_ASSUME_NONNULL_BEGIN

@interface TxLiteAvSdkLivePush : NSObject<FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame viewId:(NSInteger)viewId args: (id)args messenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end

NS_ASSUME_NONNULL_END
