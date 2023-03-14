

#import "HinaCloudSDK.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HinaCloudSDK (Exposure)

- (void)addExposureView:(UIView *)view withData:(SAExposureData *)data;
- (void)removeExposureView:(UIView *)view withExposureIdentifier:(nullable NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
