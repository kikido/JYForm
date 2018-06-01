//
//  DateTransformer.m
//  JYForm
//
//  Created by dqh on 2018/5/4.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "DateTransformer.h"
@interface DateTransformer()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation DateTransformer

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
    
    if ([value isKindOfClass:[NSDate class]])
    {
        return [self.dateFormatter stringFromDate:(NSDate *)value];
    }
    return nil;
}

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter == nil) {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateFormatter;
}

@end
