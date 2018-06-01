//
//  JYFormValidationObject.h
//  JYForm
//
//  Created by dqh on 2018/4/8.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYFormRowDescriptor.h"

@interface JYFormValidationObject : NSObject
@property (nonatomic, copy)   NSString *msg;
@property (nonatomic, weak)   JYFormRowDescriptor *rowDescriptor;
@property (nonatomic, assign) BOOL isValid;

- (instancetype)initWithMsg:(NSString *)msg status:(BOOL)isValid rowDescriptor:(JYFormRowDescriptor *)rowDescriptor;

+ (instancetype)formValidationObjectWithMsg:(NSString *)msg status:(BOOL)isValid rowDescriptor:(JYFormRowDescriptor *)rowDescriptor;
@end
