

#import "HinaCloudSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface HinaCloudSDK (Location)

/**
 * @abstract
 * 位置信息采集功能开关
 *
 * @discussion
 * 根据需要决定是否开启位置采集
 * 默认关闭
 *
 * @param enable YES/NO
 */
- (void)enableTrackGPSLocation:(BOOL)enable API_UNAVAILABLE(macos);

@end

NS_ASSUME_NONNULL_END
