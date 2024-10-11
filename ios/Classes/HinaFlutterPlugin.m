#import "HinaFlutterPlugin.h"
#import <HinaCloudSDK/HinaCloudSDK.h>
//#import "SAFlutterGlobalPropertyPlugin.h"
#import <objc/runtime.h>

static NSString* const HinaFlutterPluginMethodGetPlatformVersion = @"getPlatformVersion";
static NSString* const HinaFlutterPluginMethodTrack = @"track";
static NSString* const HinaFlutterPluginMethodTrackTimerStart = @"trackTimerStart";
static NSString* const HinaFlutterPluginMethodTrackTimerEnd = @"trackTimerEnd";
static NSString* const HinaFlutterPluginMethodTrackTimerClear = @"clearTrackTimer";
static NSString* const HinaFlutterPluginMethodTrackInstallation = @"trackInstallation";
static NSString* const HinaFlutterPluginMethodTrackViewScreenWithUrl = @"trackViewScreen";

static NSString* const HinaFlutterPluginMethodLogin = @"setUserUId";
static NSString* const HinaFlutterPluginMethodLogout = @"logout";
static NSString* const HinaFlutterPluginMethodBind = @"bind";
static NSString* const HinaFlutterPluginMethodUnbind = @"unbind";
static NSString* const HinaFlutterPluginMethodLoginWithKey = @"loginWithKey";
static NSString* const HinaFlutterPluginMethodGetDistincsId = @"getDistinctId";
static NSString* const HinaFlutterPluginMethodClearKeychainData = @"clearKeychainData";

static NSString* const HinaFlutterPluginMethodProfileSet = @"userSet";
static NSString* const HinaFlutterPluginMethodProfileSetOnce = @"userSetOnce";
static NSString* const HinaFlutterPluginMethodProfileUnset = @"userUnset";
static NSString* const HinaFlutterPluginMethodProfileIncrement = @"userAdd";
static NSString* const HinaFlutterPluginMethodProfileAppend = @"userAppend";
static NSString* const HinaFlutterPluginMethodProfileDelete = @"userDelete";

static NSString* const HinaFlutterPluginMethodRegisterSuperProperties = @"registerSuperProperties";
static NSString* const HinaFlutterPluginMethodUnregisterSuperProperty = @"unregisterSuperProperty";
static NSString* const HinaFlutterPluginMethodClearSuperProperties = @"clearSuperProperties";
static NSString* const HinaFlutterPluginMethodProfilePushKey = @"setPushUId";
static NSString* const HinaFlutterPluginMethodProfileUnsetPushKey = @"profileUnsetPushId";
static NSString* const HinaFlutterPluginMethodInit = @"init";

/// 回调返回当前为可视化全埋点连接状态
static NSString* const SensorsAnalyticsGetVisualizedConnectionStatus = @"getVisualizedConnectionStatus";

/// 回调返回当前自定义属性配置
static NSString* const SensorsAnalyticsGetVisualizedPropertiesConfig = @"getVisualizedPropertiesConfig";

/// 发送 flutter 发送的页面数据
static NSString* const SensorsAnalyticsSendVisualizedMessage = @"sendVisualizedMessage";

/// 可视化全埋点状态改变，包括连接状态和自定义属性配置
static NSNotificationName const kSAFlutterPluginVisualizedStatusChangedNotification = @"SensorsAnalyticsVisualizedStatusChangedNotification";

@interface HinaFlutterPlugin()
@property (nonatomic, weak) NSObject<FlutterPluginRegistrar> *registrar;

@end

@implementation HinaFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"hina_flutter_plugin"
                                     binaryMessenger:[registrar messenger]];
    HinaFlutterPlugin* instance = [[HinaFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    instance.registrar = registrar;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(chanedVisualizedStatus:) name:kSAFlutterPluginVisualizedStatusChangedNotification object:nil];
    }
    return self;
}

