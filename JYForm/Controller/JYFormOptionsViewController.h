//
//  JYFormOptionsViewController.h
//  JYForm
//
//  Created by dqh on 2018/4/27.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYFormRowDescriptorViewController.h"
#import "JYFormOptionsObject.h"

@interface JYFormOptionsViewController : UITableViewController<JYFormRowDescriptorViewController>
- (instancetype)initWithStyle:(UITableViewStyle)style sectionHeaderTitle:(NSString *)sectionHeaderTitle sectionFooterTitle:(NSString *)sectionFooterTitle;
@end
