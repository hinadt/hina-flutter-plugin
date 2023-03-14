
#import "HinaCloudSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface HinaCloudSDK (JavaScriptBridge)

- (void)trackFromH5WithEvent:(NSString *)eventInfo;

- (void)trackFromH5WithEvent:(NSString *)eventInfo enableVerify:(BOOL)enableVerify;

@end

@interface HNBuildOptions (JavaScriptBridge)

/// 是否开启 WKWebView 的 H5 打通功能，该功能默认是关闭的
@property (nonatomic) BOOL enableJSBridge;

@end

NS_ASSUME_NONNULL_END
