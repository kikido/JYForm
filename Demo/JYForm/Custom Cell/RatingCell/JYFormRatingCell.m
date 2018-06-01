//
//  JYFormRatingCell.m
//  JYForm
//
//  Created by dqh on 2018/5/10.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormRatingCell.h"

NSString *const JYFormRowDescriptorTypeRate = @"JYFormRowDescriptorTypeRate";

@implementation JYFormRatingCell

+ (void)load
{
    [JYForm.cellClassesForRowDescriptorTypes setObject:[JYFormRatingCell class] forKey:@"JYFormRowDescriptorTypeRate"];
}

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.rateTitle = [UILabel new];
    self.rateTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.rateTitle];
    
    self.ratingView = [[JYRatingView alloc] init];
    self.ratingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.ratingView addTarget:self action:@selector(rateChanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.ratingView];
    
    [self.ratingView setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    [self.ratingView setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];

    NSDictionary *views = @{@"ratingView" : self.ratingView, @"rateTitle" : self.rateTitle};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[ratingView]-(margin)-|"
                                                                             options:NSLayoutFormatAlignAllBaseline
                                                                             metrics:@{@"margin" : @11.0}
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[rateTitle]-(margin)-|"
                                                                             options:NSLayoutFormatAlignAllBaseline
                                                                             metrics:@{@"margin" : @11.0}
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[rateTitle]-[ratingView]-|" options:0 metrics:nil views:views]];
}

- (void)update
{
    [super update];
    
    self.ratingView.value = [self.rowDescriptor.value floatValue];
    self.rateTitle.text = self.rowDescriptor.title;
    
    [self.ratingView setAlpha:self.rowDescriptor.disabled ? .6 : 1];
    [self.rateTitle setAlpha:self.rowDescriptor.disabled ? .6 : 1];
    self.rateTitle.textColor = self.rowDescriptor.disabled ? kJYForm_Cell_MainDisableTextColor : kJYForm_Cell_MainTextColor;
}

-(void)rateChanged:(AXRatingView *)ratingView
{
    self.rowDescriptor.value = [NSNumber numberWithFloat:ratingView.value];
}

@end
