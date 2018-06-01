//
//  JYFormRowDescriptorViewController.h
//  JYForm
//
//  Created by dqh on 2018/4/27.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYFormRowDescriptor.h"

@protocol JYFormRowDescriptorViewController <NSObject>
@required
@property (nonatomic, strong) JYFormRowDescriptor * rowDescriptor;
@property (nonatomic, strong) JYForm *form;
@end
