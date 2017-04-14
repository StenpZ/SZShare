//
//  SZShare.h
//  SZShare
//
//  Created by cnbs_01 on 17/4/5.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZShareMessage.h"

typedef void (^SZShareSuccess)(SZShareMessage *message);
typedef void (^SZShareFail)(SZShareMessage *message, NSError *error);
typedef void (^SZAuthSuccess)(NSDictionary *message);
typedef void (^SZAuthFail)(NSDictionary *message, NSError *error);
typedef void (^SZPaySuccess)(NSDictionary *message);
typedef void (^SZPayFail)(NSDictionary *message, NSError *error);

/**
 粘贴板数据编码方式，目前只有两种:
 1. [NSKeyedArchiver archivedDataWithRootObject:data];
 2. [NSPropertyListSerialization dataWithPropertyList:data format:NSPropertyListBinaryFormat_v1_0 options:0 error:&err];
 */
typedef NS_ENUM(NSUInteger, SZPboardEncoding) {
    SZPboardEncodingKeyedArchiver,
    SZPboardEncodingPropertyListSerialization
};

typedef NS_ENUM(NSUInteger, SZPlatformType) {
    SZPlatformTypeNone = 0,
    SZPlatformTypeSinaWeibo = 1,
    SZPlatformTypeQQ = 2,
    SZPlatformTypeWeChat = 3,
};

typedef NS_ENUM(NSUInteger, SZPlatformSubType) {
    SZPlatformSubTypeNone = 0,
    SZPlatformSubTypeQQFriend = 21,
    SZPlatformSubTypeQQZone = 22,
    SZPlatformSubTypeWeChatSession = 31,
    SZPlatformSubTypeWeChatTimeline = 32
};

typedef NS_ENUM(NSUInteger, SZShareState) {
    SZShareStateWithOutSupportPlatform = 0,
    SZShareStateSuccess,
    SZShareStateFailure,
    SZShareStateCancel
};

typedef NS_ENUM(NSInteger, SZShareType) {
    SZShareTypeNomal,
    SZShareTypeImage
};

@interface SZShare : NSObject

#pragma mark - 保存信息
/**
 *  设置平台的key
 *
 *  @param platform 平台名称
 *  @param key      NSDictionary格式的key
 */
+ (void)set:(NSString *)platform Keys:(NSDictionary *)key;

/**
 *  获取平台的key
 *
 *  @param platform 平台名称，每个category自行决定。
 *
 *  @return 平台的key(NSDictionary或nil)
 */
+ (NSDictionary *)keyFor:(NSString *)platform;

/**
 注册
 
 @param platforms SZPlatformType 数组 （@(SZPlatformTypeSinaWeibo)...）
 @param configurationBlock 注册回调
 */
+ (void)registerPlatforms:(NSArray *)platforms onConfiguration:(void (^)(SZPlatformType platform))configurationBlock;

/**
 *  通过UIApplication打开url
 *
 *  @param url 需要打开的url
 */
+ (void)openURL:(NSString *)url;
+ (BOOL)canOpen:(NSString *)url;
/**
 *  处理被打开时的openurl
 *
 *  @param url openurl
 *
 *  @return 如果能处理，就返回YES。够则返回NO
 */
+ (BOOL)handleOpenURL:(NSURL *)url;
#pragma mark - 处理

+ (SZShareSuccess)shareSuccessCallback;

+ (SZShareFail)shareFailCallback;

+ (void)setShareSuccessCallback:(SZShareSuccess)suc;

+ (void)setShareFailCallback:(SZShareFail)fail;

+ (NSURL *)returnedURL;

+ (NSDictionary *)returnedData;

+ (void)setReturnedData:(NSDictionary *)retData;

+ (NSMutableDictionary *)parseUrl:(NSURL *)url;

+ (void)setMessage:(SZShareMessage *)msg;

+ (SZShareMessage *)message;

+ (BOOL)beginShare:(NSString *)platform Message:(SZShareMessage *)msg Success:(SZShareSuccess)success Fail:(SZShareFail)fail;
+ (BOOL)beginAuth:(NSString *)platform Success:(SZAuthSuccess)success Fail:(SZAuthFail)fail;

+ (NSString *)base64Encode:(NSString *)input;
+ (NSString *)base64Decode:(NSString *)input;
+ (NSString *)CFBundleDisplayName;
+ (NSString *)CFBundleIdentifier;

+ (void)setGeneralPasteboard:(NSString *)key Value:(NSDictionary *)value encoding:(SZPboardEncoding)encoding;
+ (NSDictionary *)generalPasteboardData:(NSString *)key encoding:(SZPboardEncoding)encoding;
+ (NSString *)base64AndUrlEncode:(NSString *)string;
+ (NSString *)urlDecode:(NSString *)input;
+ (UIImage *)screenshot;

+ (SZAuthSuccess)authSuccessCallback;
+ (SZAuthFail)authFailCallback;

+ (void)setPaySuccessCallback:(SZPaySuccess)suc;

+ (void)setPayFailCallback:(SZPayFail)fail;

+ (SZPaySuccess)paySuccessCallback;
+ (SZPayFail)payFailCallback;

+ (NSData *)dataWithImage:(UIImage *)image;
+ (NSData *)dataWithImage:(UIImage *)image scale:(CGSize)size;

@end
