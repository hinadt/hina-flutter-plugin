

#import "SAEncryptProtocol.h"
#import "HNBuildOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface HNBuildOptions (Encrypt)

/// 是否开启加密
@property (nonatomic, assign) BOOL enableEncrypt API_UNAVAILABLE(macos);

- (void)registerEncryptor:(id<SAEncryptProtocol>)encryptor API_UNAVAILABLE(macos);

/// 存储公钥的回调。务必保存秘钥所有字段信息
@property (nonatomic, copy) void (^saveSecretKey)(SASecretKey * _Nonnull secretKey) API_UNAVAILABLE(macos);

/// 获取公钥的回调。务必回传秘钥所有字段信息
@property (nonatomic, copy) SASecretKey * _Nonnull (^loadSecretKey)(void) API_UNAVAILABLE(macos);

@end

NS_ASSUME_NONNULL_END
