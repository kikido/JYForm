//
//  JYFormRegexValidator.m
//  JYForm
//
//  Created by dqh on 2018/5/7.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormRegexValidator.h"
#import "JYFormRowDescriptor.h"

@implementation JYFormRegexValidator

- (instancetype)initWithMsg:(NSString*)msg regexString:(NSString*)regex
{
    if (self = [super init]) {
        self.msg = msg;
        self.regex = regex;
    }
    return self;
}


+ (JYFormRegexValidator *)formRegexValidatorWithMsg:(NSString *)msg regexString:(NSString *)regex
{
    return [[JYFormRegexValidator alloc] initWithMsg:msg regexString:regex];
}

- (JYFormValidationObject *)isValid:(JYFormRowDescriptor *)row
{
    if (row != nil && row.value != nil && row.value != [NSNull null]) {
        id value = row.value;
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [value stringValue];
        }
        if ([value isKindOfClass:[NSString class]] && [value length] > 0) {
            BOOL isValid = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",self.regex] evaluateWithObject:[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            return [JYFormValidationObject formValidationObjectWithMsg:self.msg status:isValid rowDescriptor:row];
        }
    }
    return nil;
}

@end
