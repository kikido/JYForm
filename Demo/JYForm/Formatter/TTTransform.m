//
//  TTTransform.m
//  JYForm
//
//  Created by dqh on 2018/4/28.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "TTTransform.h"
#import "NSString+JYFormAdditions.h"

@implementation TTTransform

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    if (!value) return nil;
    if ([value isKindOfClass:[NSArray class]]){
        NSArray * array = (NSArray *)value;

        return [NSString stringWithFormat:[NSString jy_localizedStringForKey:@"%@_%@_Test_Transform"], @(array.count).description, array.count > 1 ? @"s" : @""];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [NSString stringWithFormat:@"%@ - 特殊格式", value];
    }
    return nil;
}

@end
