//
//  SZShare+WeChat.h
//  SZShare
//
//  Created by cnbs_01 on 17/4/5.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "SZShare.h"

@interface SZShare (WeChat)

/**
 *  https://open.weixin.qq.com 在这里申请
 *
 *  @param appId AppID
 */
+ (void)connectWeixinWithAppId:(NSString *)appId;
+ (BOOL)isWeixinInstalled;

+ (void)shareToWeixinSession:(SZShareMessage *)msg Success:(SZShareSuccess)success Fail:(SZShareFail)fail;
+ (void)shareToWeixinTimeline:(SZShareMessage *)msg Success:(SZShareSuccess)success Fail:(SZShareFail)fail;
+ (void)shareToWeixinFavorite:(SZShareMessage *)msg Success:(SZShareSuccess)success Fail:(SZShareFail)fail;
+ (void)WeixinAuth:(NSString *)scope Success:(SZAuthSuccess)success Fail:(SZAuthFail)fail;
+ (void)WeixinPay:(NSString *)link Success:(SZPaySuccess)success Fail:(SZPayFail)fail;

@end
