

#import "HinaCloudSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface HinaCloudSDK (DeviceOrientation)

/**
 * @abstract
 * 设备方向信息采集功能开关
 *
 * @discussion
 * 根据需要决定是否开启设备方向采集
 * 默认关闭
 *
 * @param enable YES/NO
 */
- (void)enableTrackScreenOrientation:(BOOL)enable API_UNAVAILABLE(macos);

@end

NS_ASSUME_NONNULL_END