- (void)chanedVisualizedStatus:(NSNotification *)notification {
    if (![notification.userInfo isKindOfClass:NSDictionary.class]) {
        return;
    }
    
    NSDictionary *statusInfo = notification.userInfo;
    FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:@"hina_flutter_plugin" binaryMessenger:[self.registrar messenger]];
    
    if (![statusInfo[@"context"] isKindOfClass:NSString.class]) {
        return;
    }
    
    if ([statusInfo[@"context"] isEqualToString:@"connectionStatus"]) {
        
        // 调用 Flutter， 通知进入可视化全埋点连接状态
        // Method : Method 名称
        // arguments : 传递给 Flutter 的数据
        [methodChannel invokeMethod:@"visualizedConnectionStatusChanged" arguments:nil];
        return;
    }
    
    if ([statusInfo[@"context"] isEqualToString:@"propertiesConfig"]) {
        // 调用 Flutter， 通知 Flutter 自定义属性配置修改
        // Method : Method 名称
        [methodChannel invokeMethod:@"visualizedPropertiesConfigChanged" arguments:nil];
        return;
    }
}


#pragma mark - Flutter 调用接口
/// Flutter 调用接口
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *method = call.method;
    NSArray *arguments = (NSArray *)call.arguments;
    if ([method isEqualToString:HinaFlutterPluginMethodGetPlatformVersion]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }else if([method isEqualToString:HinaFlutterPluginMethodTrack]){
        NSString* event = arguments[0];
        argumentSetNSNullToNil(&event);
        NSDictionary* properties = arguments[1];
        argumentSetNSNullToNil(&properties);
        [self track:event properties:properties];
        result(nil);
    }else if([method isEqualToString:HinaFlutterPluginMethodTrackTimerStart]){
        NSString* event = arguments[0];
        argumentSetNSNullToNil(&event);
        NSString *eventId = [self trackTimerStart:event];
        result(eventId);
    }else if ([method isEqualToString:HinaFlutterPluginMethodTrackTimerEnd]){
        NSString* event = arguments[0];
        argumentSetNSNullToNil(&event);
        NSDictionary* properties = arguments[1];
        argumentSetNSNullToNil(&properties);
        [self trackTimerEnd:event properties:properties];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodTrackTimerClear]){
        [self clearTrackTimer];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodTrackInstallation]){
        NSString* event = arguments[0];
        argumentSetNSNullToNil(&event);
        NSDictionary* properties = arguments[1];
        argumentSetNSNullToNil(&properties);
        [self trackInstallation:event properties:properties];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodTrackViewScreenWithUrl]){
        NSString* url = arguments[0];
        argumentSetNSNullToNil(&url);
        NSDictionary* properties = arguments[1];
        argumentSetNSNullToNil(&properties);
        [self trackViewScreenWithUrl:url porperties:properties];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodLogin]){
        NSString* loginId = arguments[0];
        argumentSetNSNullToNil(&loginId);
        [self login:loginId];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodLogout]){
        [self logout];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodBind]){
        NSString* key = arguments[0];
        NSString* value = arguments[1];
        argumentSetNSNullToNil(&key);
        argumentSetNSNullToNil(&value);
        [self bind:key value:value];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodUnbind]){
        NSString* key = arguments[0];
        NSString* value = arguments[1];
        argumentSetNSNullToNil(&key);
        argumentSetNSNullToNil(&value);
        [self unbind:key value:value];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodLoginWithKey]){
        NSString* key = arguments[0];
        NSString* value = arguments[1];
        argumentSetNSNullToNil(&key);
        argumentSetNSNullToNil(&value);
        [self loginWithKey:key loginId:value];
        result(nil);
    }else if([method isEqualToString:HinaFlutterPluginMethodGetDistincsId]){
        result(self.getDistinctId);
    }else if ([method isEqualToString:HinaFlutterPluginMethodClearKeychainData]){
        [self clearKeychainData];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodProfileSet]){
        NSDictionary* profileDict = arguments[0];
        argumentSetNSNullToNil(&profileDict);
        [self profileSet:profileDict];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodProfileSetOnce]){
        NSDictionary* profileDict = arguments[0];
        argumentSetNSNullToNil(&profileDict);
        [self profileSetOnce:profileDict];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodProfileUnset]){
        NSString* profile = arguments[0];
        argumentSetNSNullToNil(&profile);
        [self profileUnset:profile];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodProfileIncrement]){
        //        NSString *profile = arguments[0];
        //        argumentSetNSNullToNil(&profile);
        //        NSNumber *amount = arguments[1];
        //        argumentSetNSNullToNil(&amount);
        //        [self profileIncrement:profile by:amount];
        NSDictionary *properties = arguments[0];
        argumentSetNSNullToNil(&properties);
        [HinaCloudSDK.sharedInstance add:properties];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodProfileAppend]){
        NSString *profile = arguments[0];
        argumentSetNSNullToNil(&profile);
        NSArray *content = arguments[1];
        argumentSetNSNullToNil(&content);
        [self profileAppend:profile by:content];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodProfileDelete]){
        [self profileDelete];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodRegisterSuperProperties]){
        NSDictionary* propertyDict = arguments[0];
        argumentSetNSNullToNil(&propertyDict);
        [self registerSuperProperties:propertyDict];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodUnregisterSuperProperty]){
        NSString* property = arguments[0];
        argumentSetNSNullToNil(&property);
        [self unregisterSuperProperty:property];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodClearSuperProperties]){
        [self clearSuperProperties];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodProfilePushKey]){
        NSString *pushKey = arguments[0];
        argumentSetNSNullToNil(&pushKey);
        NSString *pushId = arguments[1];
        argumentSetNSNullToNil(&pushId);
        [self profilePushKey:pushKey pushId:pushId];
        result(nil);
    }else if ([method isEqualToString:HinaFlutterPluginMethodProfileUnsetPushKey]){
        NSString *pushKey = arguments[0];
        argumentSetNSNullToNil(&pushKey);
        [self profileUnsetPushKey:pushKey];
        result(nil);
    } else if ([method isEqualToString:@"setServerUrl"]){
        NSString *serverUrl = arguments[0];
        argumentSetNSNullToNil(&serverUrl);
        NSNumber *isRequestRemoteConfig = arguments[1];
        argumentSetNSNullToNil(&isRequestRemoteConfig);
        [self setServerUrl:serverUrl isRequestRemoteConfig:isRequestRemoteConfig.boolValue];
        result(nil);
    } else if ([method isEqualToString:@"getPresetProperties"]){
        NSDictionary *properties = [self getPresetProperties];
        result(properties);
    }  else if ([method isEqualToString:@"enableLog"]){
        NSString *enable = arguments[0];
        argumentSetNSNullToNil(&enable);
        [self enableLog:enable.boolValue];
        result(nil);
    }  else if ([method isEqualToString:@"setFlushNetworkPolicy"]){
        NSNumber *flushNetworkPolicy = arguments[0];
        argumentSetNSNullToNil(&flushNetworkPolicy);
        [self setFlushNetworkPolicy:flushNetworkPolicy.integerValue];
        result(nil);
    }  else if ([method isEqualToString:@"setFlushInterval"]){
        NSNumber *flushInterval = arguments[0];
        argumentSetNSNullToNil(&flushInterval);
        [self setFlushInterval:flushInterval.integerValue];
        result(nil);
    } else if([method isEqualToString:@"getFlushInterval"]){
        result(@([self getFlushInterval]));
    } else if ([method isEqualToString:@"setFlushBulkSize"]){
        NSNumber *flushBulkSize = arguments[0];
        argumentSetNSNullToNil(&flushBulkSize);
        [self setFlushBulkSize:flushBulkSize.integerValue];
        result(nil);
    } else if([method isEqualToString:@"getFlushBulkSize"]){
        result(@([self getFlushBulkSize]));
    } else if ([method isEqualToString:@"getDeviceUId"]){
        NSString *anonymousId = [self getAnonymousId];
        result(anonymousId);
    }  else if ([method isEqualToString:@"getLoginId"]){
        NSString *loginId = [self getLoginId];
        result(loginId);
    }   else if ([method isEqualToString:@"getUserUId"]){
        NSString *loginId = [self getLoginId];
        result(loginId);
    }  else if ([method isEqualToString:@"setDeviceUId"]){
        NSString *distinctId = arguments[0];
        argumentSetNSNullToNil(&distinctId);
        [self identify:distinctId];
        result(nil);
    }  else if ([method isEqualToString:@"trackAppInstall"]){
        NSDictionary *properties = arguments[0];
        argumentSetNSNullToNil(&properties);
        NSNumber *disableCallback = arguments[1];
        argumentSetNSNullToNil(&disableCallback);
        [self trackAppInstall:properties disableCallback:disableCallback.boolValue];
        result(nil);
    }  else if ([method isEqualToString:@"trackTimerPause"]){
        NSString *eventName = arguments[0];
        argumentSetNSNullToNil(&eventName);
        [self trackTimerPause:eventName];
        result(nil);
    }  else if ([method isEqualToString:@"trackTimerResume"]){
        NSString *eventName = arguments[0];
        argumentSetNSNullToNil(&eventName);
        [self trackTimerResume:eventName];
        result(nil);
    }  else if ([method isEqualToString:@"removeTimer"]){
        NSString *eventName = arguments[0];
        argumentSetNSNullToNil(&eventName);
        [self removeTimer:eventName];
        result(nil);
    }  else if ([method isEqualToString:@"flush"]){
        [self flush];
        result(nil);
    }  else if ([method isEqualToString:@"clear"]){
        [self deleteAll];
        result(nil);
    }  else if ([method isEqualToString:@"getSuperProperties"]){
        NSDictionary *properties = [self getSuperProperties];
        result(properties);
    }  else if ([method isEqualToString:@"itemSet"]){
        NSString *itemType = arguments[0];
        argumentSetNSNullToNil(&itemType);
        NSString *itemId = arguments[1];
        argumentSetNSNullToNil(&itemId);
        NSDictionary *properties = arguments[2];
        argumentSetNSNullToNil(&properties);
        [self itemSet:itemType itemId:itemId properties:properties];
        result(nil);
    }  else if ([method isEqualToString:@"itemDelete"]){
        NSString *itemType = arguments[0];
        argumentSetNSNullToNil(&itemType);
        NSString *itemId = arguments[1];
        argumentSetNSNullToNil(&itemId);
        [self itemDelete:itemType itemId:itemId];
        result(nil);
    }  else if ([method isEqualToString:HinaFlutterPluginMethodInit]){
        // flutter 初始化 iOS SDK
        NSDictionary *config = arguments[0];
        argumentSetNSNullToNil(&config);
        [self startWithConfig:config];
        result(nil);
    } else if ([method isEqualToString:SensorsAnalyticsGetVisualizedConnectionStatus]){
        // 动态调用 SDK 接口，获取当前连接状态
        NSNumber *visualizedConnectioned = [self invokeSABridgeWithMethod:method arguments:nil];
        if (![visualizedConnectioned isKindOfClass:NSNumber.class]) {
            result(@(NO));
        }
        result(visualizedConnectioned);
    } else if([method isEqualToString:SensorsAnalyticsGetVisualizedPropertiesConfig]) {
        // 动态调用 SDK 接口，获取当前自定义属性配置
        NSString *jsonString = [self invokeSABridgeWithMethod:method arguments:nil];
        result(jsonString);
    } else if ([method isEqualToString:SensorsAnalyticsSendVisualizedMessage]){
        // 发送 Flutter 页面元素信息
        [self invokeSABridgeWithMethod:method arguments:arguments];
        result(nil);
    }
    
    // ---------新增-----
    else if ([method isEqualToString:@"registerCommonProperties"]){
        //        NSString* event = arguments[0];
        //        argumentSetNSNullToNil(&event);
        NSDictionary* properties = arguments[0];
        argumentSetNSNullToNil(&properties);
        [HinaCloudSDK.sharedInstance registerCommonProperties:^NSDictionary<NSString *,id> * _Nonnull{
            return properties;
        }];
        result(nil);
    }
    
    
    
    
    
    
    else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - 调用 HinaCloudSDK 接口 新增====🔽

