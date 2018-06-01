//
//  JYFormSegmentedCell.m
//  JYForm
//
//  Created by dqh on 2018/5/3.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormSegmentedCell.h"

@interface JYFormSegmentedCell()
@property (nonatomic, strong) NSMutableArray *dynamicCustomConstraints;
@end

@implementation JYFormSegmentedCell

@synthesize textLabel = _textLabel;

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.segmentedControl];
    [self.contentView addSubview:self.textLabel];
    [self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew  context:nil];
    [self.segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)update
{
    [super update];
    self.textLabel.text = [NSString stringWithFormat:@"%@%@",self.rowDescriptor.title, self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle ? @"*" : @""];
    [self updateSegmentedControl];
    self.segmentedControl.selectedSegmentIndex = [self selectedIndex];
    self.segmentedControl.enabled = !self.rowDescriptor.disabled;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"] && object == self.textLabel) {
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]) {
            [self.contentView setNeedsUpdateConstraints];
        }
    }
}

#pragma mark - Properties

- (UISegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        _segmentedControl = [UISegmentedControl autolayoutView];
        [_segmentedControl setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _segmentedControl;
}

- (UILabel *)textLabel
{
    if (_textLabel == nil) {
        _textLabel = [UILabel autolayoutView];
        [_textLabel setContentCompressionResistancePriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _textLabel;
}

#pragma mark - Target Event

- (void)valueChanged:(UISegmentedControl *)sender
{
    self.rowDescriptor.value = [self.rowDescriptor.selectorOptions objectAtIndex:self.segmentedControl.selectedSegmentIndex];
}

#pragma mark - Helper

- (NSArray *)getItems
{
    NSMutableArray *results = @[].mutableCopy;
    for (JYFormOptionsObject *optionObject in self.rowDescriptor.selectorOptions) {
        [results addObject:[optionObject displayText]];
    }
    return results.copy;
}

- (void)updateSegmentedControl
{
    [self.segmentedControl removeAllSegments];
    
    [[self getItems] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.segmentedControl insertSegmentWithTitle:[obj displayText] atIndex:idx animated:NO];
    }];
}

- (NSInteger)selectedIndex
{
    if (self.rowDescriptor.value) {
        for (JYFormOptionsObject *optionObject in self.rowDescriptor.selectorOptions) {
            if ([[optionObject valueData] isEqual:[self.rowDescriptor.value valueData]]) {
                return [self.rowDescriptor.selectorOptions indexOfObject:optionObject];
            }
        }
    }
    return UISegmentedControlNoSegment;
}

#pragma mark - Layout Constraints

- (void)updateConstraints
{
    if (self.dynamicCustomConstraints) {
        [self.contentView removeConstraints:self.dynamicCustomConstraints];
    }
    self.dynamicCustomConstraints = @[].mutableCopy;
    NSDictionary *views = @{@"segmentedControl" : self.segmentedControl, @"textLabel" : self.textLabel};
    
    if (self.textLabel.text.length > 0) {
        [self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textLabel]-16-[segmentedControl]-|"
                                                                                                   options:NSLayoutFormatAlignAllCenterY
                                                                                                   metrics:nil
                                                                                                     views:views]];
        [self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[textLabel]-12-|"
                                                                                                   options:0
                                                                                                   metrics:nil
                                                                                                     views:views]];
    } else {
        [self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[segmentedControl]-|"
                                                                                                   options:NSLayoutFormatAlignAllCenterY
                                                                                                   metrics:nil
                                                                                                     views:views]];
        [self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[segmentedControl]-12-|"
                                                                                                   options:0
                                                                                                   metrics:nil
                                                                                                     views:views]];
    }
    [self.contentView addConstraints:self.dynamicCustomConstraints];
    [super updateConstraints];
}

- (void)dealloc
{
    [self.textLabel removeObserver:self forKeyPath:@"text"];
}

@end
