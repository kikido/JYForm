//
//  JYFormRegexValidator.h
//  JYForm
//
//  Created by dqh on 2018/5/7.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYFormValidatorProtocol.h"

@class JYFormRowDescriptor;

@interface JYFormRegexValidator : NSObject <JYFormValidatorProtocol>
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *regex;

- (instancetype)initWithMsg:(NSString*)msg regexString:(NSString*)regex;
+ (JYFormRegexValidator *)formRegexValidatorWithMsg:(NSString *)msg regexString:(NSString *)regex;

@end