#pragma mark - 调用 HinaCloudSDK 接口 新增====🔼

/// 动态调用 SA 接口
- (id)invokeSABridgeWithMethod:(NSString *)methodString arguments:(NSArray *)arguments {
    Class saBridgeClass = NSClassFromString(@"SAFlutterPluginBridge");
    SEL sharedInstanceSelector = NSSelectorFromString(@"sharedInstance");
    if (![saBridgeClass respondsToSelector:sharedInstanceSelector]) {
        return nil;
    }
    id sharedInstance = ((id (*)(id, SEL))[saBridgeClass methodForSelector:sharedInstanceSelector])(saBridgeClass, sharedInstanceSelector);
    if (!sharedInstance) {
        return nil;
    }
    
    // 获取连接状态
    if ([methodString isEqualToString:SensorsAnalyticsGetVisualizedConnectionStatus]) {
        SEL isVisualConnectionedSelector = NSSelectorFromString(@"isVisualConnectioned");
        if (![sharedInstance respondsToSelector:isVisualConnectionedSelector]) {
            return nil;
        }
        BOOL isVisualConnectioned = ((BOOL (*)(id, SEL))[sharedInstance methodForSelector:isVisualConnectionedSelector])(sharedInstance, isVisualConnectionedSelector);
        return @(isVisualConnectioned);
    }
    
    // 获取自定义属性配置
    if ([methodString isEqualToString:SensorsAnalyticsGetVisualizedPropertiesConfig]) {
        SEL visualPropertiesConfigSelector = NSSelectorFromString(@"visualPropertiesConfig");
        if (![sharedInstance respondsToSelector:visualPropertiesConfigSelector]) {
            return nil;
        }
        
        NSString *jsonString = ((NSString * (*)(id, SEL))[sharedInstance methodForSelector:visualPropertiesConfigSelector])(sharedInstance, visualPropertiesConfigSelector);
        return jsonString;
    }
    
    // 发送 Flutter 页面元素信息
    if ([methodString isEqualToString:SensorsAnalyticsSendVisualizedMessage]) {
        NSString *jsonString = arguments[0];
        if (!jsonString) {
            return nil;
        }
        SEL updateFlutterElementInfoSelector = NSSelectorFromString(@"updateFlutterElementInfo:");
        if (![sharedInstance respondsToSelector:updateFlutterElementInfoSelector]) {
            return nil;
        }
        ((void (*)(id, SEL, NSString *))[sharedInstance methodForSelector:updateFlutterElementInfoSelector])(sharedInstance, updateFlutterElementInfoSelector, jsonString);
    }
    return nil;
}



