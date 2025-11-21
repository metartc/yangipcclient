//
//  AppDelegate.m
//  Runner
//
//  Created by yang on 2025/11/19.
//

#import "AppDelegate.h"
#import "YangOpenGLFactory.h"
#import "YangNativePlugin.h"
#import "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [GeneratedPluginRegistrant registerWithRegistry:self];
    YangNativePlugin *plugin = [YangNativePlugin new];
    [plugin.class registerWithRegistrar:[self registrarForPlugin:@"YangNativePlugin"]];

    //id<FlutterPluginRegistrar> registrar = [self registrarForPlugin:@"YangOpenGLPlugin"];
   // [YangNativePlugin registerWithRegistry:[self registrarForPlugin:@"YangNativePlugin"]];

    //FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

   
   //YangOpenGLFactory* factory = [[YangOpenGLFactory alloc] initWithMessenger:registrar.messenger];
   //[registrar registerViewFactory:factory withId:@"yang_opengl_view"];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
