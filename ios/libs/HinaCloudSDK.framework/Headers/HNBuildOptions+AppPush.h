

#import "HNBuildOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface HNBuildOptions (AppPush)

///开启自动采集通知
@property (nonatomic, assign) BOOL enablePushAutoTrack API_UNAVAILABLE(macos);

@end

NS_ASSUME_NONNULL_END
