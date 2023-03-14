

#import <Foundation/Foundation.h>
#import "SAStorePlugin.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SAStoreManagerCompletion)(id _Nullable object);

@interface SABaseStoreManager : NSObject

- (void)registerStorePlugin:(id<SAStorePlugin>)plugin;

#pragma mark - get

- (nullable id)objectForKey:(NSString *)key;
- (void)objectForKey:(NSString *)key completion:(SAStoreManagerCompletion)completion;

- (nullable NSString *)stringForKey:(NSString *)key;
- (nullable NSArray *)arrayForKey:(NSString *)key;
- (nullable NSDictionary *)dictionaryForKey:(NSString *)key;
- (nullable NSData *)dataForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;

#pragma mark - set

- (void)setObject:(nullable id)object forKey:(NSString *)key;

- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (void)setFloat:(float)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;
- (void)setBool:(BOOL)value forKey:(NSString *)key;

#pragma mark - remove

- (void)removeObjectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