#pragma mark - 调用 HinaCloudSDK 接口
-(void)track:(NSString *)event properties:(nullable NSDictionary *)properties{
    [HinaCloudSDK.sharedInstance track:event withProperties:properties];
}

-(NSString *)trackTimerStart:(NSString *)event{
    return [HinaCloudSDK.sharedInstance trackTimerStart:event];
}

-(void)trackTimerEnd:(NSString *)event properties:(nullable NSDictionary *)properties {
    [HinaCloudSDK.sharedInstance trackTimerEnd:event withProperties:properties];
}

-(void)clearTrackTimer{
    [HinaCloudSDK.sharedInstance clearTrackTimer];
}

-(void)trackInstallation:(NSString *)event properties:(nullable NSDictionary *)properties {
    [HinaCloudSDK.sharedInstance trackInstallation:event withProperties:properties];
}

-(void)login:(NSString *)loginId {
    //    [HinaCloudSDK.sharedInstance login:loginId];
    [HinaCloudSDK.sharedInstance setUserUId:loginId];
}

-(void)logout {
    //    [HinaCloudSDK.sharedInstance logout];
    [HinaCloudSDK.sharedInstance cleanUserUId];
}

- (void)bind:(NSString *)key value:(NSString *)value {
    [HinaCloudSDK.sharedInstance bind:key value:value];
}

