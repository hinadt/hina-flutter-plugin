
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SAStorePlugin <NSObject>

- (NSString *)type;

/// 可以用于将一些重要特殊的 key 进行迁移操作
///
/// SDK 会在注册新插件时，调用该方法
/// 该方法可能会调用多次，每次调用会传入之前注册的插件
///
/// @param oldPlugin 旧插件
- (void)upgradeWithOldPlugin:(id<SAStorePlugin>)oldPlugin;

- (nullable id)objectForKey:(NSString *)key;
- (void)setObject:(nullable id)value forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
