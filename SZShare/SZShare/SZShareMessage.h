//
//  SZShareMessage.h
//  SZShare
//
//  Created by cnbs_01 on 17/4/5.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 分享类型，除了news以外，还可能是video／audio／app等。
 */
typedef NS_ENUM(NSUInteger, SZMultimediaType) {
    SZMultimediaTypeNews,
    SZMultimediaTypeAudio,
    SZMultimediaTypeVideo,
    SZMultimediaTypeApp,
    SZMultimediaTypeFile,
    SZMultimediaTypeUndefined
};

@interface SZShareMessage : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, copy) NSString *link;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImage *thumbnail;
@property(nonatomic) SZMultimediaType multimediaType;

#pragma mark - 微信
@property(nonatomic, copy) NSString *extInfo;
@property(nonatomic, copy) NSString *mediaDataUrl;
@property(nonatomic, copy) NSString *fileExt;
@property(nonatomic, strong) NSData *file; //!< 微信分享gif/文件

/**
 *  判断emptyValueForKeys的value都是空的，notEmptyValueForKeys的value都不是空的。
 *
 *  @param emptyValueForKeys    空值的key
 *  @param notEmptyValueForKeys 非空值的key
 *
 *  @return YES／NO
 */
- (BOOL)isEmpty:(NSArray *)emptyValueForKeys AndNotEmpty:(NSArray *)notEmptyValueForKeys;

@end