- (void)unbind:(NSString *)key value:(NSString *)value {
    [HinaCloudSDK.sharedInstance unbind:key value:value];
}

- (void)loginWithKey:(NSString *)key loginId:(NSString *)loginId {
    [HinaCloudSDK.sharedInstance loginWithKey:key loginId:loginId];
}

-(void)trackViewScreenWithUrl:(NSString *)url porperties:(nullable NSDictionary *)properties {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [HinaCloudSDK.sharedInstance trackViewScreen:url withProperties:properties];
#pragma clang diagnostic pop
}

-(void)profileSet:(NSDictionary *)profileDict{
    [HinaCloudSDK.sharedInstance set:profileDict];
}

-(void)profileSetOnce:(NSDictionary *)profileDict{
    [HinaCloudSDK.sharedInstance setOnce:profileDict];
}

-(void)profileUnset:(NSString *)profile{
    [HinaCloudSDK.sharedInstance unset:profile];
}

-(void)profileIncrement:(NSString *)profile by:(NSNumber *)amount{
    //    [HinaCloudSDK.sharedInstance increment:profile by:amount];
    [HinaCloudSDK.sharedInstance add:profile by:amount];
}

-(void)profileAppend:(NSString *)profile by:(NSArray *)content{
    [HinaCloudSDK.sharedInstance append:profile by:content];
}

