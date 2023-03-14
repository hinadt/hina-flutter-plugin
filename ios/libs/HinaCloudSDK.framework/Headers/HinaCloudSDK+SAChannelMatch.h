

#import "HinaCloudSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface HinaCloudSDK (SAChannelMatch)

/**
 调用 track 接口并附加渠道信息

 @param event event 的名称
 */
- (void)trackChannelEvent:(NSString *)event;

/**
调用 track 接口并附加渠道信息

 @param event event 的名称
 @param propertyDict event 的属性
 */
- (void)trackChannelEvent:(NSString *)event properties:(nullable NSDictionary *)propertyDict;

/**
 * @abstract
 * 用于在 App 首次启动时追踪渠道来源，SDK 会将渠道值填入事件属性 $utm_ 开头的一系列属性中
 *
 * @discussion
 * 注意：如果之前使用 -  trackInstallation: 触发的激活事件，需要继续保持原来的调用，无需改成 - trackAppInstall: ，否则会导致激活事件数据分离。
 */
- (void)trackAppInstall;

/**
 * @abstract
 * 用于在 App 首次启动时追踪渠道来源，SDK 会将渠道值填入事件属性 $utm_ 开头的一系列属性中
 *
 * @discussion
 * 注意：如果之前使用 -  trackInstallation: 触发的激活事件，需要继续保持原来的调用，无需改成 - trackAppInstall: ，否则会导致激活事件数据分离。
 *
 * @param properties 激活事件的属性
 */
- (void)trackAppInstallWithProperties:(nullable NSDictionary *)properties;

/**
 * @abstract
 * 用于在 App 首次启动时追踪渠道来源，SDK 会将渠道值填入事件属性 $utm_ 开头的一系列属性中
 *
 * @discussion
 * 注意：如果之前使用 -  trackInstallation: 触发的激活事件，需要继续保持原来的调用，无需改成 - trackAppInstall: ，否则会导致激活事件数据分离。
 *
 * @param properties 激活事件的属性
 * @param disableCallback  是否关闭这次渠道匹配的回调请求
 */
- (void)trackAppInstallWithProperties:(nullable NSDictionary *)properties disableCallback:(BOOL)disableCallback;

/**
 * @abstract
 * 用于在 App 首次启动时追踪渠道来源，SDK 会将渠道值填入事件属性 $utm_ 开头的一系列属性中
 * 使用该接口
 *
 *
 * @param event             event 的名称
 */
- (void)trackInstallation:(NSString *)event;

/**
 * @abstract
 * 用于在 App 首次启动时追踪渠道来源，并设置追踪渠道事件的属性。SDK 会将渠道值填入事件属性 $utm_ 开头的一系列属性中。
 *
 * @discussion
 * propertyDict 是一个 Map。
 * 其中的 key 是 Property 的名称，必须是 NSString
 * value 则是 Property 的内容，只支持 NSString、NSNumber、NSSet、NSArray、NSDate 这些类型
 * 特别的，NSSet 或者 NSArray 类型的 value 中目前只支持其中的元素是 NSString
 *
 *
 * @param event             event 的名称
 * @param propertyDict     event 的属性
 */
- (void)trackInstallation:(NSString *)event withProperties:(nullable NSDictionary *)propertyDict;

/**
 * @abstract
 * 用于在 App 首次启动时追踪渠道来源，并设置追踪渠道事件的属性。SDK 会将渠道值填入事件属性 $utm_ 开头的一系列属性中。
 *
 * @discussion
 * propertyDict 是一个 Map。
 * 其中的 key 是 Property 的名称，必须是 NSString
 * value 则是 Property 的内容，只支持 NSString、NSNumber、NSSet、NSArray、NSDate 这些类型
 * 特别的，NSSet 或者 NSArray 类型的 value 中目前只支持其中的元素是 NSString
 *
 *
 * @param event             event 的名称
 * @param propertyDict     event 的属性
 * @param disableCallback     是否关闭这次渠道匹配的回调请求
 */
- (void)trackInstallation:(NSString *)event withProperties:(nullable NSDictionary *)propertyDict disableCallback:(BOOL)disableCallback;

@end

@interface HNBuildOptions (ChannelMatch)

/// 是否在手动埋点事件中自动添加渠道匹配信息
@property (nonatomic, assign) BOOL enableAutoAddChannelCallbackEvent API_UNAVAILABLE(macos);

@end

NS_ASSUME_NONNULL_END
