//
//  JYFormBaseCell.h
//  JYForm
//
//  Created by dqh on 2018/4/4.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYFormDescriptorCell.h"
#import "JYForm.h"

#import "JYFormAppearanceConfig.h"


@interface JYFormBaseCell : UITableViewCell <JYFormDescriptorCell>

@property (nonatomic, weak) JYFormRowDescriptor *rowDescriptor;
- (JYForm *)form;
@end

@protocol JYFormReturnKeyProtocol <NSObject>
@property (nonatomic, assign) UIReturnKeyType returnKeyType;
@property (nonatomic, assign) UIReturnKeyType nextReturnKeyType;
@end
