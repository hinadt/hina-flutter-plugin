

#import "HinaCloudSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface HinaCloudSDK (DebugMode)

/**
 * @abstract
 * 设置是否显示 debugInfoView，对于 iOS，是 UIAlertView／UIAlertController
 *
 * @discussion
 * 设置是否显示 debugInfoView，默认显示
 *
 * @param show             是否显示
 */
- (void)showDebugInfoView:(BOOL)show API_UNAVAILABLE(macos);

- (SensorsAnalyticsDebugMode)debugMode;

@end

NS_ASSUME_NONNULL_END
