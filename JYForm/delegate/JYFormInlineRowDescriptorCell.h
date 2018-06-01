//
//  JYFormInlineRowDescriptorCell.h
//  JYForm
//
//  Created by dqh on 2018/5/11.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYFormRowDescriptor;

@protocol JYFormInlineRowDescriptorCell <NSObject>

@required
@property (nonatomic, weak) JYFormRowDescriptor *inlineRowDescriptor;
@end
