//
//  JYFormDescriptorDelegate.h
//  JYForm
//
//  Created by dqh on 2018/4/3.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYFormSectionDescriptor;
@class JYFormRowDescriptor;



@protocol JYFormDescriptorDelegate <NSObject>


/**
 当section移除formsections后时调用，刷新tableview中section的位置
 
 @param formSection JYFormSectionDescriptor实例
 @param index JYFormSectionDescriptor未被移除前的index
 */
- (void)formSectionHasBeenRemoved:(JYFormSectionDescriptor *)formSection atIndex:(NSUInteger)index;


/**
 当section被添加到formsections后被调用，刷新tableview中section的位置

 @param formSection 被添加的JYFormSectionDescriptor实例
 @param index 被添加的index
 */
- (void)formSectionHasBeenAdded:(JYFormSectionDescriptor *)formSection atIndex:(NSUInteger)index;


/**
 当row被添加到formrows会后被调用，刷新tableview中row的位置

 @param formRow 被添加的JYFormRowDescriptor实例
 @param indexPath 被添加后该实例对象所在的索引路径
 */
- (void)formRowHasBeenAdded:(JYFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath;


/**
 当row被移除formrows后被调用，刷新tableview中row的位置

 @param formRow 被移除的JYFormRowDescriptor实例
 @param indexPath 被移除前该实例对象所在的索引路径
 */
- (void)formRowHasBeenRemoved:(JYFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath;


/**
 调用了row的setdisable方法后被调用，刷新row的内容

 @param formRow JYFormRowDescriptor实例
 */
- (void)formRowDescriptorDisableChanged:(JYFormRowDescriptor *)formRow;
@end
