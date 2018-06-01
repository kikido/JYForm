//
//  JYFormSliderCell.m
//  JYForm
//
//  Created by dqh on 2018/5/3.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormSliderCell.h"

@interface JYFormSliderCell()
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, assign) NSUInteger steps;
@end

@implementation JYFormSliderCell

@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;

- (void)configure
{
    self.steps = 0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.slider];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailTextLabel];
    [self.contentView addConstraints:[self layoutConstraints]];
    [self valueChanged:self.slider];
}

- (void)update
{
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    self.slider.value = [self.rowDescriptor.value floatValue];
    self.slider.enabled = !self.rowDescriptor.disabled;
    [self valueChanged:self.slider];
}

+ (CGFloat)formDescriptorCellHeightForRowDescriptor:(JYFormRowDescriptor *)rowDescriptor
{
    return 88.;
}

#pragma mark - Target Event

- (void)valueChanged:(UISlider *)sender
{
    if (self.steps != 0) {
        self.slider.value = roundf((self.slider.value-self.slider.minimumValue)/(self.slider.maximumValue-self.slider.minimumValue)*self.steps)*(self.slider.maximumValue-self.slider.minimumValue)/self.steps + self.slider.minimumValue;
    }
    self.detailTextLabel.text = sender.minimumValue > 1 ? [NSString stringWithFormat:@"%.f",sender.value] : [NSString stringWithFormat:@"%.2f",sender.value];
    self.rowDescriptor.value = @(self.slider.value);
}

#pragma mark - Properties

- (UILabel *)textLabel
{
    if (_textLabel == nil) {
        _textLabel = [UILabel autolayoutView];
    }
    return _textLabel;
}

- (UISlider *)slider
{
    if (_slider == nil) {
        _slider = [UISlider autolayoutView];
    }
    return _slider;
}

- (UILabel *)detailTextLabel
{
    if (_detailTextLabel == nil) {
        _detailTextLabel = [UILabel autolayoutView];
    }
    return _detailTextLabel;
}

- (NSArray *)layoutConstraints
{
    NSMutableArray *results = @[].mutableCopy;
    [results addObject:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1. constant:10.]];
    [results addObject:[NSLayoutConstraint constraintWithItem:self.detailTextLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1. constant:10.]];
    [results addObject:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1. constant:44.0]];
    [results addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textLabel]-[detailTextLabel]-|" options:0 metrics:nil views:@{@"textLabel" : self.textLabel, @"detailTextLabel" : self.detailTextLabel}]];
    [results addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[slider]-|" options:0 metrics:nil views:@{@"slider" : self.slider}]];
    
    return results.copy;
}

@end
