//
//  JYFormValidatorProtocol.h
//  JYForm
//
//  Created by dqh on 2018/4/4.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYFormValidationObject.h"

@class JYFormRowDescriptor;

@protocol JYFormValidatorProtocol <NSObject>

/**
 使用该方法来验证JYFormRowDescriptor，如果通过验证返回nil，不通过返回一个JYFormValidationObject实例

 @param row 待验证的JYFormRowDescriptor实例
 @return 如果不通过一个JYFormValidationObject实例，包含错误信息等
 */
- (JYFormValidationObject *)isValid:(JYFormRowDescriptor *)row;
@end