-(void)profileDelete{
    [HinaCloudSDK.sharedInstance deleteUser];
}

-(void)clearKeychainData {
    [HinaCloudSDK.sharedInstance clearKeychainData];
}

-(NSString *)getDistinctId{
    return HinaCloudSDK.sharedInstance.distinctId;
}

-(void)registerSuperProperties:(NSDictionary *)propertyDict{
    [HinaCloudSDK.sharedInstance registerSuperProperties:propertyDict];
}

-(void)unregisterSuperProperty:(NSString *)property{
    [HinaCloudSDK.sharedInstance unregisterSuperProperty:property];
}

- (void)clearSuperProperties {
    [HinaCloudSDK.sharedInstance clearSuperProperties];
}

- (void)profilePushKey:(NSString *)pushTypeKey pushId:(nonnull NSString *)pushId {
    //    [HinaCloudSDK.sharedInstance profilePushKey:pushTypeKey pushId:pushId];
    [HinaCloudSDK.sharedInstance userPushKey:pushTypeKey pushId:pushId];
}

- (void)profileUnsetPushKey:(NSString *)pushTypeKey {
    //    [HinaCloudSDK.sharedInstance profileUnsetPushKey:pushTypeKey];
    [HinaCloudSDK.sharedInstance userUnsetPushKey:pushTypeKey];
}

- (void)setServerUrl:(NSString *)serverUrl isRequestRemoteConfig:(BOOL)isRequestRemoteConfig {
    [HinaCloudSDK.sharedInstance setServerUrl:serverUrl isRequestRemoteConfig:isRequestRemoteConfig];
}

- (NSDictionary *)getPresetProperties {
    return [HinaCloudSDK.sharedInstance getPresetProperties];
}

- (void)enableLog:(BOOL)enable {
    [HinaCloudSDK.sharedInstance enableLog:enable];
}

- (void)setFlushNetworkPolicy:(NSInteger)networkPolicy {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [HinaCloudSDK.sharedInstance setFlushNetworkPolicy:networkPolicy];
#pragma clang diagnostic pop
}

- (void)setFlushInterval:(NSInteger)FlushInterval {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [HinaCloudSDK.sharedInstance setFlushInterval:FlushInterval];
#pragma clang diagnostic pop
}

- (void)setFlushBulkSize:(NSInteger)flushBulkSize {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //    [HinaCloudSDK.sharedInstance setFlushBulkSize:flushBulkSize];
    [HinaCloudSDK.sharedInstance setFlushPendSize:flushBulkSize];
#pragma clang diagnostic pop
}

- (NSInteger)getFlushBulkSize {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //    return HinaCloudSDK.sharedInstance.flushBulkSize;
    return HinaCloudSDK.sharedInstance.flushPendSize;
#pragma clang diagnostic pop
}

- (NSInteger)getFlushInterval {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return HinaCloudSDK.sharedInstance.flushInterval;
#pragma clang diagnostic pop
}

- (NSString *)getAnonymousId {
    //    return HinaCloudSDK.sharedInstance.anonymousId;
    return HinaCloudSDK.sharedInstance.deviceUId;
}

- (NSString *)getLoginId {
    return HinaCloudSDK.sharedInstance.userUId;
}

- (void)identify:(NSString *)distinctId {
    //    [HinaCloudSDK.sharedInstance identify:distinctId];
    [HinaCloudSDK.sharedInstance deviceUId:distinctId];
}

- (void)trackAppInstall:(NSDictionary *)properties disableCallback:(BOOL)disableCallback {
    [HinaCloudSDK.sharedInstance trackInstallation:@"$AppInstall" withProperties:properties disableCallback:disableCallback];
}

- (void)trackTimerPause:(NSString *)eventName {
    [HinaCloudSDK.sharedInstance trackTimerPause:eventName];
}

- (void)trackTimerResume:(NSString *)eventName {
    [HinaCloudSDK.sharedInstance trackTimerResume:eventName];
}

- (void)removeTimer:(NSString *)eventName {
    [HinaCloudSDK.sharedInstance removeTimer:eventName];
}

- (void)flush {
    [HinaCloudSDK.sharedInstance flush];
}

- (void)deleteAll {
    //    [HinaCloudSDK.sharedInstance deleteAll];
    [HinaCloudSDK.sharedInstance clear];
}

