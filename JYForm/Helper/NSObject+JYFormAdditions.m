//
//  NSObject+JYFormAdditions.m
//  JYForm
//
//  Created by dqh on 2018/4/8.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "NSObject+JYFormAdditions.h"
#import "JYFormOptionsObject.h"

@implementation NSObject (JYFormAdditions)

- (NSString *)displayText
{
    if ([self isKindOfClass:[JYFormOptionsObject class]]) {
        return [(JYFormOptionsObject *)self formDisplaytext];
    }
    if ([self isKindOfClass:[NSString class]] || [self isKindOfClass:[NSNumber class]]){
        return [self description];
    }
    return nil;
}

- (id)valueData
{
    if ([self isKindOfClass:[NSString class]] || [self isKindOfClass:[NSNumber class]] || [self isKindOfClass:[NSDate class]]){
        return self;
    }
    if ([self isKindOfClass:[NSArray class]]) {
        NSMutableArray * result = [NSMutableArray array];
        [(NSArray *)self enumerateObjectsUsingBlock:^(id obj, NSUInteger __unused idx, BOOL __unused *stop) {
            [result addObject:[obj valueData]];
        }];
        return result;
    }
    if ([self isKindOfClass:[JYFormOptionsObject class]]) {
        return [(JYFormOptionsObject *)self formValue];
    }
    return nil;
}

@end
