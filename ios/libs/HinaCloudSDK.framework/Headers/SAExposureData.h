

#import "SAExposureConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface SAExposureData : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// init method
/// @param event event name
- (instancetype)initWithEvent:(NSString *)event;

/// init method
/// @param event event name
/// @param properties custom event properties, if no, use nil
- (instancetype)initWithEvent:(NSString *)event properties:(nullable NSDictionary *)properties;

/// init method
/// @param event event name
/// @param properties custom event properties, if no, use nil
/// @param exposureIdentifier identifier for view
- (instancetype)initWithEvent:(NSString *)event properties:(nullable NSDictionary *)properties exposureIdentifier:(nullable NSString *)exposureIdentifier;

/// init method
/// @param event event name
/// @param properties custom event properties, if no, use nil
/// @param config exposure config, if nil, use global config in HNBuildOptions
- (instancetype)initWithEvent:(NSString *)event properties:(nullable NSDictionary *)properties config:(nullable SAExposureConfig *)config;

/// init method
/// @param event event name
/// @param properties custom event properties, if no, use nil
/// @param exposureIdentifier identifier for view
/// @param config exposure config, if nil, use global config in HNBuildOptions
- (instancetype)initWithEvent:(NSString *)event properties:(nullable NSDictionary *)properties exposureIdentifier:(nullable NSString *)exposureIdentifier config:(nullable SAExposureConfig *)config;

@end

NS_ASSUME_NONNULL_END
