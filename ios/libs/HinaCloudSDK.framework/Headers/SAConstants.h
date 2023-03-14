
#import <Foundation/Foundation.h>


#pragma mark - typedef
/**
 * @abstract
 * Debug 模式，用于检验数据导入是否正确。该模式下，事件会逐条实时发送并根据返回值检查
 * 数据导入是否正确。
 *
 * @discussion
 *
 * Debug模式有三种选项:
 *   SensorsAnalyticsDebugOff - 关闭 DEBUG 模式
 *   SensorsAnalyticsDebugOnly - 打开 DEBUG 模式，但该模式下发送的数据仅用于调试，不进行数据导入
 *   SensorsAnalyticsDebugAndTrack - 打开 DEBUG 模式，并将数据导入
 */
typedef NS_ENUM(NSInteger, SensorsAnalyticsDebugMode) {
    SensorsAnalyticsDebugOff,
    SensorsAnalyticsDebugOnly,
    SensorsAnalyticsDebugAndTrack,
};

/**
 * @abstract
 * TrackTimer 接口的时间单位。调用该接口时，传入时间单位，可以设置 event_duration 属性的时间单位。
 *
 * @discuss
 * 时间单位有以下选项：
 *   SensorsAnalyticsTimeUnitMilliseconds - 毫秒
 *   SensorsAnalyticsTimeUnitSeconds - 秒
 *   SensorsAnalyticsTimeUnitMinutes - 分钟
 *   SensorsAnalyticsTimeUnitHours - 小时
 */
typedef NS_ENUM(NSInteger, SensorsAnalyticsTimeUnit) {
    SensorsAnalyticsTimeUnitMilliseconds,
    SensorsAnalyticsTimeUnitSeconds,
    SensorsAnalyticsTimeUnitMinutes,
    SensorsAnalyticsTimeUnitHours
};


/**
 * @abstract
 * AutoTrack 中的事件类型
 *
 * @discussion
 *   HNAutoTrackAppStart - $AppStart
 *   HNAutoTrackAppEnd - $AppEnd
 *   HNAutoTrackAppClick - $AppClick
 *   HNAutoTrackAppScreen - $AppViewScreen
 */
typedef NS_OPTIONS(NSInteger, SensorsAnalyticsAutoTrackEventType) {
    HNAutoTrackNone      = 0,
    HNAutoTrackAppStart      = 1 << 0,
    HNAutoTrackAppEnd        = 1 << 1,
    HNAutoTrackAppClick      = 1 << 2,
    HNAutoTrackAppScreen = 1 << 3,
};

/**
 * @abstract
 * 网络类型
 *
 * @discussion
 *   HNNetworkTypeNONE - NULL
 *   HNNetworkType2G - 2G
 *   HNNetworkType3G - 3G
 *   HNNetworkType4G - 4G
 *   HNNetworkTypeWIFI - WIFI
 *   HNNetworkTypeALL - ALL
 *   HNNetworkType5G - 5G   
 */
typedef NS_OPTIONS(NSInteger, HNNetworkType) {
    HNNetworkTypeNONE         = 0,
    HNNetworkType2G API_UNAVAILABLE(macos)    = 1 << 0,
    HNNetworkType3G API_UNAVAILABLE(macos)    = 1 << 1,
    HNNetworkType4G API_UNAVAILABLE(macos)    = 1 << 2,
    HNNetworkTypeWIFI     = 1 << 3,
    HNNetworkTypeALL      = 0xFF,
#ifdef __IPHONE_14_1
    HNNetworkType5G API_UNAVAILABLE(macos)   = 1 << 4
#endif
};

/// 事件类型
typedef NS_OPTIONS(NSUInteger, SAEventType) {
    SAEventTypeTrack = 1 << 0,
    SAEventTypeSignup = 1 << 1,
    SAEventTypeBind = 1 << 2,
    SAEventTypeUnbind = 1 << 3,

    SAEventTypeProfileSet = 1 << 4,
    SAEventTypeProfileSetOnce = 1 << 5,
    SAEventTypeProfileUnset = 1 << 6,
    SAEventTypeProfileDelete = 1 << 7,
    SAEventTypeProfileAppend = 1 << 8,
    SAEventTypeIncrement = 1 << 9,

    SAEventTypeItemSet = 1 << 10,
    SAEventTypeItemDelete = 1 << 11,

    SAEventTypeDefault = 0xF,
    SAEventTypeAll = 0xFFFFFFFF,
};

typedef NSString *SALimitKey NS_TYPED_EXTENSIBLE_ENUM;
FOUNDATION_EXTERN SALimitKey const SALimitKeyIDFA;
FOUNDATION_EXTERN SALimitKey const SALimitKeyIDFV;
FOUNDATION_EXTERN SALimitKey const SALimitKeyCarrier;
