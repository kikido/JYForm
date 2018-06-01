//
//  JYFormButtonCell.m
//  JYForm
//
//  Created by dqh on 2018/5/3.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormButtonCell.h"
#import "JYFormRowDescriptorViewController.h"

@implementation JYFormButtonCell

- (void)configure
{
    [super configure];
}

- (void)update
{
    [super update];
    
    self.textLabel.text = self.rowDescriptor.title;
    self.textLabel.textAlignment = self.rowDescriptor.action.viewControllerClass ? NSTextAlignmentNatural : NSTextAlignmentCenter;
    self.accessoryType = self.rowDescriptor.disabled || !self.rowDescriptor.action.viewControllerClass ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
    self.editingAccessoryType = self.accessoryType;
    self.selectionStyle = self.rowDescriptor.disabled ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    
    self.detailTextLabel.text = self.rowDescriptor.value;
}

- (void)formDescriptorCellDidSelectedWithForm:(JYForm *)form
{
    if (self.rowDescriptor.action.rowBlock) {
        self.rowDescriptor.action.rowBlock(self.rowDescriptor);
    }
    else if (self.rowDescriptor.action.viewControllerClass){
        UIViewController *controllerToPresent = [[self.rowDescriptor.action.viewControllerClass alloc] init];
        if (controllerToPresent) {
            if ([controllerToPresent conformsToProtocol:@protocol(JYFormRowDescriptorViewController)]) {
                ((UIViewController<JYFormRowDescriptorViewController> *)controllerToPresent).rowDescriptor = self.rowDescriptor;
                ((UIViewController<JYFormRowDescriptorViewController> *)controllerToPresent).form = form;
            }
            if (form.formController.navigationController == nil || [controllerToPresent isKindOfClass:[UINavigationController class]] || self.rowDescriptor.action.viewControllerPresentationMode == JYFormPresentationModePresent) {
                [form.formController presentViewController:controllerToPresent animated:YES completion:nil];
            } else {
                [form.formController.navigationController pushViewController:controllerToPresent animated:YES];
            }
        }
    }
    [form.tableView deselectRowAtIndexPath:[form.formDescriptor indexPathOfFormRow:self.rowDescriptor] animated:YES];
}

@end
