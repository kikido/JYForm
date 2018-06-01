//
//  JYFormDatePickerCell.m
//  JYForm
//
//  Created by dqh on 2018/5/11.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormDatePickerCell.h"

@implementation JYFormDatePickerCell

@synthesize datePicker = _datePicker;
@synthesize inlineRowDescriptor = _inlineRowDescriptor;

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (UIDatePicker *)datePicker
{
    if (_datePicker == nil) {
        _datePicker = [UIDatePicker autolayoutView];
        [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    if (self.inlineRowDescriptor) {
        self.inlineRowDescriptor.value = sender.date;
        [self.form updateFormRow:self.inlineRowDescriptor];
    } else {
        [self becomeFirstResponder];
        self.rowDescriptor.value = sender.date;
    }
}

#pragma mark - JYFormDescriptorCell

- (void)configure
{
    [super configure];
    [self.contentView addSubview:self.datePicker];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.datePicker attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[datePicker]-0-|" options:0 metrics:0 views:@{@"datePicker" : self.datePicker}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[datePicker]-0-|" options:0 metrics:0 views:@{@"datePicker" : self.datePicker}]];
}

- (void)update
{
    [super update];
    [self.datePicker setUserInteractionEnabled:!self.rowDescriptor.disabled];
}

+ (CGFloat)formDescriptorCellHeightForRowDescriptor:(JYFormRowDescriptor *)rowDescriptor
{
    return 216.;
}
@end
