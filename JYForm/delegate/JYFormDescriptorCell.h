//
//  JYFormDescriptorCell.h
//  JYForm
//
//  Created by dqh on 2018/4/4.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYFormRowDescriptor.h"

@class JYForm;

@protocol JYFormDescriptorCell <NSObject>

@required
///|< 实现了JYFormDescriptorCell协议的类需要手动添加JYFormRowDescriptor属性
@property (nonatomic, weak) JYFormRowDescriptor *rowDescriptor;


/**
 初始化控件以及一些数据，在cell被创建时会被调用，只被调用一次
 */
- (void)configure;

/**
 更新cell的控件，能被多次调用
 */
- (void)update;

@optional

/**
 如果你没有指定JYFormRowDescriptor的height属性，并且这个方法被实现了，那么cell的高度为这个方法的返回值。

 @param rowDescriptor JYFormRowDescriptor的实例
 @return JYFormRowDescriptor对应的cell的高度
 */
+ (CGFloat)formDescriptorCellHeightForRowDescriptor:(JYFormRowDescriptor *)rowDescriptor;


/**
 返回一个bool值，指示cell能够成为第一响应者,默认返回NO

 @return 如果cell可以成为第一响应者的话返回YES，否则返回NO
 */
- (BOOL)formDescriptorCellCanBecomeFirstResponder;


/**
 让当前的cell成为第一响应者

 @return 如果cell是第一响应者了返回YES，否则返回NO
 */
- (BOOL)formDescriptorCellBecomeFirstResponder;


/**
 当前的cell被选中了

 @param form cell被添加到的JYForm的实例
 */
- (void)formDescriptorCellDidSelectedWithForm:(JYForm *)form;


/**
 为该cell设置一个HttpParameterName，那么当调用JYFormDescriptor的实例方法-(void)httpParameters时，则会将该行，以方法返回值为key，值为value添加到结果字典中

 @return 为该cell设置一个HttpParameterName，不能为空
 */
- (NSString *)formDescriptorHttpParameterName;


/**
 当cell成为第一响应者时被调用，可以通过该方法改变cell的样式
 */
-(void)highlight;


/**
 当cell退出第一响应者时被调用
 */
-(void)unhighlight;
@end
