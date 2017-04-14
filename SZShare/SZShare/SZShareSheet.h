//
//  SZShareSheet.h
//  SZShare
//
//  Created by cnbs_01 on 17/4/5.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZShare.h"

typedef void(^SZShareStateChangedBlock)(SZShareState state);

@interface SZSharePlatformItem : NSObject

@property (nonatomic) SZPlatformType type;
@property (nonatomic) SZPlatformSubType subType;
@property (nonatomic, copy) NSString *itemLogo;
@property (nonatomic, copy) NSString *itemTitle;

/*! 默认分享平台 */
+ (NSArray *)defaultPlatformItems;

@end

@interface SZShareSheet : UIView

+ (NSArray *)platformItems;
/*! 设置分享平台 */
+ (void)setPlatformItems:(NSArray *)platforms;

/*! 弹出默认分享框 */
+ (instancetype)shareToPlatformsWithMessage:(SZShareMessage *)message onShareStateChanged:(SZShareStateChangedBlock)block;

@end
