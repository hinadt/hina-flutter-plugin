

#import "HNBuildOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface HNBuildOptions (Exception)

/// 是否自动收集 App Crash 日志，该功能默认是关闭的
@property (nonatomic, assign) BOOL enableTrackAppCrash API_UNAVAILABLE(macos);

@end

NS_ASSUME_NONNULL_END
