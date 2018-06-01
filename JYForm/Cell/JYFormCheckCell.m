//
//  JYFormCheckCell.m
//  JYForm
//
//  Created by dqh on 2018/5/3.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormCheckCell.h"

@implementation JYFormCheckCell

- (void)configure
{
    [super configure];
    self.accessoryType = UITableViewCellAccessoryCheckmark;
    self.editingAccessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)update
{
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    self.accessoryType = [self.rowDescriptor.value boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    self.editingAccessoryType = self.accessoryType;
    
    CGFloat red, green, blue, alpha;
    [self.tintColor getRed:&red green:&green blue:&blue alpha:&alpha];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (self.rowDescriptor.disabled) {
        [self setTintColor:[UIColor colorWithRed:red green:green blue:blue alpha:.3]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        [self setTintColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.]];
    }
}

- (void)formDescriptorCellDidSelectedWithForm:(JYForm *)form
{
    self.rowDescriptor.value = @(![self.rowDescriptor.value boolValue]);
    [self.form updateFormRow:self.rowDescriptor];
    [form.tableView deselectRowAtIndexPath:[form.formDescriptor indexPathOfFormRow:self.rowDescriptor] animated:YES];
}

@end
