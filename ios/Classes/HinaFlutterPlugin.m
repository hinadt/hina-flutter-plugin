#import "HinaFlutterPlugin.h"
#import <objc/runtime.h>

@implementation HinaFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"hina_flutter_plugin"
            binaryMessenger:[registrar messenger]];
  HinaFlutterPlugin* instance = [[HinaFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"track" isEqualToString:call.method]) {
        
        NSString* event = arguments[0];
        argumentSetNSNullToNil(&event);
        NSDictionary* properties = arguments[1];
        argumentSetNSNullToNil(&properties);
        [[HinaCloudSDK sharedInstance] track:event properties:properties];
        result(nil);
        
    } else if ([@"init" isEqualToString:call.method]) {
        // flutter 初始化 iOS SDK
        NSDictionary *config = arguments[0];
        argumentSetNSNullToNil(&config);
        [[HinaCloudSDK sharedInstance] startWithConfig:config];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