- (NSDictionary *)getSuperProperties {
    return [HinaCloudSDK.sharedInstance currentSuperProperties];
}

- (void)itemSet:(NSString *)itemType itemId:(NSString *)itemId properties:(NSDictionary *)properties {
    [HinaCloudSDK.sharedInstance itemSetWithType:itemType itemId:itemId properties:properties];
}

- (void)itemDelete:(NSString *)itemType itemId:(NSString *)itemId  {
    [HinaCloudSDK.sharedInstance itemDeleteWithType:itemType itemId:itemId];
}

- (void)startWithConfig:(NSDictionary *)config {
    if (![config isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *serverURL = config[@"serverUrl"];
    if (![serverURL isKindOfClass:[NSString class]]) {
        return;
    }
    
    HNBuildOptions *options = [[HNBuildOptions alloc] initWithServerURL:serverURL launchOptions:nil];
    
    NSNumber *autoTrack = config[@"autoTrackTypePolicy"];
    if ([autoTrack isKindOfClass:[NSNumber class]]) {
        options.autoTrackEventType = [autoTrack integerValue];
    }
    NSNumber *networkTypes = config[@"networkTypePolicy"];
    if ([networkTypes isKindOfClass:[NSNumber class]]) {
        options.flushNetworkPolicy = [networkTypes integerValue];
    }
    NSNumber *flushInterval = config[@"flushInterval"];
    if ([flushInterval isKindOfClass:[NSNumber class]]) {
        options.flushInterval = [flushInterval integerValue];
    }
    
    //    ????
    NSNumber *flushBulksize = config[@"setFlushPendSize"];
    if ([flushBulksize isKindOfClass:[NSNumber class]]) {
        options.flushPendSize = [flushBulksize integerValue];
    }
    NSNumber *enableLog = config[@"enableLog"];
    if ([enableLog isKindOfClass:[NSNumber class]]) {
        options.enableLog = [enableLog boolValue];
    }
//    NSNumber *enableEncrypt = config[@"encrypt"];
//    if ([enableEncrypt isKindOfClass:[NSNumber class]]) {
//        options.enableEncrypt = [enableEncrypt boolValue];
//    }
    
    //    ????
    NSNumber *enableJavascriptBridge = config[@"enableJSBridge"];
    if ([enableJavascriptBridge isKindOfClass:[NSNumber class]]) {
        options.enableJSBridge = [enableJavascriptBridge boolValue];
    }
    
    NSDictionary *iOSConfigs = config[@"ios"];
    if ([iOSConfigs isKindOfClass:[NSDictionary class]] && [iOSConfigs[@"maxCacheSizeForIOS"] isKindOfClass:[NSNumber class]]) {
        options.maxCacheSize = [iOSConfigs[@"maxCacheSizeForIOS"] integerValue];
    }
    
//    NSNumber *enableHeatMap = config[@"heat_map"];
//    if ([enableHeatMap isKindOfClass:[NSNumber class]]) {
//        options.enableHeatMap = [enableHeatMap boolValue];
//    }
//    NSDictionary *visualizedSettings = config[@"visualized"];
//    if ([visualizedSettings isKindOfClass:[NSDictionary class]]) {
//        if ([visualizedSettings[@"autoTrack"] isKindOfClass:[NSNumber class]]) {
//            options.enableVisualizedAutoTrack = [visualizedSettings[@"autoTrack"] boolValue];
//        }
//        if ([visualizedSettings[@"properties"] isKindOfClass:[NSNumber class]]) {
//            options.enableVisualizedProperties = [visualizedSettings[@"properties"] boolValue];
//        }
//    }
    
    //    NSDictionary *properties = config[@"globalProperties"];
    //    if ([properties isKindOfClass:NSDictionary.class]) {
    //        SAFlutterGlobalPropertyPlugin *propertyPlugin = [[SAFlutterGlobalPropertyPlugin alloc] initWithGlobleProperties:properties];
    //        [options registerPropertyPlugin:propertyPlugin];
    //    }
    
    if (NSThread.isMainThread) {
        [HinaCloudSDK startWithConfigOptions:options];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HinaCloudSDK startWithConfigOptions:options];
        });
    }
}

static inline void argumentSetNSNullToNil(id *arg){
    *arg = (*arg == NSNull.null) ? nil:*arg;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
