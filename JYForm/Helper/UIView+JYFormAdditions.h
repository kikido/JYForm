//
//  UIView+JYFormAdditions.h
//  JYForm
//
//  Created by dqh on 2018/4/4.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYFormDescriptorCell;
@interface UIView (JYFormAdditions)


+(id)autolayoutView;

/**
 从子视图中找到第一响应者，如果不存在则返回nil

 */
-(UIView *)findFirstResponder;

/**
 在父视图中找到实现协议JYFormDescriptorCell的cell

 @return cell
 */
- (UITableViewCell<JYFormDescriptorCell> *)formDescriptorCell;


/**
 找到当前所在的视图控制器

 */
- (UIViewController *)formController;

@end
