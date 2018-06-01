//
//  JYFormStepCounterCell.m
//  JYForm
//
//  Created by dqh on 2018/5/3.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormStepCounterCell.h"

@interface JYFormStepCounterCell()
@property (nonatomic, strong) UIStepper *stepControl;
@property (nonatomic, strong) UILabel *currentStepValue;
@end

@implementation JYFormStepCounterCell

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.stepControl];
    [self.contentView addSubview:self.currentStepValue];
    
    [self.contentView addConstraints:self.layoutConstraints];
}

- (void)update
{
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    self.stepControl.value = [self.rowDescriptor.value doubleValue];
    self.currentStepValue.text = self.rowDescriptor.value ? [NSString stringWithFormat:@"%@",self.rowDescriptor.value] : nil;
    self.stepControl.enabled = !self.rowDescriptor.disabled;
    
    CGFloat red, green, blue, alpha;
    [self.tintColor getRed:&red green:&green blue:&blue alpha:&alpha];
    if (self.rowDescriptor.disabled) {
        [self setTintColor:[UIColor colorWithRed:red green:green blue:blue alpha:.3]];
        self.currentStepValue.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:.3];
    } else {
        [self setTintColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.]];
        self.currentStepValue.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.];
    }
#ifdef kJYForm_Cell_DetailTextFont
    self.currentStepValue.font = kJYForm_Cell_DetailTextFont;
#endif
}

#pragma mark - Target Event

- (void)valueChanged:(UIStepper *)sender
{
    self.rowDescriptor.value = @(sender.value);
    self.currentStepValue.text = [NSString stringWithFormat:@"%.lf",sender.value];
}

#pragma mark - Properties

- (UIStepper *)stepControl
{
    if (_stepControl == nil) {
        _stepControl = [UIStepper autolayoutView];
        [_stepControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _stepControl;
}

- (UILabel *)currentStepValue
{
    if (_currentStepValue == nil) {
        _currentStepValue = [UILabel autolayoutView];
        _currentStepValue.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _currentStepValue;
}

- (NSArray *)layoutConstraints
{
    NSMutableArray *results = @[].mutableCopy;
    
    [results addObject:[NSLayoutConstraint constraintWithItem:self.stepControl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [results addObject:[NSLayoutConstraint constraintWithItem:self.currentStepValue attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [results addObject:[NSLayoutConstraint constraintWithItem:self.currentStepValue attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.stepControl attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [results addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[value]-5-[step]-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"value" : self.currentStepValue, @"step" : self.stepControl}]];
    return results.copy;
}
@end
