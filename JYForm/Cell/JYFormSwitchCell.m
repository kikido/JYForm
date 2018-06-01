//
//  JYFormSwitchCell.m
//  JYForm
//
//  Created by dqh on 2018/5/3.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormSwitchCell.h"

@implementation JYFormSwitchCell

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryView = [[UISwitch alloc] init];
    self.editingAccessoryView = self.accessoryView;
    [self.switchControl addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)update
{
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    self.switchControl.on = [self.rowDescriptor.value boolValue];
    self.switchControl.enabled = !self.rowDescriptor.disabled;
}

- (UISwitch *)switchControl
{
    return (UISwitch *)self.accessoryView;
}

- (void)valueChanged
{
    self.rowDescriptor.value = @(self.switchControl.on);
}
@end
