#import "HinaFlutterPlugin.h"

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
    NSDictionary* properties = arguments[1];
    [[HinaCloudSDK sharedInstance] track:event properties:properties];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
