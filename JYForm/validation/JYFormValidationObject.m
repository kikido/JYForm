//
//  JYFormValidationObject.m
//  JYForm
//
//  Created by dqh on 2018/4/8.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormValidationObject.h"

@implementation JYFormValidationObject

- (instancetype)initWithMsg:(NSString *)msg status:(BOOL)isValid rowDescriptor:(JYFormRowDescriptor *)rowDescriptor
{
    if (self = [super init]) {
        self.msg = msg;
        self.isValid = isValid;
        self.rowDescriptor = rowDescriptor;
    }
    return self;
}

+ (instancetype)formValidationObjectWithMsg:(NSString *)msg status:(BOOL)isValid rowDescriptor:(JYFormRowDescriptor *)rowDescriptor
{
    return [[JYFormValidationObject alloc] initWithMsg:msg status:isValid rowDescriptor:rowDescriptor];
}
@end
