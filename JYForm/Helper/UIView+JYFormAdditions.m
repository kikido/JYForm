//
//  UIView+JYFormAdditions.m
//  JYForm
//
//  Created by dqh on 2018/4/4.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "UIView+JYFormAdditions.h"
#import "JYFormDescriptorCell.h"

@implementation UIView (JYFormAdditions)

+ (id)autolayoutView
{
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

- (UIView *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}

- (UITableViewCell<JYFormDescriptorCell> *)formDescriptorCell
{
    if ([self isKindOfClass:[UITableViewCell class]]) {
        if ([self conformsToProtocol:@protocol(JYFormDescriptorCell)]){
            return (UITableViewCell<JYFormDescriptorCell> *)self;
        }
        return nil;
    }
    if (self.superview) {
        UITableViewCell<JYFormDescriptorCell> *tableViewCell = [self.superview formDescriptorCell];
        if (tableViewCell != nil) {
            return tableViewCell;
        }
    }
    return nil;
}

- (UIViewController *)formController
{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    
    return nil;
}

@end
