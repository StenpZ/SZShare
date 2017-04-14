//
//  SZShareMessage.m
//  SZShare
//
//  Created by cnbs_01 on 17/4/5.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "SZShareMessage.h"

@implementation SZShareMessage

- (BOOL)isEmpty:(NSArray *)emptyValueForKeys AndNotEmpty:(NSArray *)notEmptyValueForKeys {
    @try {
        if (emptyValueForKeys) {
            for (NSString *key in emptyValueForKeys) {
                if ([self valueForKeyPath:key]) {
                    return NO;
                }
            }
        }
        if (notEmptyValueForKeys) {
            for (NSString *key in notEmptyValueForKeys) {
                if (![self valueForKey:key]) {
                    return NO;
                }
            }
        }
        return YES;
    }
    @catch (NSException *exception) {
        NSLog(@"isEmpty error:\n %@",exception);
        return NO;
    }
}

@end
