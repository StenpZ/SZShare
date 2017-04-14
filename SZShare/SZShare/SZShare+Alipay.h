//
//  SZShare+Alipay.h
//  SZShare
//
//  Created by cnbs_01 on 17/4/5.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "SZShare.h"

@interface SZShare (Alipay)

+ (void)connectAlipay;
+ (void)AliPay:(NSString*)link Success:(SZPaySuccess)success Fail:(SZPayFail)fail;

@end
