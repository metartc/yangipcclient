//
//  YangNativePlugin.h
//  Runner
//
//  Created by yang on 2025/11/20.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface YangNativePlugin : NSObject<FlutterPlugin>
+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry;
@end

NS_ASSUME_NONNULL_END
